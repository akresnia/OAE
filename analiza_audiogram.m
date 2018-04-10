% MATLAB2015A
%%% analysis of audiogram
name = 'Jan_M';
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
filename = ['audiom ' name '.xls'];

data = xlsread([directory_name filename]);
freqs = data(:,1);
left = data(:,2);
right = data(:,3);
XLim = [100 25000];
figure()
p1 = semilogx(XLim, [0 0], '-.');
hold on
p2 = semilogx(freqs,right,'go-','MarkerFaceColor','g', 'DisplayName', 'Right');
p3 = semilogx(freqs,left,'ro-','DisplayName', 'Left');
legend([p2 p3], 'Location', 'northwest');
xlim(XLim);
ylim([-25 35]);
set(gca,'Ydir','reverse')
ax = gca;
ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
hold off

ylabel('dB HL');
xlabel('Frequency [Hz]');
print(['audiometria' name],...
        '-dpng', '-noui')