clear all
%directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
%in the previous version when you run analiza_krotkie -> analiza_dlugie first plots overlap and can
%be compared

group_A = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K', 'Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R'...
    };
group_B = {'Alicja_B','Ula_M','Urszula_O','Jan_B'};
group = 'B';
names = eval(['group_' group]) ;
name_idx = 4; 
snr_value = 9;
SaveFlag = 1;

%% loading data
name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
PrctileFilename = 'srednie17osobclean.mat';

PlotPercentile = 1; prc = 0.25:0.25:0.75; % population percentiles values

y_lim = [-40 25]; %make dynamical?
leg = 0; %legend flag

col = 2;
if leg
    rows = 1; %subplot values
    %figure('Position',[200 100 850 450])
else
    rows = 2;
end    

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
        noise_lev.(d)(el.(d),:) = data.sfe.Lnf_total(3:5:end);
    end
end
clear i j small 

%% plotting
% grean dots are mean values in clusters calculated from measurements with
% good snr
f = data.sfe.fclist;
pos = 1;
figure('Name', name)
ear_id = 1;
for d=['L','R'] 
    subplot(rows,col,pos);
    if PlotPercentile == 1
        load(PrctileFilename)
        hold on
        quant = quantile(squeeze(mean_sfl(ear_id,:,:))',prc); %1st column is left ear
        fill([f f(end:-1:1)],[quant(1,:) quant(3,end:-1:1)],[.93 .93 .93],'EdgeColor', 'none') %// light grey
        hold on
%         q1 = plot(quant(1,:), 'DisplayName', ['Pop.' num2str(prc(1)*100) 'percentile']);
        %plot(quant(2,:),'r--', 'DisplayName', 'Population median')
%         q3 = plot(quant(3,:), 'DisplayName', ['Pop.' num2str(prc(3)*100) 'percentile']);
        ear_id = ear_id + 1;
    end
    p0 = plot(f,gen_mean_clean.(d)','-.'); %title(['"' d '" ear']);
    fig = gcf;
    ax = gca;
    ax.ColorOrderIndex = 1;
%     co = get(gca,'ColorOrder'); % Initial
%     set(fig,'defaultAxesColorOrder',co(1:el.(d),:)) 
    %set(gca, 'Color', co,'NextPlot', 'replacechildren')
    % Change to new colors.

%     title(['Cluster SFOAE "' d '" ear'])
    pl = plot(data.sfe.fclist, mean(gen_mean.(d)),'r', 'LineWidth', 1.5, ...
    'DisplayName', 'Noisy Mean');
    legend(pl)
    xlabel('Frequency [Hz]'); ylabel('Mean SFOAE [dB SPL]'); 
    xlim([800 4200]); ylim(y_lim)
    hold on
    p1 = plot(f,noise_lev.(d)',':');
    p2 = plot(f,mean(gen_mean.(d)),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');

    % fraction of measurements that pass snr criterion
    s = sum(noise_idx.(d)(:));
    den = length(noise_idx.(d)(:));
    freqs = repmat(f,el.(d),1);
    scatter(freqs(noise_clu.(d)), gen_mean.(d)(noise_clu.(d)), 30, 'r','DisplayName', 'Failed')
    scatter(freqs(~noise_clu.(d)), gen_mean.(d)(~noise_clu.(d))', 30, 'g', 'filled', 'DisplayName', 'Passed')
    p = den-s;
    fr.(d) = 100* p/den ;
    text(900, y_lim(1)+4, ['passed: ' num2str(p) '/' num2str(den) ' = '...
        num2str(round(fr.(d),1)) ' %'])  
    
    
    if leg && strcmp(d,'L')
        clear trial_names Lnf_names temp idx
        idx0 = 0;
        idx1 = el.(d);
        if PlotPercentile == 1
            leg_names{1} = '1st and 3rd quantile (A)';
            idx0 = idx0 + 1;
        end
        for i=1:idx1
            leg_names{i+idx0} = ['trial ' num2str(i)];
            leg_names{i+idx0+el.(d)} = ['Lnf_{tot} ' num2str(i)];
        end
        leg_names{2*el.(d)+1+idx0} = 'Mean';
%         legend(leg_names,'Location', 'westoutside')
    elseif ~leg %&& d=='L'
        legend(p2, 'Location','northeast')
%     else
%         legend(pl, 'Location','southwest')
    end
    ylabel(['"' d '" ear'])
%     hold off

    if ~leg
        pos = pos+1;
        subplot(rows,col,pos); boxplot(gen_mean.(d),round(f,-1)); ylim(y_lim)
%         title(['All Quick SFOAE, "' d '" ear'])
%        xlabel('Frequency [Hz]')
    end
    xlabel('Frequency [Hz]')
    pos = pos+1;
end
% hold off
if ~leg
    [ax,h1]=suplabel('Frequency [Hz]','x',[.075 .1 .85 .85]);
    [ax,h2]=suplabel('OAE level [dB SPL]','y');
    %[ax,h3]=suplabel(['Cluster SFOAE, ' 'subject ID: ' num2str(name_idx) group] ,'t');
    %set(h3,'FontSize',12)
else
    subplot(1,2,1)
    
    ylabel('OAE level [dB SPL]')
    title('"L" ear') 
    subplot(1,2,2)
    xlabel('Frequency [Hz]')
    ylabel('OAE level [dB SPL]')
end
%% saving
if leg && SaveFlag
    print([directory_name 'images\long_SFOAE_trials_' name], '-dpng', '-noui')
elseif ~leg && SaveFlag
    print([directory_name 'images\long_SFOAE_trials_boxplots_' name],...
        '-dpng', '-noui')
end

%% Reproducibility analysis
frac = (fr.L + fr.R)/2;
% InterTrialPlot(m, gen_mean_clean, data.sfe.fclist, el, 'Cluster SFOAE', name,SaveFlag)
% StdPlot(data.sfe.fclist, gen_mean_clean, 'Cluster SFOAE',name,SaveFlag)
% 
%     title('"R" ear')
%     suptitle(['Quick SFOAE, ' 'subject ID: ' num2str(name_idx) group])