function [y] = StdPlot (freqs, data, type, Name, SaveFlag)
%%% data: rows - measurements, columns - frequencies %%%
m = length(freqs);
st_dev.L = zeros(1,m);
st_dev.R = zeros(1,m);
for i = 1:m
    for d = ['L', 'R']
    st_dev.(d)(i)  = std(data.(d)(:,i));
    end
end

figure()
hold on
plot(freqs, st_dev.L, 'DisplayName', 'Left ear')
plot(freqs, st_dev.R, 'DisplayName', 'Right ear')
%plot(freqs, ones(1,m), 'k--', 'DisplayName', '1 level')
xlabel('Frequency [Hz]'); ylabel('std (f_i) [dB SPL]')
xlim([800 6200]); ylim([0 8])
legend('show')
title([type ' - ' Name])
grid on
if SaveFlag
    print([type '_std_' Name], '-dpng', '-noui')
end
hold off