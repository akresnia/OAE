clear all
%directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
%in the previous version when you run analiza_krotkie -> analiza_dlugie first plots overlap and can
%be compared

group_A = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Jan_B', 'Joanna_K','Joanna_R', 'Kasia_P',...
    'Monika_W','Teresa_B','Jedrzej_R'...
    };
group_B = {'Alicja_B','Ula_M','Urszula_O'};
group = 'A';
names = eval(['group_' group]) ;
name_idx = 12; 
snr_value = 9;
name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
PrctileFilename = 'srednie18osoball.mat';
SaveFlag = 1;
PlotPercentile = 1; prc = 0.25:0.25:0.75; % population percentiles values

y_lim = [-40 25]; %make dynamical?
leg = 1; %legend flag

col = 2;
if leg
    rows = 1; %subplot values
    %figure('Position',[200 100 850 450])
else
    rows = 2;
end    

[a, b, c, short, long, longest] = wczytanie(directory_name);
%a - 1 = # of short trials
n = 4; %length(data.sfe.fp)
general.L = zeros(1,n); %zmieniæ na dane w wierszach? naprawiæ freqs
general.R = zeros(1,n);

el.R = 0;
el.L = 0;

for i=1:a-1 %for each trial in dataset
    data = short{i,3};
    y = real(20*log10(data.sfe.dP));
    for d=['L','R']
        if short{i,1}==d
            general.(d)(el.(d)+1,:)= y; %data in columns
            noise_idx.(d)(el.(d)+1,:) = (data.eval.snr<snr_value); %idcs in columns
            noise_lev.(d)(el.(d)+1,:) = data.sfe.Lnf_total;
            el.(d) = el.(d) + 1;
        end
    end
end
clear i j d

%% plotting
f = data.sfe.fp;
pos = 1;
figure('Name', name)
% suptitle({['Quick SFOAE, ' 'Subject ID: ' num2str(name_idx)],''})
ear_id = 1;

for d=['L','R'] 
    subplot(rows,col,pos);
    if PlotPercentile == 1
        load(PrctileFilename)
        hold on
        quant = quantile(squeeze(mean_sfs(ear_id,:,:))',prc); %1st column is left ear
        fill([f f(end:-1:1)],[quant(1,:) quant(3,end:-1:1)],[.95 .95 .95]) %// light grey
        hold on
%         q1 = plot(quant(1,:), 'DisplayName', ['Pop.' num2str(prc(1)*100) 'percentile']);
        %plot(quant(2,:),'r--', 'DisplayName', 'Population median')
%         q3 = plot(quant(3,:), 'DisplayName', ['Pop.' num2str(prc(3)*100) 'percentile']);
        ear_id = ear_id + 1;
    end
    p0 = plot(f,general.(d)','-.'); %title(['"' d '" ear']);
    fig = gcf;
    ax = gca;
    ax.ColorOrderIndex = 1;
%     co = get(gca,'ColorOrder'); % Initial
%     set(fig,'defaultAxesColorOrder',co(1:el.(d),:)) 
    %set(gca, 'Color', co,'NextPlot', 'replacechildren')
    % Change to new colors.

%     
    xlim([800 4200]); ylim(y_lim)
    hold on
    p1 = plot(f,noise_lev.(d)',':');
    p2 = plot(f,mean(general.(d)),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');

    freqs = repmat(f,el.(d),1);
    scatter(freqs(noise_idx.(d)), general.(d)(noise_idx.(d)), 30, 'r','DisplayName', 'Failed')
    scatter(freqs(~noise_idx.(d)), general.(d)(~noise_idx.(d))', 30, 'g', 'filled', 'DisplayName', 'Passed')
    % fraction of measurements that pass snr criterion
    s = sum(noise_idx.(d)(:));
    den = length(noise_idx.(d)(:));
    p = den-s;
    fr.(d) = 100* p/den ;
    text(900, y_lim(1)+4, ['passed: ' num2str(p) '/' num2str(den) ' = '...
        num2str(fr.(d)) ' %'])  
    
    
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
        subplot(rows,col,pos); boxplot(general.(d),round(f,-1)); ylim(y_lim)
%         title(['All Quick SFOAE, "' d '" ear'])
%        xlabel('Frequency [Hz]')
    end
    pos = pos+1;
end
% hold off
if ~leg
    [ax,h1]=suplabel('Frequency [Hz]','x',[.075 .1 .85 .85]);
    [ax,h2]=suplabel('OAE level [dB SPL]','y');
    [ax,h3]=suplabel(['Quick SFOAE, ' 'subject ID: ' num2str(name_idx) group] ,'t');
    set(h3,'FontSize',12)
else
    subplot(1,2,1)
    xlabel('Frequency [Hz]')
    ylabel('OAE level [dB SPL]')
    title('"L" ear') 
    
    subplot(1,2,2)
    xlabel('Frequency [Hz]')
    ylabel('OAE level [dB SPL]')
    title('"R" ear')
    suptitle(['Quick SFOAE, ' 'subject ID: ' num2str(name_idx) group])
end
%% saving
if leg && SaveFlag
    print([directory_name 'images\short_SFOAE_trials_' name], '-dpng', '-noui')
elseif ~leg && SaveFlag
    print([directory_name 'images\short_SFOAE_trials_boxplots_' name],...
        '-dpng', '-noui')
end

%% reproducibility analysis
frac = (fr.L + fr.R)/2
%InterTrialPlot(n, general, data.sfe.fp, el, 'Short SFOAE', name,name_idx,SaveFlag)
% StdPlot(data.sfe.fp, general, 'Short SFOAE',name,name_idx,SaveFlag)
