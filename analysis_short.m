function [frac,R2] = analysis_short(name,name_idx, snr_value, SaveFlag, LegFlag, StdInterTrialPlotFlag)
%directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
%in the previous version when you run analiza_krotkie -> analiza_dlugie first plots overlap and can
%be compared

% names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
%     'Surala','Klaudia_W', 'Mikolaj_M','Michal_P','Krzysztof_B',...
%     'Justyna_G','Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', ...
%     'Kasia_P','Monika_W','Teresa_B','Ula_M','Urszula_O', ...
%     };
%name_idx = 19; 
%snr_value = 9;
%name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
%SaveFlag = 0;
y_lim = [-23 23]; %make dynamical?
leg = LegFlag; %legend flag

if leg
    col = 1; %subplot values
    %figure('Position',[200 100 850 450])
else
    col = 2;
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
            noise_idx.(d)(el.(d)+1,:) = (data.eval.snr<snr_value); %idcs in rows
            el.(d) = el.(d) + 1;
        end
    end
end
clear i j d

f = data.sfe.fp;
pos = 1;
figure('Name', name)

for d=['L','R'] 
    subplot(2,col,pos);
    plot(f,general.(d)','-.') 
    title(['Quick SFOAE, "' d '" ear'])
    xlabel('Frequency [Hz]')
    xlim([800 4200]); ylim(y_lim)
    hold on
    freqs = repmat(f,el.(d),1);
    scatter(freqs(noise_idx.(d)), general.(d)(noise_idx.(d)), 30, 'r','DisplayName', 'Failed')
    scatter(freqs(~noise_idx.(d)), general.(d)(~noise_idx.(d)), 30, 'g', 'filled', 'DisplayName', 'Passed')
    % fraction of measurements that pass snr criterion
    s = sum(noise_idx.(d)(:));
    den = length(noise_idx.(d)(:));
    p = den-s;
    fr.(d) = 100* p/den ;
    text(900, y_lim(1)+3, ['passed: ' num2str(p) '/' num2str(den) ' = '...
        num2str(fr.(d)) ' %'])

    pl = plot(f,mean(general.(d)),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');
    if leg
        legend('Location', 'westoutside')
    elseif ~leg %&& d=='L'
        legend(pl, 'Location','northwest')
%     else
%         legend(pl, 'Location','southwest')
    end
    ylabel('Level [dB SPL]')

    if ~leg
        pos = pos+1;
        subplot(2,2,pos) 
        boxplot(general.(d),round(f,-1)) 
        ylim(y_lim)
        title(['All Quick SFOAE, "' d '" ear'])
%         xlabel('Frequency [Hz]')
    end
    suptitle(['Patient ID: ' num2str(name_idx)])
    pos = pos+1;
end
hold off

if leg && SaveFlag
    print([directory_name 'images\short_SFOAE_trials_' name], '-dpng', '-noui')
elseif ~leg && SaveFlag
    print([directory_name 'images\short_SFOAE_trials_boxplots_' name],...
        '-dpng', '-noui')
end

%% reproducibility analysis
frac = (fr.L + fr.R)/2;

if StdInterTrialPlotFlag
    InterTrialPlot(n, general, data.sfe.fp, el, 'Short SFOAE', name, name_idx,SaveFlag);
end

[~, R2] =StdPlot(data.sfe.fp, general, 'Short SFOAE',name, name_idx,SaveFlag, StdInterTrialPlotFlag); 
end
