clear all
%directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Surala','Klaudia_W', 'Mikolaj_M','Michal_P','Krzysztof_B',...
    'Justyna_G','Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', ...
    'Kasia_P','Monika_W','Teresa_B','Ula_M','Urszula_O', ...
    };
name_idx = 19; 
snr_value = 9;
SaveFlag = 0;
y_lim = [-15 20];

%% loading data
name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
[a, b, c, short, long, longest] = wczytanie(directory_name);
%b - 1 - # of long trials
n = 25; %length(data.sfe.fp)
m = 5; %length(data.sfe.fclist)

el.R = 0;
el.L = 0;
ears = ['L';'o';'R'];

%% creating matrices for plotting
for i=1:b-1 %for each trial in dataset
    data = long{i,3};
    y = real(20*log10(data.sfe.dP));
    y_clusters = reshape(y,[],m); %clusters in columns
    noisy_pts = (data.eval.snr<snr_value);
    noise_clusters = reshape(noisy_pts,[],m);
    snr_clusters = reshape(data.eval.snr,[],m);
    [val,id] = max(snr_clusters); %over columns=freqs
    [tf,loc] = ismember(val, data.eval.snr); %finding indices of points with max snr over freqs' clusters
    max_snr_vals = y(loc);

    d=long{i,1};
    if d=='L' || d=='R'
        el.(d) = el.(d) + 1;
        small= mean(y_clusters);
        y_clusters(noise_clusters) = NaN;
        small_clean = mean(y_clusters, 'omitnan');
        noisy_clust = isnan(small_clean); %clusters without good snr measurements

        general.(d)(el.(d),:)= y;
        gen_mean.(d)(el.(d),:)= small;
        gen_mean_clean.(d)(el.(d),:)= small_clean; %may contain nans
        gen_max_snr.(d)(el.(d),:)= max_snr_vals;
        noise_idx.(d)(el.(d),:) = noisy_pts; % 25 idcs in rows
        noise_clu.(d)(el.(d),:) = noisy_clust; % 5 idcs in rows      
    end
end
clear i j small 

%% plotting
% grean dots are mean values in clusters calculated from measurements with
% good snr
figure()
for d=['L','R'] 
    hold on
    k=find(ears==d);
    subplot(2,2,k);    
    f = data.sfe.fclist;
    freqs = repmat(f,el.(d),1);
    plot(data.sfe.fclist,gen_max_snr.(d),'-.')
    hold on
    scatter(freqs(noise_clu.(d)), gen_max_snr.(d)(noise_clu.(d)), 30, 'r')
    scatter(freqs(~noise_clu.(d)), gen_max_snr.(d)(~noise_clu.(d))', 30, 'g', 'filled')

    title(['Long SFOAE "' d '" ear'])
    pl = plot(data.sfe.fclist, mean(gen_mean.(d)),'r', 'LineWidth', 1.5, ...
    'DisplayName', 'Noisy Mean');
    legend(pl)
    xlabel('Frequency [Hz]'); ylabel('Mean SFOAE [dB SPL]'); 
    xlim([800 4200]); ylim(y_lim)
    
    % fraction of measurements that pass snr criterion
    s = sum(noise_idx.(d)(:));
    den = length(noise_idx.(d)(:));
    p=den-s;
    fr = p/den ;
    text(900, y_lim(1)+3, ['passed: ' num2str(p) '/' num2str(den) ' = '...
        num2str(100*fr) ' %'])
    hold off
end


subplot(2,2,2); boxplot(gen_mean.L,round(data.sfe.fclist,-1)); ylim(y_lim)
title('Means of all pts in clusters')
%xlabel('Frequency [Hz]')
subplot(2,2,4); boxplot(gen_mean.R,round(data.sfe.fclist,-1)); ylim(y_lim)
%xlabel('Frequency [Hz]')

%% saving the plot
if SaveFlag
    print(['long_SFOAE_trials_boxplots_' name], '-dpng', '-noui')
end

%% Reproducibility analysis
InterTrialPlot(m, gen_mean_clean, data.sfe.fclist, el, 'LongSFOAE', name,SaveFlag)
StdPlot(data.sfe.fclist, gen_mean_clean, 'Long SFOAE',name,SaveFlag)
