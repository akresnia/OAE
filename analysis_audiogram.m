function [freqs,left,right] = analysis_audiogram(name, id)
% MATLAB2015A
%%% analysis of audiogram
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
filename = ['audiom ' name '.xls'];

data = xlsread([directory_name filename],sheet,xlRange);
freqs = data(:,1);
left = data(:,2);
right = data(:,3);
XLim = [100 25000];
figure()
semilogx(XLim, [0 0], '-.');
hold on
p2 = semilogx(freqs,right,'go-', 'DisplayName', 'Right');
p3 = semilogx(freqs,left,'ro-','DisplayName', 'Left');
legend([p2 p3], 'Location', 'northwest');
xlim(XLim);
ylim([-25 35]);
set(gca,'Ydir','reverse')
ax = gca;
ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
title(['Audiogram, patient ID: ' id]);
hold off

ylabel('dB HL');
xlabel('Frequency [Hz]');