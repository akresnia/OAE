names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Klaudia_W', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', 'Kasia_P',...
    'Monika_W','Teresa_B','Ula_M','Urszula_O', ...
    };
SaveFlag = 1; LegFlag = 0; StdInterTrialFlag=1;
snr_value = 9; sndiff = 6;
name_idx = 1; 
frac_sfs=NaN(1,length(names)); %fraction of passes in SFOAE short
frac_sfl=NaN(1,length(names)); %fraction of passes in SFOAE long
frac_dp=NaN(1,length(names)); %fraction of passes in DPOAE

%R2 - sum over trials,freqs,ears of std(fi), divided by len(freqs)
R2_sfs=NaN(1,length(names)); %R2 in SFOAE short
R2_sfl=NaN(1,length(names)); %R2 in SFOAE long
R2_dp=NaN(1,length(names)); %R2 in DPOAE

for name_idx = 1:19
name = char(names(name_idx));
[fr,R2] = analysis_short(name, name_idx,snr_value,SaveFlag, LegFlag,StdInterTrialFlag); %fraction of passes in %
frac_sfs(name_idx) = fr; 
R2_sfs(name_idx) = R2; 
clear fr R2
option = 'clean';
% options: 'clean', 'max_snr', 'all'
[fr,R2] = analysis_long(name, name_idx,snr_value,SaveFlag, option, StdInterTrialFlag); %fraction of passes in 
frac_sfl(name_idx) = fr; 
R2_sfl(name_idx) = R2;
clear fr R2

[fr,R2] = analysis_dpoae(name, name_idx,sndiff,SaveFlag, StdInterTrialFlag); %fraction of passes in 
frac_dp(name_idx) = fr;
R2_dp(name_idx) = R2;
clear fr

end