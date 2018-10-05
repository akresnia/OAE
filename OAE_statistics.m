% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R','34','35'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};
sex = [1,1,1,1,1,...
    0,0,0,0,1,...
    1,1,1,1,1,...
    1,0,0,1]; %1 - female
ear_sex = [1,1,1,1,1,1,1,1,1,1,...
    0,0,0,0,0,0,0,0,1,1,...
    1,1,1,1,1,1,1,1,1,1,...
    1,1,0,0]; %1 - female
%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
name_idx = 1; 

%% initialising empty vectors
OAE_quick = NaN(length(names),2, 4, 17); %subjects x ears x freqs x trials
OAE_cluster = NaN(length(names),2, 5, 17); %subjects x ears x freqs x trials
OAE_dp = NaN(length(names),2, 6, 17); %subjects x ears x freqs x trials


%% OAE analysis
for name_idx = 1:length(names)
    name = char(names(name_idx));
    %% short SFOAE 
    [fr,frf,R2, R2_ear,  m_SFs, quickOAE_data,times] = analysis_short(name, name_idx,snr_value,SaveFlag, LegFlag,StdInterTrialPlotFlag); %fraction of passes in %
    sizeleft = size(quickOAE_data.L,1);
    OAE_quick(name_idx,1,:,1:sizeleft) = quickOAE_data.L';
    
    sizeright = size(quickOAE_data.R,1);
    OAE_quick(name_idx,2,:,1:sizeright) = quickOAE_data.R';
    clear sizeleft sizeright
    %% long SFOAE
    option = 'clean'; % options: 'clean', 'max_snr', 'all'
    [fr,frf,R2,R2_ear, m_SFL, clusterOAE_data,times] = analysis_long(name, name_idx,snr_value,SaveFlag, option, StdInterTrialPlotFlag); %fraction of passes in 
       sizeleft = size(clusterOAE_data.L,1);
    OAE_cluster(name_idx,1,:,1:sizeleft) = clusterOAE_data.L';
    sizeright = size(clusterOAE_data.R,1);
    OAE_cluster(name_idx,2,:,1:sizeright) = clusterOAE_data.R';
        clear sizeleft sizeright

    %% DPOAE
    [fr,frf,R2,R2_ear, m_DP, dpOAE_data,times] = analysis_dpoae(name, name_idx,sndiff,SaveFlag, StdInterTrialPlotFlag,'srednie18osobclean.mat'); %fraction of passes in 
    sizeleft = size(dpOAE_data.L,1);
    OAE_dp(name_idx,1,:,1:sizeleft) = dpOAE_data.L';
    sizeright = size(dpOAE_data.R,1);
    OAE_dp(name_idx,2,:,1:sizeright) = dpOAE_data.R';
end
save(['2OAE' num2str(name_idx) 'osob' option '.mat'],...
    'OAE_dp','OAE_cluster','OAE_quick');
load(['times_d_' num2str(length(names)) 'osobclean.mat', times_dp]

cl = NaN(5,5);
qu = NaN(5,4);
dp = NaN(5,6);
for i=1:6 %careful! the frequencies are in descending order!
    dat = reshape(OAE_dp(:,:, i,:),1,[]);
    dp(1,i) = min(dat);
    dp(2,i) = max(dat);
    dp(3,i) = mean(dat,'omitnan');
    dp(4,i) = std(dat, 'omitnan');
    dp(5,i) = sum(~isnan(dat));

end
for i=1:5
    dat = reshape(OAE_cluster(:,:, i,:),1,[]);
    cl(1,i) = min(dat);
    cl(2,i) = max(dat);
    cl(3,i) = mean(dat,'omitnan');
    cl(4,i) = std(dat, 'omitnan');
    cl(5,i) = sum(~isnan(dat));
end
for i=1:4
    dat = reshape(OAE_quick(:,:, i,:),1,[]);
    qu(1,i) = min(dat);
    qu(2,i) = max(dat);
    qu(3,i) = mean(dat,'omitnan');
    qu(4,i) = std(dat, 'omitnan');
    qu(5,i) = sum(~isnan(dat));
end
%[mu,muerr,N,std,min,max,meanci] =grpstats(reshape(OAE_quick(:,:, 1,:),1,[]),[],...
%    {'mean','sem','numel','std','min','max','meanci'});