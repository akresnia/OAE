% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R','Michal_Cieslak','Ola_Lodyga'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};
flagB = 0;
if flagB
names = names2;
load('B_OAE4osobclean.mat');
disp('Group B')
else
    load('2OAE' num2str(length(names)) 'osobclean.mat')
end
%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
option = 'clean'; % options: 'clean', 'max_snr', 'all'
%

% OAE vectors (clean):
% OAE_quick = NaN(length(names),2, 4, 6); %subjects x ears x freqs x trials
% OAE_cluster = NaN(length(names),2, 5, 6); %subjects x ears x freqs x trials
% OAE_dp = NaN(length(names),2, 6, 6); %subjects x ears x freqs (6kHz,5kHz...) x trials
 
load('freq dp.mat'); %f2s
load('freq cluster.mat'); %d
dc = round(d(3:5:end),-2);
Adcd_big = NaN(3000, 3); %entries, freqs
Adcd_big_su = NaN(length(names),10000, 3); %subjects x entries, freqs
Adcd2 = NaN(35, 3); %entries (this dim is expanding during the analysis), freqs

al = 0; %counter
bal = 0;
max_sal = 0;
for i = 1:length(names)
    sal = 0;
    name = char(names(i));
    for ea = 1:2
        values_dp = squeeze(OAE_dp(i,ea,[3,5,6],:));
        values_dp = values_dp(end:-1:1,:); %to have the same as in cluster order 1,2,4 kHz
        values_c = squeeze(OAE_cluster(i,ea,[1,3,5],:));
        bal = bal + 1;
        Adcd2(bal,:) = mean(values_c,2,'omitnan') - mean(values_dp,2,'omitnan');
        lenc = length(values_c(~(sum(isnan(values_c))==3)));%cut off columns with only NaNs
        lendp = length(values_dp(~(sum(isnan(values_dp))==3))); 
        %lenq = size(values_q,2); %calculate number of trials
        %lenc = size(values_c,2);
        for j = 1:lendp
            for k = 1:lenc
                diff1 = values_c(:,k)-values_dp(:,j);
                al = al + 1;
                sal = sal + 1;
                Adcd_big(al,1:length(diff1)) = diff1;
                Adcd_big_su(i,sal,1:length(diff1)) = diff1;
            end
        end
    end
    max_sal = max([max_sal,sal]);
end
medcd_big = median(Adcd_big, 'omitnan')
medcd_big_abs = median(abs(Adcd_big), 'omitnan')
medcd2 = median(Adcd2, 'omitnan')
meancd_big = mean(Adcd_big, 'omitnan')
meancd_big_abs = mean(abs(Adcd_big), 'omitnan')
meancd2 = mean(Adcd2, 'omitnan')
stdcd_big = std(reshape(Adcd_big,1,[]), 'omitnan')
stdcd_big_abs = std(reshape(abs(Adcd_big),1,[]), 'omitnan')
stdcd2 = std(reshape(Adcd2,1,[]), 'omitnan')

y_lim = [-25 25];
figure('Name', 'BigN')
boxplot(Adcd_big,dc([1,3,5]),'notch','on')
ylabel('Ad_{cd}(f) [dB SPL]', 'Interpreter', 'tex')
set(gca,'XTickLabel',{'1000','2000','4000'})
xlabel('Frequency [Hz]')
ylim(y_lim);
grid on
% hold on
% plot(qu(3,[1,2,4]),'g:','DisplayName','Quick')
% plot(cl(3,[1,3,5]),'g--','DisplayName','Cluster')
% legend()


figure()
boxplot(Adcd2,dc([1,3,5]),'notch','on')
ylabel('Ad_{cd}(f) [dB SPL]', 'Interpreter', 'tex')
set(gca,'XTickLabel',{'1000','2000','4000'})
xlabel('Frequency [Hz]')
% hold on
% plot(qu(3,[1,2,4]),'g:','DisplayName','Quick')
% plot(cl(3,[1,3,5]),'g--','DisplayName','Cluster')
% legend()
ylim(y_lim);
grid on

figure()
ala = NaN(6,length(names));
sala = NaN(size(Adcd_big_su,2)*size(Adcd_big_su,3),length(names));
for i = 1:length(names)
    sala(:,i) = reshape(Adcd_big_su(i,:,:),[],1);
    ala(:,i) = reshape(Adcd2(2*i-1:2*i,:),[],1);
end
boxplot(sala, 'notch', 'on')
grid on
ylabel('Ad_{cd} [dB SPL]', 'Interpreter', 'tex')
xlabel('Subject ID');
ylim(y_lim);