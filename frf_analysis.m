% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};
names = names2;
disp('Group B')
sex = [1,1,1,1,1,...
    0,0,0,0,1,...
    1,1,1,1,1,...
    1,0]; %1 - female
ear_sex = [1,1,1,1,1,1,1,1,1,1,...
    0,0,0,0,0,0,0,0,1,1,...
    1,1,1,1,1,1,1,1,1,1,...
    1,1,0,0]; %1 - female
%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
option = 'clean'; % options: 'clean', 'max_snr', 'all'

%% OAE analysis
filename = ['frf' num2str(length(names)) 'osob' option '.mat'];
if exist(fullfile(cd, filename), 'file')== 0
    %% initialising empty vectors
    frf_sfs=NaN(2*length(names),4); %fraction  for freqs in SFOAE short for every ear
    frf_sfl=NaN(2*length(names),5); %fraction for freqs in SFOAE long
    frf_dp=NaN(2*length(names),6); %fraction for freqs in DPOAE
    %% frf extraction
    for name_idx = 1:length(names)
    name = char(names(name_idx));
    %% short SFOAE 
    [~,frf,~, ~, ~, ~] = analysis_short(name, name_idx,snr_value,SaveFlag, LegFlag,StdInterTrialPlotFlag); %fraction of passes in % 
    frf_sfs(2*name_idx-1,:) = frf.L; 
    frf_sfs(2*name_idx,:) = frf.R;     
    
    %% long SFOAE
    [~,frf,~,~, ~, ~] = analysis_long(name, name_idx,snr_value,SaveFlag, option, StdInterTrialPlotFlag); %fraction of passes in 
    frf_sfl(2*name_idx-1,:) = frf.L; 
    frf_sfl(2*name_idx,:) = frf.R; 

    %% DPOAE
    [~,frf,~,~,~, ~] = analysis_dpoae(name, name_idx,sndiff,SaveFlag, StdInterTrialPlotFlag,'srednie18osobclean.mat'); %fraction of passes in 
    frf_dp(2*name_idx-1,:) = frf.L; %freqs from lowest to highest
    frf_dp(2*name_idx,:) = frf.R;
    end

    save(filename,'frf_dp','frf_sfl', 'frf_sfs','names'); 

else
    load(filename);
end
load('freq short.mat'); %ds 
load('freq dp.mat'); %f2s
load('freq cluster.mat'); %d
dc = round(d(3:5:end),-2);

%% plotting
y_lim = [-10 115];
figure()
subplot(2,2,1)
boxplot(frf_sfs,round(ds,-2),'colors','r')
ylabel('q(f) [%]')
xlabel('Frequency [Hz]')
ylim(y_lim);
%text(4.6, y_lim(2)-13, 'A', 'EdgeColor','k')
text(1.04, 0.9, 'A', 'EdgeColor','k','Units','normalized')
subplot(2,2,2)
boxplot(frf_sfl,dc,'colors','g')
ylabel('q(f) [%]')
xlabel('Frequency [Hz]')
ylim(y_lim);
%text(5.65, y_lim(2)-13, 'B', 'EdgeColor','k')
text(1.04, 0.9, 'B', 'EdgeColor','k','Units','normalized')
subplot(2,2,3)
boxplot(frf_dp,round(f2s(end:-1:1),-2),'colors','b')
ylabel('q(f) [%]')
xlabel('Frequency [Hz]')
ylim(y_lim);
%text(6.68, y_lim(2)-13, 'C', 'EdgeColor','k')
text(1.04, 0.9, 'C', 'EdgeColor','k','Units','normalized')
subplot(2,2,4)
position_3 = 1.4:1:3.4;  
box_1 = boxplot(frf_dp(:,[1,2,4]),'colors','b','positions',position_3,'width',0.18); 
set(gca,'XTickLabel',{' '})  % Erase xlabels  
hold on     

position_1 = 1:1:3;  
box_S = boxplot(frf_sfs(:,[1,2,4]),'colors','r','positions',position_1,'width',0.18);
set(gca,'XTickLabel',{' '})  % Erase xlabels  

position_3 = 1.2:1:3.2;  
box_3 = boxplot(frf_sfl(:,[1,3,5]),'colors','g','positions',position_3,'width',0.18);   
set(gca,'XTickLabel',{'1000','2000','4000'})  % Label the last plot, in the middle
ylabel('q(f) [%]')
xlabel('Frequency [Hz]')
ylim(y_lim);
text(1.04, 0.9, 'D', 'EdgeColor','k','Units','normalized')

% frfs = [frf_sfs,frf_sfl,frf_dp];
% [p1,tbl1,stats1] = kruskalwallis(frfs);
% c = multcompare(stats1,  'CType', 'bonferroni');
%ylabel('    DPOAE         |   SF Cluster      |  SF Quick')
