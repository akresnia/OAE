% MATLAB R2015a
%% parameters
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};
Bflag = 1;
if Bflag
    names = names2;
    disp('group B')
    load('B_OAE_dp2.mat'); %OAE_dp2
    load('times_d_4osobclean.mat') %times_dp
else
    load('times_d_17osobclean.mat') %times_dp
    load('OAE_dp2.mat'); %OAE_dp2
end

%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej


% OAE_dp2 = NaN(length(names), 16, 6); %names x trials x freqs
% for nam=1:length(names)
%     name = char(names(nam));
%     directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
%     filename = ['dpoae_data_' name '.txt'];
% 
%     fileID = fopen([directory_name filename]);
%     head_lines = 5;% 4125; %9276;
%     m = 6; %number of tested frequencies
% 
%     prc = 0.25:0.25:0.75; % population percentiles values
% 
%     % C_data1 = textscan(fileID,['%q', '%*q', '%*q', ...
%     %     repmat('%q',[1,3]), repmat('%*q',[1,7]),repmat('%q',[1,17]),'%*[^\n]'],...
%     %     'HeaderLines',head_lines,'CollectOutput',1, 'Delimiter',',');
%     %d8 - int8, %*[^\n] skips the remainder of a line %q - quoted data
% 
%     C_data1 = textscan(fileID, repmat('%q',[1,52]),'HeaderLines',head_lines, 'CollectOutput',1,'Delimiter',',');
%     idx1 = find(strcmp(C_data1{1}, 'TestData'), 1, 'first');
%     idx2 = find(strcmp(C_data1{1}, 'TestSession'), 1, 'first');
%     data = C_data1{1}(idx1+1:idx2-1,:);
%     fclose(fileID);
% 
%     prep = @(x) str2num(char(strrep(x, ',','.')));
%     f1s = prep(data(1:6,5));
%     f2s = prep(data(1:6,6));
%     DPfreqs = f2s;
%     DP1Col = prep(data(:,20));
%     NoiseCol_NF1 = prep(data(:,13));
%     MinDPCol = prep(data(:,26));
%     SNdiff = DP1Col-NoiseCol_NF1;
%     %MinDP = prep({'-7,84';'-6,9';'-5,93';'-11,5';'-9,85';'-8,1'});
% 
%     MinSNdiff = sndiff; %default 6dB
%     MinDPid = DP1Col > MinDPCol;
%     SNid = SNdiff > MinSNdiff;
%     Pass_id = MinDPid & SNid;
%     len = length(Pass_id);
%     DP1_clean = DP1Col; 
%     DP1_clean(~Pass_id) = NaN; 
%     OAE_dp2(nam,1:len/m,:) = reshape(DP1_clean,[m,len/m])';
% 
% end


% load('OAE17osobclean.mat')
% OAE vectors (clean):
% OAE_quick = NaN(length(names),2, 4, 6); %subjects x ears x freqs x trials
% OAE_cluster = NaN(length(names),2, 5, 6); %subjects x ears x freqs x trials
% OAE_dp = NaN(length(names),2, 6, 6); %subjects x ears x freqs x trials

ears = ['L','R'];
multifit_diff = NaN(132,6); %entries x freqs
singlefit_diff = NaN(130,6);

control = 0; di2 = ''; ea2 = 0; 
ml=0; %id of multiplefit entries
sl = 0; %id of singlefit entries

multj = NaN(1,2);
for i=1:length(names)
    name = char(names(i));
    br = 0;
    trc = 1; %count of trials in a block
    R_ear_id = cell2mat(times_dp.(name).ears)== 'R';
    letemp = length(times_dp.(name).values); %different than in SFOAE!
    for j=1:letemp-1
        ea = R_ear_id(j)+1; %1 = L, 2 = R
        if R_ear_id(j)==R_ear_id(j+1)
            trc = trc+1;
            sl = sl+1;
            singlefit_diff(sl,:) = OAE_dp2(i,j+1,:) - OAE_dp2(i,j,:);
                disp([num2str(ea), name, num2str(letemp)])

        else
            control = control+1;
            br = br+1; %break between trials
%             disp([num2str(ea), name, num2str(letemp)])
            multj(br) = j;
        end
    end
    %skorzystaj z indeksów uszu
    L_id  = 1:letemp;
    R_id  = 1:letemp;
    L_id = L_id(~R_ear_id);
    R_id = R_id(R_ear_id);
    for al=L_id
        try
        bel =L_id(L_id>multj(find(multj>al,1)));
            for bum=bel
%                     ['id1 ' num2str(al) ' id2 ' num2str(bum)];
                ml=ml+1;
               multifit_diff(ml,:) = OAE_dp2(i,bum,:) - OAE_dp2(i,al,:);
            end
        end
    end
    for al=R_id
        try
        bel =R_id(R_id>multj(find(multj>al,1)));
            for bum=bel
%                     ['id1 ' num2str(al) ' id2 ' num2str(bum)]
                ml=ml+1;
               multifit_diff(ml,:) = OAE_dp2(i,bum,:) - OAE_dp2(i,al,:);
            end
        end                       
    end   
end
save(['testretest_dp_' num2str(length(names)) 'osobclean.mat'], 'multifit_diff', 'singlefit_diff')
single_all = abs(reshape(singlefit_diff,1,[]));
N_sf = sum(~isnan(single_all))
mean_sf = mean(single_all,'omitnan')
std_sf = std(single_all,'omitnan')

multiple_all = abs(reshape(multifit_diff,1,[]));
N_mf = sum(~isnan(multiple_all))
mean_mf = mean(multiple_all,'omitnan')
std_mf = std(multiple_all,'omitnan')