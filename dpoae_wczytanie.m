filename = 'dpoae_data_01.txt';
fileID = fopen(filename);
head_lines  = 9276;
m = 6; %number of tested frequencies
% C_data1 = textscan(fileID,['%q', '%*q', '%*q', ...
%     repmat('%q',[1,3]), repmat('%*q',[1,7]),repmat('%q',[1,17]),'%*[^\n]'],...
%     'HeaderLines',head_lines,'CollectOutput',1, 'Delimiter',',');
%d8 - int8, %*[^\n] skips the remainder of a line %q - quoted data

C_data1 = textscan(fileID, repmat('%q',[1,52]),'HeaderLines',head_lines, 'CollectOutput',1,'Delimiter',',');

idx1 = find(strcmp(C_data1{1}, 'TestData'), 1, 'first');
idx2 = find(strcmp(C_data1{1}, 'TestSession'), 1, 'first');
data = C_data1{1}(1:idx2-1,:);
fclose(fileID);
% {“SessionID”, "MeasurementID", "PointerNo", "Ear","f1",
% "f2", "TL1" (target f1 level),"TL2", "TA",  "ML1" (measured f1 level)
% "ML1PH", ML2, ML2PH, NF0, NF1 (noise floor for DP1)
% NF<2-6>
% DP<0-4>
% DP5, DP6, MinDP (Minimum DPOAE level criterion in dB SPL) (26 column), MinSN, Good (28 column)( =1 if point passed)
% GoodNF, Bad, Rej (31 column) ( =1 if point rejected), ArtRej, “RejNf ” — Noise level criterion in dB SPL for rejecting test point. 
prep = @(x) str2num(char(strrep(x, ',','.')));
f1s = prep(data(1:6,5));
f2s = prep(data(1:6,6));

DPfreqs = 2*f1s - f2s;
DP1s.L = zeros(1,m);
DP1s.R = zeros(1,m);
EarCol = cell2mat(data(:,4));
%l.L = sum(EarCol(:)=='L');
%l.R = sum(EarCol(:)=='R');
l.L = 1;
l.R = 1;
for i = 1: (idx2-1)/m
    if strcmp(data(i*m-2 ,4),'L')
        DP1s.L(l.L,:) = prep(data((i-1)*m+1:i*m, 20));
        l.L = l.L + 1;
    elseif strcmp(data(i*m-2, 4),'R')
        DP1s.R(l.R,:) = prep(data((i-1)*m+1:i*m, 20));
        l.R = l.R + 1;
    else
        disp('Wrong ear name');
    end
end
%check
l.L =l.L-1;
l.R = l.R-1;
disp('check:')
disp( sum(EarCol(:)=='L')/m == l.L)
disp( sum(EarCol(:)=='R')/m == l.R)

figure()
subplot(2,1,1)
plot(DPfreqs, DP1s.L); title('Left ear'); ylabel('DP1 [dB SPL]')
subplot(2,1,2)
plot(DPfreqs, DP1s.R); title('Right ear'); xlabel('Frequency [Hz]')
ylabel('DP1 [dB SPL]')

InterTrialPlot(m, DP1s', DPfreqs, l, 'DPOAE')
%RatioPlot(DPfreqs,DP1s)
StdPlot(DPfreqs,DP1s, 'DPOAE')
