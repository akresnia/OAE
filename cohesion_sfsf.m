% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R','Michal_Cieslak','Ola_Lodyga'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};
Bflag = 1;
if Bflag == 0
names = names2;
disp('group B')
load('B_OAE4osobclean.mat')
else 
    load(['2OAE' num2str(length(names)) 'osobclean.mat'])
end
%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
option = 'clean'; % options: 'clean', 'max_snr', 'all'


% OAE vectors (clean):
% OAE_quick = NaN(length(names),2, 4, 6); %subjects x ears x freqs x trials
% OAE_cluster = NaN(length(names),2, 5, 6); %subjects x ears x freqs x trials
% OAE_dp = NaN(length(names),2, 6, 6); %subjects x ears x freqs x trials
load('freq short.mat'); %ds 
load('freq dp.mat'); %f2s
load('freq cluster.mat'); %d
dc = round(d(3:5:end),-2);
Adqc_big = NaN(30, 3); %entries, freqs
Adqc2 = NaN(34, 3); %entries, freqs
Adqc_big_su = NaN(length(names),5000, 3); %subjects x entries, freqs


al = 0; %counter
bal = 0;
max_sal = 0;

for i = 1:length(names)
    sal = 0;
    name = char(names(i));
    for ea = 1:2
        values_q = squeeze(OAE_quick(i,ea,[1,2,4],:));
        values_c = squeeze(OAE_cluster(i,ea,[1,3,5],:));
        bal = bal + 1;
        Adqc2(bal,:) = mean(values_q,2,'omitnan') - mean(values_c,2,'omitnan');
        lenc = length(values_c(~(sum(isnan(values_c))==3)));%cut off columns with only NaNs
        lenq = length(values_q(~(sum(isnan(values_q))==3))); 
        %lenq = size(values_q,2); %calculate number of trials
        %lenc = size(values_c,2);
        for j = 1:lenq %number of quick trials
            for k = 1:lenc %number of cluster trials
                diff = values_q(:,j)-values_c(:,k);
                al = al + 1;
                sal = sal + 1;
                Adqc_big(al,:) = diff;
                Adqc_big_su(i,sal,:) = diff;
                clear diff
            end
        end
    end
    max_sal = max([max_sal,sal]);
end
medqc = median(Adqc_big, 'omitnan')
medqc2 = median(Adqc2, 'omitnan')
meanqc = mean(Adqc_big, 'omitnan')
meanqc2 = mean(Adqc2, 'omitnan')
stdqc = std(reshape(Adqc_big,1,[]), 'omitnan')
stdqc2 = std(reshape(Adqc2,1,[]), 'omitnan')
%
y_lim = [-15 15];
figure('Name', 'BigN')
boxplot(Adqc_big,round(ds([1,2,4]),-2),'notch','on')
ylabel('Ad_{qc}(f) [dB SPL]', 'Interpreter', 'tex')
set(gca,'XTickLabel',{'1000','2000','4000'})
xlabel('Frequency [Hz]')
ylim(y_lim);
% hold on
% plot(qu(3,[1,2,4]),'g:','DisplayName','Quick')
% plot(cl(3,[1,3,5]),'g--','DisplayName','Cluster')
% legend()


figure()
boxplot(Adqc2,round(ds([1,2,4]),-2),'notch','on')
ylabel('Ad_{qc}(f) [dB SPL]', 'Interpreter', 'tex')
set(gca,'XTickLabel',{'1000','2000','4000'})
xlabel('Frequency [Hz]')
% hold on
% plot(qu(3,[1,2,4]),'g:','DisplayName','Quick')
% plot(cl(3,[1,3,5]),'g--','DisplayName','Cluster')
% legend()
ylim(y_lim);

figure()
ala = NaN(6,length(names));
sala = NaN(15000,length(names));
for i = 1:length(names)
    sala(:,i) = reshape(Adqc_big_su(i,:,:),[],1);
    ala(:,i) = reshape(Adqc2(2*i-1:2*i,:),[],1);
end
boxplot(sala, 'notch', 'on')
grid on
ylabel('Ad_{qc} [dB SPL]', 'Interpreter', 'tex')
xlabel('Subject ID');
ylim(y_lim);

% ala = reshape(Adqc_big_su(1,:,:),[],1)
% for i=2:17
% ala = cat(2,ala,reshape(Adqc_big_su(i,:,:),[],1));
% end
% [p1,tbl1,stats1] = kruskalwallis(ala);
% c = multcompare(stats1,  'CType', 'bonferroni');