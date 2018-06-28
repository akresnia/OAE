function [fr,frf,R2, R2_ear, mean_DP_clean, DP1_clean, times] = analysis_dpoae(name,name_idx, sndiff, SaveFlag, StdInterTrialPlotFlag, PrctileFilename)

% name = char(names(name_idx));
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
filename = ['dpoae_data_' name '.txt'];
f2_on_xaxis = 1; %if 0: on 2*f2 - f1 on xaxis
fileID = fopen([directory_name filename]);
head_lines = 5;% 4125; %9276;
m = 6; %number of tested frequencies
frf.L = NaN(1,m);
frf.R = NaN(1,m);
prc = 0.25:0.25:0.75; % population percentiles values

% C_data1 = textscan(fileID,['%q', '%*q', '%*q', ...
%     repmat('%q',[1,3]), repmat('%*q',[1,7]),repmat('%q',[1,17]),'%*[^\n]'],...
%     'HeaderLines',head_lines,'CollectOutput',1, 'Delimiter',',');
%d8 - int8, %*[^\n] skips the remainder of a line %q - quoted data

C_data1 = textscan(fileID, repmat('%q',[1,52]),'HeaderLines',head_lines, 'CollectOutput',1,'Delimiter',',');
idt1 = 1;
idt2 = find(strcmp(C_data1{1}, 'CalibrationData'), 1, 'first');
times.values = C_data1{1}(idt1:2:idt2, 3);
times.ears = C_data1{1}(idt1:2:idt2, 5);
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
    xlab = 'Frequency (f_2) [Hz]';
else
    DPfreqs = 2*f1s - f2s;
    xlab = 'Frequency (2*f_1 - f_2) [Hz]';
end
% DP1.L = zeros(1,m);
% DP1.R = zeros(1,m);
EarCol = cell2mat(data(:,4));
DP1Col = prep(data(:,20));
NoiseCol_NF1 = prep(data(:,13));
MinDPCol = prep(data(:,26));
SNdiff = DP1Col-NoiseCol_NF1;
%MinDP = prep({'-7,84';'-6,9';'-5,93';'-11,5';'-9,85';'-8,1'});

MinSNdiff = sndiff; %default 6dB
MinDPid = DP1Col > MinDPCol;
SNid = SNdiff > MinSNdiff;
Pass_id = MinDPid & SNid;
for d=['L','R']
    datapts= sum(EarCol(:)==d); %datapoints for this ear
    l.(d) = datapts/m; % datapoints / freqs in each trial = trials
    ear_id = cell2mat(data(:,4))== d; %logical table with ones for current ear
    pass_id.(d) = Pass_id(ear_id);
    DP1.(d) = DP1Col(ear_id);
    DP1.(d) = reshape(DP1.(d), [m,l.(d)])';%transposed, so data in rows, starting from f2=6000
    pass_id.(d) = reshape(pass_id.(d), [m,l.(d)])';
    DP1_clean.(d) = DP1.(d); 
    DP1_clean.(d)(~pass_id.(d)) = NaN; 
    mean_DP.(d) = mean(DP1.(d));
    mean_DP_clean.(d) = mean(DP1_clean.(d), 'omitnan');

end
try
assert(l.L+l.R == length(times.values));
catch
warning(['time stamps do not correspond with data' name])
end
%% plotting
figure('Name', ['DP ' name])
pos = 1; 
y_lim = [-23 23];
ear_idx = 1;
for d=['L','R']
    subplot(2,1,pos)
    if nargin == 6
        load(PrctileFilename)
        hold on
        quant = quantile(squeeze(mean_dp(ear_idx,:,:))',prc); %1st column is left ear
        fill([DPfreqs' DPfreqs(end:-1:1)'],[quant(1,:) quant(3,end:-1:1)],[.92 .92 .92],'EdgeColor', 'none') %// light grey
        %q1 = plot(quant(1,:), 'DisplayName', ['Pop.' num2str(prc(1)*100) 'percentile']);
        %plot(quant(2,:),'r--', 'DisplayName', 'Population median')
        %q3 = plot(quant(3,:), 'DisplayName', ['Pop.' num2str(prc(3)*100) 'percentile']);
        ear_idx = ear_idx + 1;
    end
    plot(DPfreqs, DP1.(d)','-.'); 
    title(['DPOAE "' d '" ear, ID: ' num2str(name_idx)]); 
    ylabel('DP1 [dB SPL]'); xlabel(xlab);
    xlim([900 6100]); ylim(y_lim);
    
    freqs = repmat(DPfreqs',l.(d),1);
    scatter(freqs(pass_id.(d)), DP1.(d)(pass_id.(d)), 30, 'g', 'filled')
    scatter(freqs(~pass_id.(d)), DP1.(d)(~pass_id.(d)), 30, 'r')
    
    s = sum(pass_id.(d)(:));
    den = length(pass_id.(d)(:));
    fr.(d) = 100* s/den; % in percents
    
    for fi = 1:length(DPfreqs) %frequency analysis
        denf = l.(d);
        pf = sum(pass_id.(d)(:,fi)); %number of passes
       frf.(d)(fi) = 100*pf/denf; 
    end
    frf.(d) = frf.(d)(end:-1:1); %so frf goes from lowest to highest freq
    text(950, -19, ['passed: ' num2str(s) '/' num2str(den) ' = '...
        num2str(round(fr.(d),1)) ' %'])
    hold off
    pos = pos+1; 
end
% subplot(2,1,2)
% plot(DPfreqs, DP1.R,'-.'); title('Right ear'); xlabel(xlab)
% ylabel('DP1 [dB SPL]')
% xlim([900 6100]);
% hold on
% freqs2 = repmat(DPfreqs',l.R,1);
% scatter(freqs2(pass_id.R), DP1.R(pass_id.R), 30, 'g', 'filled')
% scatter(freqs2(~pass_id.R), DP1.R(~pass_id.R), 30, 'r')
% hold off

if SaveFlag
print([directory_name 'images\DP1_summary_' name], '-dpng', '-noui')
end

frac = (fr.L + fr.R)/2;

if StdInterTrialPlotFlag
    InterTrialPlot(m, DP1, DPfreqs, l, 'DPOAE', name, name_idx, SaveFlag);
end
% %RatioPlot(DPfreqs,DP1s)
[~, R2, R2_ear] =StdPlot(DPfreqs,DP1_clean, 'DPOAE',name, name_idx, SaveFlag, StdInterTrialPlotFlag);
end