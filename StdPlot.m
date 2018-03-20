function [st_dev,R2] = StdPlot (freqs, data, type, Name, Name_idx, SaveFlag)
%%% data: rows - measurements, columns - frequencies %%%
m = length(freqs);
st_dev.L = zeros(1,m);
st_dev.R = zeros(1,m);
for i = 1:m
    for d = ['L', 'R']
    st_dev.(d)(i)  = std(data.(d)(:,i), 'omitnan');
    end
end
R2 = (sum(st_dev.L)+sum(st_dev.R))/m;

figure('Name', ['std' type Name])
hold on
stem(freqs, st_dev.L, 'filled','DisplayName', 'Left ear' )
stem(freqs, st_dev.R, 'filled', 'DisplayName', 'Right ear')
%plot(freqs, ones(1,m), 'k--', 'DisplayName', '1 level')
xlabel('Frequency [Hz]'); ylabel('std (f_i) [dB SPL]')
xlim([800 6200]); ylim([0 10])
legend('show')
title([type ' std - ID:' num2str(Name_idx)])
grid on

if SaveFlag
    dir_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' Name '\images\'];
    print([dir_name type '_std_' Name], '-dpng', '-noui')
end
hold off