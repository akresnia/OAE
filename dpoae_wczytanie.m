names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Surala','Klaudia_W', 'Mikolaj_M','Michal_P','Krzysztof_B',...
    'Justyna_G','Alicja_B', 'Jan_B', 'Joanna_K','Joanna_R', ...
    'Kasia_P','Monika_W','Teresa_B','Ula_M','Urszula_O', ...
    };
name_idx = 19; 
name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
filename = ['dpoae_data_' name '.txt'];
SaveFlag = 0;
f2_on_xaxis = 1;
fileID = fopen([directory_name filename]);
head_lines  =5;% 4125; %9276;
m = 6; %number of tested frequencies
% C_data1 = textscan(fileID,['%q', '%*q', '%*q', ...
%     repmat('%q',[1,3]), repmat('%*q',[1,7]),repmat('%q',[1,17]),'%*[^\n]'],...
%     'HeaderLines',head_lines,'CollectOutput',1, 'Delimiter',',');
%d8 - int8, %*[^\n] skips the remainder of a line %q - quoted data

C_data1 = textscan(fileID, repmat('%q',[1,52]),'HeaderLines',head_lines, 'CollectOutput',1,'Delimiter',',');

idx1 = find(strcmp(C_data1{1}, 'TestData'), 1, 'first');
idx2 = find(strcmp(C_data1{1}, 'TestSession'), 1, 'first');
data = C_data1{1}(idx1+1:idx2-1,:);
fclose(fileID);
% {“SessionID”, "MeasurementID", "PointerNo", "Ear","f1",
% "f2", "TL1" (target f1 level),"TL2", "TA",  "ML1" (measured f1 level)
% ML2, NF0, NF1 (noise floor for DP1, column 13), NF2,NF3
% NF<4-6>, DP0,DP1
% DP<2-6>
% MinDP (Minimum DPOAE level criterion in dB SPL) (26 column), MinSN, Good,GoodNF, Bad, 
% Rej (31 column), ArtRej, “RejNf ” — Noise level criterion in dB SPL for rejecting test point.
% Later DPPH i MLPH
prep = @(x) str2num(char(strrep(x, ',','.')));
f1s = prep(data(1:6,5));
f2s = prep(data(1:6,6));

if f2_on_xaxis
    DPfreqs = f2s;
    xlab = 'f2 Frequency [Hz]';
else
    DPfreqs = 2*f1s - f2s;
    xlab = '2*f1 - f2 Frequency [Hz]';
end
% DP1.L = zeros(1,m);
% DP1.R = zeros(1,m);
EarCol = cell2mat(data(:,4));
DP1Col = prep(data(:,20));
NoiseCol_NF1 = prep(data(:,13));
MinDPCol = prep(data(:,26));
SNdiff = DP1Col-NoiseCol_NF1;
%MinDP = prep({'-7,84';'-6,9';'-5,93';'-11,5';'-9,85';'-8,1'});

MinSNdiff = 6; %dB
MinDPid = DP1Col > MinDPCol;
SNid = SNdiff > MinSNdiff;
Pass_id = MinDPid & SNid;
for d=['L','R']
    datapts= sum(EarCol(:)==d); %datapoints for this ear
    l.(d) = datapts/m; % datapoints / freqs in each trial = trials
    ear_id = cell2mat(data(:,4))== d; %logical table with ones for current ear
    pass_id.(d) = Pass_id(ear_id);
    DP1.(d) = DP1Col(ear_id);
    DP1.(d) = reshape(DP1.(d), [m,l.(d)])';%data in rows, starting from f2=6000
    pass_id.(d) = reshape(pass_id.(d), [m,l.(d)])';
end

figure()
subplot(2,1,1)
plot(DPfreqs, DP1.L,'-.'); title('Left ear'); ylabel('DP1 [dB SPL]')
xlim([900 6100]);
hold on
freqs = repmat(DPfreqs',l.L,1);
scatter(freqs(pass_id.L), DP1.L(pass_id.L), 30, 'g', 'filled')
scatter(freqs(~pass_id.L), DP1.L(~pass_id.L), 30, 'r')
hold off

subplot(2,1,2)
plot(DPfreqs, DP1.R,'-.'); title('Right ear'); xlabel(xlab)
ylabel('DP1 [dB SPL]')
xlim([900 6100]);
hold on
freqs2 = repmat(DPfreqs',l.R,1);
scatter(freqs2(pass_id.R), DP1.R(pass_id.R), 30, 'g', 'filled')
scatter(freqs2(~pass_id.R), DP1.R(~pass_id.R), 30, 'r')
hold off

if SaveFlag
print(['DP1_summary_' name], '-dpng', '-noui')
end

InterTrialPlot(m, DP1, DPfreqs, l, 'DPOAE', name, SaveFlag);%why was dp1'
% %RatioPlot(DPfreqs,DP1s)
StdPlot(DPfreqs,DP1, 'DPOAE',name, SaveFlag)
clear all