% MATLAB R2015a
%% parameters
names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R'
    };
names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};

%jest jeszcze zmierzona Klaudia_W, ale u niej zla aud. imped.
% Alicja_B, Ula_O i Ula_M maj¹ s³abe wyniki, Jan_B nienajlepiej
SaveFlag = 0; LegFlag = 0; StdInterTrialPlotFlag=0;
snr_value = 9; sndiff = 6;
option = 'clean'; % options: 'clean', 'max_snr', 'all'

load('freq short.mat'); %ds 
load('freq dp.mat'); %f2s
load('freq cluster.mat'); %d
dc = round(d(3:5:end),-2);
[m_cls_cl] = load('testretest_cluster_17osobclean.mat');
m_cl = m_cls_cl.multifit_diff;
s_cl = m_cls_cl.singlefit_diff;
[m_qs_q] = load('testretest_quick_17osobclean.mat');
m_q = m_qs_q.multifit_diff;
s_q = m_qs_q.singlefit_diff;
[m_dps_dp] = load('testretest_dp_17osobclean.mat');
m_dp = m_dps_dp.multifit_diff;
s_dp = m_dps_dp.singlefit_diff;

%% plotting
y_lim = [-20 20];
figure()
subplot(2,2,1)
boxplot(m_q,round(ds,-2),'colors','r')
ylabel('d_{mf}(f) [dB SPL]', 'Interpreter', 'tex')
xlabel('Frequency [Hz]')
ylim(y_lim);
%text(4.6, y_lim(2)-13, 'A', 'EdgeColor','k')
text(1.04, 0.9, 'A', 'EdgeColor','k','Units','normalized')
subplot(2,2,2)
boxplot(m_cl,dc,'colors','g')
ylabel('d_{mf}(f) [dB SPL]', 'Interpreter', 'tex')
xlabel('Frequency [Hz]')
ylim(y_lim);
%text(5.65, y_lim(2)-13, 'B', 'EdgeColor','k')
text(1.04, 0.9, 'B', 'EdgeColor','k','Units','normalized')
subplot(2,2,3)
boxplot(m_dp,round(f2s(end:-1:1),-2),'colors','b')
ylabel('d_{mf}(f) [dB SPL]', 'Interpreter', 'tex')
xlabel('Frequency [Hz]')
ylim(y_lim);
%text(6.68, y_lim(2)-13, 'C', 'EdgeColor','k')
text(1.04, 0.9, 'C', 'EdgeColor','k','Units','normalized')
subplot(2,2,4)
position_3 = 1.4:1:3.4;  
box_1 = boxplot(m_dp(:,[1,2,4]),'colors','b','positions',position_3,'width',0.18); 
set(gca,'XTickLabel',{' '})  % Erase xlabels  
hold on     

position_1 = 1:1:3;  
box_S = boxplot(m_q(:,[1,2,4]),'colors','r','positions',position_1,'width',0.18);
set(gca,'XTickLabel',{' '})  % Erase xlabels  

position_3 = 1.2:1:3.2;  
box_3 = boxplot(m_cl(:,[1,3,5]),'colors','g','positions',position_3,'width',0.18);   
set(gca,'XTickLabel',{'1000','2000','4000'})  % Label the last plot, in the middle
ylabel('d_{mf}(f) [dB SPL]', 'Interpreter', 'tex')
xlabel('Frequency [Hz]')
ylim(y_lim);
text(1.04, 0.9, 'D', 'EdgeColor','k','Units','normalized')

figure()
m_cl2 = reshape(m_cl, [],1);
m_dp2  = reshape(m_dp, [],1);
m_q2 = reshape(m_q, [],1);
boxplot([m_q2(1:660), m_cl2(1:660), m_dp2(1:660)], 'notch', 'on', 'Labels',...
    {'SFOAE Quick','SFOAE Cluster', 'DPOAE'})
grid on 
ylim([-18 18]);
ylabel('d_{mf}(f) [dB SPL]', 'Interpreter', 'tex')

figure()
s_cl2 = reshape(s_cl, [],1);
s_dp2  = reshape(s_dp, [],1);
s_q2 = reshape(s_q, [],1);
boxplot([s_q2(1:460), s_cl2(1:460), s_dp2(1:460)], 'notch', 'on', 'Labels',...
    {'SFOAE Quick','SFOAE Cluster', 'DPOAE'})
grid on 
ylim([-18 18]);
ylabel('d_{sf}(f) [dB SPL]', 'Interpreter', 'tex')

