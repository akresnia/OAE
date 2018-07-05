% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};

sex = [1,1,1,1,1,...
    0,0,0,0,1,...
    1,1,1,1,1,...
    1,0]; %1 - female
ear_sex = [1,1,1,1,1,1,1,1,1,1,...
    0,0,0,0,0,0,0,0,1,1,...
    1,1,1,1,1,1,1,1,1,1,...
    1,1,0,0]; %1 - female
Bflag=1;
if Bflag
names = names2;
disp('Group B')
end
%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 1; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
name_idx = 1; 

%% initialising empty vectors
fr_sfs=NaN(1,2*length(names)); %fraction of passes in SFOAE short for every ear
fr_sfl=NaN(1,2*length(names)); %fraction of passes in SFOAE long
fr_dp=NaN(1,2*length(names)); %fraction of passes in DPOAE

frf_sfs=NaN(2*length(names),4); %fraction  for freqs in SFOAE short for every ear
frf_sfl=NaN(2*length(names),5); %fraction for freqs in SFOAE long
frf_dp=NaN(2*length(names),6); %fraction for freqs in DPOAE

%R2 - sum over trials,freqs,ears of std(fi), divided by len(freqs)
R2_sfs=NaN(1,length(names)); %R2 in SFOAE short
R2_sfl=NaN(1,length(names)); %R2 in SFOAE long
R2_dp=NaN(1,length(names)); %R2 in DPOAE

R2_ear_sfs=NaN(1,2*length(names)); 
R2_ear_sfl=NaN(1,2*length(names)); 
R2_ear_dp=NaN(1,2*length(names)); 

mean_sfs=NaN(2,4,length(names)); % clean mean in SFOAE short
mean_sfl=NaN(2,5,length(names)); % in SFOAE long
mean_dp=NaN(2,6,length(names)); % in DPOAE

times_sfs=struct(); %timestamps in SFOAE short
times_sfl=struct(); %time stamps in SFOAE long
% times_dp=struct(); %timestamps in DPOAE
prctile_filename = 'srednie17osobclean.mat';
%% OAE analysis
for name_idx = 1:length(names)
    name = char(names(name_idx));
    %% short SFOAE 
%     [fr,frf,R2, R2_ear,  m_SFs, dat, ts] = analysis_short(name, name_idx,snr_value,...
%         SaveFlag, LegFlag,StdInterTrialPlotFlag,prctile_filename); %fraction of passes in %
%     fr_sfs(2*name_idx-1) = fr.L; 
%     fr_sfs(2*name_idx) = fr.R; 
%     frf_sfs(2*name_idx-1,:) = frf.L; 
%     frf_sfs(2*name_idx,:) = frf.R; 
%     R2_sfs(name_idx) = R2; 
%     R2_ear_sfs(2*name_idx-1:2*name_idx) = R2_ear; 
%     mean_sfs(1,:,name_idx) = m_SFs.L;
%     mean_sfs(2,:,name_idx) = m_SFs.R;
%     times_sfs.(name) = ts;
%     clear fr R2
%     
    
    %% long SFOAE
%     option = 'clean'; % options: 'clean', 'max_snr', 'all'
%     [fr,frf,R2,R2_ear, m_SFL, dat,ts] = analysis_long(name, name_idx,...
%         snr_value,SaveFlag, option, StdInterTrialPlotFlag,prctile_filename); %fraction of passes in 
%     fr_sfl(2*name_idx-1) = fr.L; 
%     fr_sfl(2*name_idx) = fr.R; 
%     frf_sfl(2*name_idx-1,:) = frf.L; 
%     frf_sfl(2*name_idx,:) = frf.R; 
%     R2_sfl(name_idx) = R2;
%     R2_ear_sfl(2*name_idx-1:2*name_idx) = R2_ear; 
%     mean_sfl(1,:,name_idx) = m_SFL.L;
%     mean_sfl(2,:,name_idx) = m_SFL.R;
%     times_sfl.(name) = ts;
% 
%     clear fr R2

    %% DPOAE
    [fr,frf,R2,R2_ear, m_DP, dat, tm] = analysis_dpoae(name, name_idx,...
        sndiff,SaveFlag, StdInterTrialPlotFlag,'srednie17osobclean.mat'); %fraction of passes in 
    times_dp.(name) =tm; 
    fr_dp(2*name_idx-1) = fr.L; 
    fr_dp(2*name_idx) = fr.R;
    frf_dp(2*name_idx-1,:) = frf.L; %freqs from lowest to highest
    frf_dp(2*name_idx,:) = frf.R;
    R2_dp(name_idx) = R2;
    R2_ear_dp(2*name_idx-1:2*name_idx) = R2_ear; 
    mean_dp(1,:,name_idx) = m_DP.L;
    mean_dp(2,:,name_idx) = m_DP.R;
    clear fr
end
% times_dp.Jedrzej_R.values(9) = times_dp.Jedrzej_R.values(8)
% times_dp.Jedrzej_R.ears(9) = times_dp.Jedrzej_R.ears(8);
% save('times_d_17osobclean.mat', 'times_dp')

% save(['srednie' num2str(name_idx) 'osob' option '.mat'],...
%     'mean_dp','mean_sfl','mean_sfs');
 save(['R2' num2str(name_idx) 'osob' option '.mat'],...
     'R2_dp','R2_sfl', 'R2_sfs', 'names');
save(['fr' num2str(name_idx) 'osob' option '.mat'],...
    'fr_dp','fr_sfl', 'fr_sfs','names'); 
 save(['R2_ear' num2str(name_idx) 'osob' option '.mat'],...
     'R2_ear_dp','R2_ear_sfl', 'R2_ear_sfs', 'names');

%rozrzut bez sumy po fi, sprawdziæ long clean i all, porownac plec?,
%narysowac tez srednie z 1 lub 2 sigma

%% plotting histogram of R2
nbins = 15;
MinR2 = min([R2_sfl R2_sfs R2_dp]);
MaxR2 = max([R2_sfl R2_sfs R2_dp]);
Title = ['R2 histograms, option ' option ' in long SFOAE'];
XLabel = 'R2 values [dB SPL]';

PlotHistogram(R2_sfs,R2_sfl,R2_dp,'SFOAE short','SFOAE long','DPOAE',...
    MinR2,MaxR2,nbins, Title,XLabel,'northeast')

good_ears = ~isnan(R2_ear_sfs) & ~isnan(R2_ear_sfl) & ~isnan(R2_ear_dp);
sum((R2_ear_sfs(good_ears)).^0.5)

figure;
boxplot([(R2_sfs.^0.5)',(R2_sfl.^0.5)',(R2_dp.^0.5)'],'notch','on','labels',{'SFOAE quick','SFOAE cluster', 'DPOAE'}); ylabel('R1 value [dB SPL]');
grid('on')

figure;
boxplot([(R2_ear_sfs.^0.5)',(R2_ear_sfl.^0.5)',(R2_ear_dp.^0.5)'],'notch','on','labels',{'SFOAE quick','SFOAE cluster', 'DPOAE'}); ylabel('R1 value [dB SPL]');
grid('on')
%[mu,muerr,N,stdv,min,max,meanci] =grpstats(R2_ear_dp.^0.5,[],...
 %   {'mean','sem','numel','std','min','max','meanci'});
ala = R2_ear_sfl.^0.5;
h = kstest((ala-mean(ala,'omitnan'))/std(ala,'omitnan')); %return 0 for all R2_ sets


%% plotting histogram of frac
nbins = 20;
Title = '';%'Histogram of fraction of measurements with "pass"';
XLabel = 'Q [%]';

PlotHistogram(fr_sfs,fr_sfl,fr_dp,'SFOAE Quick','SFOAE Cluster','DPOAE',...
    0,100,nbins, Title,XLabel,'northwest')
if ~Bflag
fracM = [fr_sfs(ear_sex==0) fr_sfl(ear_sex==0) fr_dp(ear_sex==0)]; 
fracsfsF = fr_sfs(sex==1);
fracsflF = fr_sfl(sex==1);
fracdpF = fr_dp(sex==1);
N_M = length(sex)-sum(sex); %number of male participants
fracF = [fracsfsF(1:2*N_M) fracsflF(1:2*N_M) fracdpF(1:2*N_M)];
PlotHistogram2(fracM,fracF,'Male','Female',...
    0,100,nbins, Title,XLabel,'northwest')
end