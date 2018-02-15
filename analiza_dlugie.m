%directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
names = {'Kasia_K','Magda P','Ewa_K','Agnieszka_K','Krystyna',...
    'Surala','Klaudia_W', 'Mikolaj_M','Michal_P','Krzysztof_B',...
    'Justyna_G','Alicja_B'};
name_idx = 1; 
name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
SaveFlag = 0;
y_lim = [-15 20];
[a, b, c, short, long, longest] = wczytanie(directory_name);
%b - 1 - # of long trials
n = 25; %length(data.sfe.fp)
m = 5; %length(data.sfe.fclist)
general.L = zeros(1,n);
general.R = zeros(1,n); %it could be initialised once, but then it gives warnings
gen_mean.L = zeros(1,m);
gen_mean.R = zeros(1,m);
small = zeros(1,m);

l.R = 0;
l.L = 0;
ears = ['L';'o';'R'];
figure(1)
for i=1:b-1 %for each trial in dataset
    data = long{i,3};
    y = real(20*log10(data.sfe.dP));
    hold on
    for d=['L','R']
        if long{i,1}==d
            k=find(ears==d);
            subplot(2,2,k); 
            for j=1:m
                small(j) = mean(y((j-1)*m+1 :(j-1)*m+m));
            end
            plot(data.sfe.fclist,small,'s-.')
            general.(d)(l.(d)+1,:)= y;
            gen_mean.(d)(l.(d)+1,:)= small;
            l.(d) = l.(d) + 1;
        end
    end
end
clear i j small 
            
subplot(2,2,1); 
title('Long SFOAE, "L" ear')
pl = plot(data.sfe.fclist, mean(gen_mean.L),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');
legend(pl)
xlabel('Frequency [Hz]'); ylabel('Mean SFOAE [dB SPL]'); 
xlim([800 4200]); ylim(y_lim)

subplot(2,2,3); 
title('Long SFOAE, "R" ear')
xlabel('Frequency [Hz]'); ylabel('Mean SFOAE [dB SPL]')
pr = plot(data.sfe.fclist,mean(gen_mean.R),'r', 'LineWidth', 1.5, 'DisplayName','Mean'); 
legend(pr, 'Location', 'southwest')
xlim([800 4200]); ylim(y_lim)

subplot(2,2,2); boxplot(gen_mean.L,round(data.sfe.fclist,-1)); ylim(y_lim)
%xlabel('Frequency [Hz]')
subplot(2,2,4); boxplot(gen_mean.R,round(data.sfe.fclist,-1)); ylim(y_lim)
%xlabel('Frequency [Hz]')
if SaveFlag
    print(['long_SFOAE_trials_boxplots_' name], '-dpng', '-noui')
end
InterTrialPlot(m, gen_mean, data.sfe.fclist, l, 'LongSFOAE', name,SaveFlag)
StdPlot(data.sfe.fclist, gen_mean, 'Long SFOAE',name,SaveFlag)
