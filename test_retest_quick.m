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
%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj� s�abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
load('times_q_l.mat') %times sfl (long), times sfs (short)
load('OAE17osobclean.mat')
% OAE vectors (clean):
% OAE_quick = NaN(length(names),2, 4, 6); %subjects x ears x freqs x trials
% OAE_cluster = NaN(length(names),2, 5, 6); %subjects x ears x freqs x trials
% OAE_dp = NaN(length(names),2, 6, 6); %subjects x ears x freqs x trials
ears = ['L','R'];
multifit_diff = NaN(length(names),2,15,4); %names x ears x entries x freqs
singlefit_diff = NaN(length(names),2,15,4);

control = 0; di2 = ''; ea2 = 0; ml_old = 0;

for i=1:length(names)
    name = char(names(i));
    for ea = 1:2
        ml=0; %id of multiplefit entries
        sl = 0; %id of singlefit entries
        d = ears(ea);
        temp = times_sfs.(name).(d);
        letemp = length(temp);
        for j=1:letemp-1
            t1 = datetime(temp{j}, 'InputFormat', 'HHmmss');
            t2 = datetime(temp{j+1}, 'InputFormat', 'HHmmss');
            [h, m, s] = hms(diff([t1,t2]));
            if (m>15 || h>0) && ~(strcmp(name,'Jan_M') && ea ==2 && j==3) % more than 15 min = change of ears
                %Jan_M had a break in the last block of R and probe refit in L
                %2nd block
                %Joanna_K had 3 blocks
                di = [num2str(ea), name]; 
                ea1 = ea;
%                 if strcmp(di,di2) || ea1==ea2
%                     warning(['Check ' name ' ' num2str(ea) '!'])
%                 end
                di2=di; ea2 = ea1;
%                 disp([num2str(ea), name, temp{j}, ',',temp{j+1}])
                control = control+1;
                if strcmp(name,'Joanna_K')==0 %she had more blocks
                    fb = j; %length of first block
                    sb = letemp-j; %length of the second block
                    for fi=1:j
                        for si=1:sb
                            ml=ml+1;
                            multifit_diff(i,ea,ml,:) = OAE_quick(i,ea,:,j+si) - OAE_quick(i,ea,:,fi);
                        end 
                    end
                else %for Joanna_K
%                     disp([num2str(ea) 'Joanna' num2str(j) ' ' num2str(letemp) ' ' temp{j}])
                    if ea==1 %for L ear
                        pairs = [1,4 ; 1,5 ; 2,4; 2,5; 3,4; 3,5];
                    elseif j==1 %for R ear
                        pairs = [1,2; 1,3; 1,4; 1,5];
                    elseif j==3
                        pairs = [2,4; 2,5; 3,4; 3,5];
                    end
                    for pa = 1:length(pairs)
                        id1 = pairs(pa,1);
                        id2 = pairs(pa,2);
                        ml=ml+1;
                        multifit_diff(i,ea,ml,:) = OAE_quick(i,ea,:,id1) - OAE_quick(i,ea,:,id2);   
                    end
                end
            else
                sl = sl+1;
                singlefit_diff(i,ea,j,:) = OAE_quick(i,ea,:,j+1) - OAE_quick(i,ea,:,j);
%                 disp([num2str(ea), name, num2str(letemp)])
            end
        end
        if ml_old<ml
            ml
            ml_old = ml;
        end
    end
end
save('testretest_quick_17osobclean.mat', 'multifit_diff', 'singlefit_diff')
single_all = reshape(singlefit_diff,1,[]);
N_sf = sum(~isnan(single_all))
mean_sf = mean(single_all,'omitnan')
std_sf = std(single_all,'omitnan')

multiple_all = reshape(multifit_diff,1,[]);
N_mf = sum(~isnan(multiple_all))
mean_mf = mean(multiple_all,'omitnan')
std_mf = std(multiple_all,'omitnan')