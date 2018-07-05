% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};
flagB = 0;
if flagB
    names = names2;
    load('B_times_q_l.mat') %times sfl (long), times sfs (short)
    load('B_OAE4osobclean.mat')
else
    load('times_q_l.mat') %times sfl (long), times sfs (short)
load('2OAE17osobclean.mat')
end

%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;

% OAE vectors (clean):
% OAE_quick = NaN(length(names),2, 4, 6); %subjects x ears x freqs x trials
% OAE_cluster = NaN(length(names),2, 5, 6); %subjects x ears x freqs x trials
% OAE_dp = NaN(length(names),2, 6, 6); %subjects x ears x freqs x trials
ears = ['L','R'];
multifit_diff = NaN(110,5); %entries x freqs
singlefit_diff = NaN(105,5);

control = 0; di2 = ''; ea2 = 0; ml_old = 0; sl_old = 0;
ml=0; %id of multiplefit entries
sl = 0; %id of singlefit entries
for i=1:length(names)
    name = char(names(i));
    for ea = 1:2

        d = ears(ea);
        temp = times_sfl.(name).(d);
        letemp = length(temp);
        for j=1:letemp-1
            t1 = datetime(temp{j}, 'InputFormat', 'HHmmss');
            t2 = datetime(temp{j+1}, 'InputFormat', 'HHmmss');
            [h, m, s] = hms(t2-t1);
            if m>18 || h>0 % more than 15 min = change of ears
                di = [num2str(ea), name]; 
                ea1 = ea;
                if strcmp(di,di2) || ea1==ea2
                    warning(['Check ' name ' ' num2str(ea) '!'])
                end
                di2=di; ea2 = ea1;
                disp([num2str(ea), name, temp{j}, ',',temp{j+1}])
                control = control+1;
                if strcmp(name,'Krzysztof_B')==0 %he had more blocks
                    fb = j; %length of first block
                    sb = letemp-j; %length of the second block
                    for fi=1:j
                        for si=1:sb
                            ml=ml+1;
                            multifit_diff(ml,:) = OAE_cluster(i,ea,:,j+si)...
                                - OAE_cluster(i,ea,:,fi);
                        end 
                    end
                else %for Krzysztof 3 blocks for both ears, j = 1,3 and 2,3
                    %disp([num2str(letemp) 'Krzysztof: j' num2str(j)])
                    if j==1 
                        pairs = [[1,2];[1,3];[1,4];[2,4];[3,4]];
                    elseif j == 2 
                        pairs = [[1,3];[1,4];[2,3];[2,4];[3,4]];
                    end
                    for pa = 1:length(pairs)
                        id1 = pairs(pa,1);
                        id2 = pairs(pa,2);
                        ml=ml+1;
                        multifit_diff(ml,:) = OAE_cluster(i,ea,:,id2)...
                            - OAE_cluster(i,ea,:,id1);   
                    end
                end
            else
                sl = sl+1;
                singlefit_diff(sl,:) = OAE_cluster(i,ea,:,j+1) - OAE_cluster(i,ea,:,j);
%                 disp([num2str(ea), name, num2str(letemp)])
            end
        end
%         if ml_old<ml
%             ml
%             ml_old = ml;
%         end
%         if sl_old<sl
%             sl
%             sl_old = sl;
%         end
    end
end
save(['testretest_cluster_' num2str(length(names)) 'osobclean.mat'], 'multifit_diff', 'singlefit_diff')
single_all = reshape(singlefit_diff,1,[]);
N_sf = sum(~isnan(single_all))
mean_sf = mean(abs(single_all),'omitnan')
std_sf = std(abs(single_all),'omitnan')

multiple_all = reshape(multifit_diff,1,[]);
N_mf = sum(~isnan(multiple_all))
mean_mf = mean(abs(multiple_all),'omitnan')
std_mf = std(abs(multiple_all),'omitnan')