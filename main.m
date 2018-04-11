% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', 'Kasia_P',...
    'Monika_W','Teresa_B','Ula_M','Urszula_O', 'Jedrzej_R'...
    'Klaudia_W'};
sex = [1,1,1,1,1,...
    0,0,0,0,1,...
    1,0,1,1,1,...
    1,1,1,1,0]; %1 - female
%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
name_idx = 1; 

%% initialising empty vectors
frac_sfs=NaN(1,length(names)); %fraction of passes in SFOAE short
frac_sfl=NaN(1,length(names)); %fraction of passes in SFOAE long
frac_dp=NaN(1,length(names)); %fraction of passes in DPOAE

%R2 - sum over trials,freqs,ears of std(fi), divided by len(freqs)
R2_sfs=NaN(1,length(names)); %R2 in SFOAE short
R2_sfl=NaN(1,length(names)); %R2 in SFOAE long
R2_dp=NaN(1,length(names)); %R2 in DPOAE

%% OAE analysis
for name_idx = [11 18 19 21]
    name = char(names(name_idx));
    %% short SFOAE 
    [fr,R2] = analysis_short(name, name_idx,snr_value,SaveFlag, LegFlag,StdInterTrialPlotFlag); %fraction of passes in %
    frac_sfs(name_idx) = fr; 
    R2_sfs(name_idx) = R2; 
    clear fr R2
    option = 'clean'; % options: 'clean', 'max_snr', 'all'
    
    %% long SFOAE
    [fr,R2] = analysis_long(name, name_idx,snr_value,SaveFlag, option, StdInterTrialPlotFlag); %fraction of passes in 
    frac_sfl(name_idx) = fr; 
    R2_sfl(name_idx) = R2;
    clear fr R2

    %% DPOAE
    [fr,R2] = analysis_dpoae(name, name_idx,sndiff,SaveFlag, StdInterTrialPlotFlag); %fraction of passes in 
    frac_dp(name_idx) = fr;
    R2_dp(name_idx) = R2;
    clear fr
end

%rozrzut bez sumy po fi, sprawdziæ long clean i all, porownac plec?,
%narysowac tez srednie z 1 lub 2 sigma
% zrobic serie pdfow z audiometriami, emisjami i spontanicznymi, sfoae ze
% strony mimosa acoustics

%% plotting histogram of R2
nbins = 15;
MinR2 = min([R2_sfl R2_sfs R2_dp]);
MaxR2 = max([R2_sfl R2_sfs R2_dp]);
Title = ['R2 histograms, option ' option ' in long SFOAE'];
XLabel = 'R2 values [dB SPL]';

PlotHistogram(R2_sfs,R2_sfl,R2_dp,'SFOAE short','SFOAE long','DPOAE',...
    MinR2,MaxR2,nbins, Title,XLabel,'northeast')
%% plotting histogram of fraq
nbins =10;
Title = 'Histogram of fraction of measurements with "pass"';
XLabel = '%';

PlotHistogram(frac_sfs,frac_sfl,frac_dp,'SFOAE short','SFOAE long','DPOAE',...
    0,100,nbins, Title,XLabel,'northwest')

fracM = [frac_sfs(sex==0) frac_sfl(sex==0) frac_dp(sex==0)]; 
fracF = [frac_sfs(sex==1) frac_sfl(sex==1) frac_dp(sex==1)]; 
PlotHistogram(fracM,fracF(1:length(fracM)),[],'Male','Female','',...
    0,100,nbins, Title,XLabel,'northwest')