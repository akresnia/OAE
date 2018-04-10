names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Klaudia_W', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', 'Kasia_P',...
    'Monika_W','Teresa_B','Ula_M','Urszula_O', ...
    };
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
name_idx = 1; 
frac_sfs=NaN(1,length(names)); %fraction of passes in SFOAE short
frac_sfl=NaN(1,length(names)); %fraction of passes in SFOAE long
frac_dp=NaN(1,length(names)); %fraction of passes in DPOAE

%R2 - sum over trials,freqs,ears of std(fi), divided by len(freqs)
R2_sfs=NaN(1,length(names)); %R2 in SFOAE short
R2_sfl=NaN(1,length(names)); %R2 in SFOAE long
R2_dp=NaN(1,length(names)); %R2 in DPOAE

for name_idx = 1:length(names)
name = char(names(name_idx));
[fr,R2] = analysis_short(name, name_idx,snr_value,SaveFlag, LegFlag,StdInterTrialPlotFlag); %fraction of passes in %
frac_sfs(name_idx) = fr; 
R2_sfs(name_idx) = R2; 
clear fr R2
option = 'clean';
% options: 'clean', 'max_snr', 'all'
[fr,R2] = analysis_long(name, name_idx,snr_value,SaveFlag, option, StdInterTrialPlotFlag); %fraction of passes in 
frac_sfl(name_idx) = fr; 
R2_sfl(name_idx) = R2;
clear fr R2

[fr,R2] = analysis_dpoae(name, name_idx,sndiff,SaveFlag, StdInterTrialPlotFlag); %fraction of passes in 
frac_dp(name_idx) = fr;
R2_dp(name_idx) = R2;
clear fr
%rozrzut bez sumy po fi, sprawdziæ long clean i all, porownac plec?,
%narysowac tez srednie z 1 lub 2 sigma
% zrobic serie pdfow z audiometriami, emisjami i spontanicznymi, sfoae ze
% strony mimosa acoustics

end

%% plotting histogram of R2
nbins = 15;
MinR2 = min([R2_sfl R2_sfs R2_dp]);
MaxR2 = max([R2_sfl R2_sfs R2_dp]);
edges = linspace(MinR2,MaxR2,nbins);
width = (edges(2)-edges(1));
[N2,~] = histcounts(R2_sfl,edges);
[N1,~] = histcounts(R2_sfs,edges);
% [N2,edges2] = histcounts(R2_sfl,edges1);
[N3,~] = histcounts(R2_dp,edges);
figure()
bar(edges(2:end)-width/2,[N1;N2;N3]')
legend('SF short', 'SF long', 'DP')
title(['R2 histograms, option ' option ' in long SFOAE'])
ylabel('counts')
xlabel('R2 values [dB SPL]')
ax = gca;
ax.XTick = round(MinR2:width:MaxR2,1);
%% plotting histogram of fraq
nbins =10;
edges1 = linspace(0,100,nbins+1); %values are percents
width = (edges1(2)-edges1(1));
[F1,~] = histcounts(frac_sfs,edges1);
[F2,~] = histcounts(frac_sfl, edges1);
[F3,~] = histcounts(frac_dp, edges1);
figure()
x = edges1(2:end)-width/2;
bar(x,[F1;F2;F3]')
legend('SF short', 'SF long', 'DP','Location', 'northwest')
title('Histogram of fraction of measurements with "pass"')
ylabel('counts')
xlabel('%')
ax = gca;
ax.XTick = 0:width:100;
% set(ax,'XTickLabel',x)