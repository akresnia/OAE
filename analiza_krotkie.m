%directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
%in the previous version when you run analiza_krotkie -> analiza_dlugie first plots overlap and can
%be compared
name = 'Mikolaj'; 
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
SaveFlag = 0;
y_lim = [-3 25];
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
%a - 1 - # of short trials
n = 4; %length(data.sfe.fp)
general.L = zeros(1,n);
general.R = zeros(1,n);

l.R = 0;
l.L = 0;

for i=1:a-1 %for each trial in dataset
    data = short{i,3};
    y = real(20*log10(data.sfe.dP));
    for d=['L','R']
        if short{i,1}==d
            general.(d)(l.(d)+1,:)= y;
            l.(d) = l.(d) + 1;
        end
    end
end
clear i j d
            
subplot(2,col,1);
xlim([800 4200]); ylim(y_lim)
hold on
plot(data.sfe.fp,general.L','s-.'); title('Quick SFOAE, "L" ear')
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
plot(data.sfe.fp,general.R','s-.'); title('Quick SFOAE, "R" ear')
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
