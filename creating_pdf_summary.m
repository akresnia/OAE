% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', 'Kasia_P',...
    'Monika_W','Teresa_B','Ula_M','Urszula_O', 'Jedrzej_R'...
    };
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
name_idx = 1; 
PopulationMeansFileName = 'srednie20osob_all.mat';

for name_idx = 1:length(names)
    name = char(names(name_idx));
    %% short SFOAE 
    [fr,R2,  m_SFs] = analysis_short(name, name_idx,snr_value,SaveFlag, LegFlag,StdInterTrialPlotFlag,PopulationMeansFileName); %fraction of passes in %    
    
    %% long SFOAE
    option = 'all'; % options: 'clean', 'max_snr', 'all'
    [fr,R2, m_SFL] = analysis_long(name, name_idx,snr_value,SaveFlag, option, StdInterTrialPlotFlag, PopulationMeansFileName); %fraction of passes in 
    %% DPOAE
    [fr,R2, m_DP] = analysis_dpoae(name, name_idx,sndiff,SaveFlag, StdInterTrialPlotFlag, PopulationMeansFileName); %fraction of passes in 
end