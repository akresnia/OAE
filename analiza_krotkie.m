%directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
%in the previous version when you run analiza_krotkie -> analiza_dlugie first plots overlap and can
%be compared
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Surala','Klaudia_W', 'Mikolaj_M','Michal_P','Krzysztof_B',...
    'Justyna_G','Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', ...
    'Kasia_P','Monika_W','Teresa_B','Ula_M','Urszula_O', ...
    };
name_idx = 19; 
snr_value = 9;
name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
SaveFlag = 0;
y_lim = [-20 25]; %make dynamical!
leg = 0; %legend flag

col = 2; pos = 3; %subplot values
if leg
    col = 1;
    pos = 2;
    %figure('Position',[200 100 850 450])
else
    figure(1) %to allow comparison with longer trials
end    

[a, b, c, short, long, longest] = wczytanie(directory_name);
%a - 1 = # of short trials
n = 4; %length(data.sfe.fp)
general.L = zeros(1,n); %zmieniæ na dane w wierszach? naprawiæ freqs
general.R = zeros(1,n);


l.R = 0;
l.L = 0;

for i=1:a-1 %for each trial in dataset
    data = short{i,3};
    y = real(20*log10(data.sfe.dP));
    for d=['L','R']
        if short{i,1}==d
            general.(d)(l.(d)+1,:)= y; %data in columns
            noise_idx.(d)(l.(d)+1,:) = (data.eval.snr<snr_value); %idcs in rows
            l.(d) = l.(d) + 1;
        end
    end
end
clear i j d
            
subplot(2,col,1);
xlim([800 4200]); ylim(y_lim)
hold on
plot(data.sfe.fp,general.L','-.'); title('Quick SFOAE, "L" ear')

f = data.sfe.fp;
freqs = repmat(f,l.L,1);
scatter(freqs(noise_idx.L), general.L(noise_idx.L), 30, 'r')
scatter(freqs(~noise_idx.L), general.L(~noise_idx.L)', 30, 'g', 'filled')

pl = plot(data.sfe.fp,mean(general.L),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');
if leg
legend('Location', 'westoutside')
else
legend(pl, 'Location','northwest')
end
ylabel('Level [dB SPL]')
hold off

subplot(2,col,pos); 
xlim([800 4200]); ylim(y_lim)
xlabel('Frequency [Hz]'); ylabel('Level [dB SPL]')
hold on
plot(data.sfe.fp,general.R','-.'); title('Quick SFOAE, "R" ear')
freqs2 = repmat(f,l.R,1);
scatter(freqs2(noise_idx.R), general.R(noise_idx.R), 30, 'r')
scatter(freqs2(~noise_idx.R), general.R(~noise_idx.R), 30, 'g', 'filled')

pr = plot(data.sfe.fp,mean(general.R),'r', 'LineWidth', 1.5, 'DisplayName','Mean'); 
if leg
    legend('Location','westoutside')
else
    legend(pr, 'Location','southwest')
end
hold off

if leg && SaveFlag
    print(['short_SFOAE_trials_' name], '-dpng', '-noui')
elseif ~leg
    subplot(2,2,2); boxplot(general.L,round(data.sfe.fp,-1)); ylim(y_lim)
    %xlabel('Frequency [Hz]')
    subplot(2,2,4); boxplot(general.R,round(data.sfe.fp,-1)); ylim(y_lim)
    %xlabel('Frequency [Hz]')
    if SaveFlag
        print(['short_SFOAE_trials_boxplots_' name], '-dpng', '-noui')
    end
end
InterTrialPlot(n, general, data.sfe.fp, l, 'Short SFOAE', name,SaveFlag)
StdPlot(data.sfe.fp, general, 'Short SFOAE',name,SaveFlag)
