function [y] = StdPlot (freqs, data, type, Name, SaveFlag)
m = length(freqs);
ratio = zeros(1,m);
for i = 1:m
    for d = ['L', 'R']
    ratio.(d)(i)  = std(data.(d)(:,i));
    end
end

figure()
hold on
plot(freqs,ratio.L, 'DisplayName', 'Left ear')
plot(freqs, ratio.R, 'DisplayName', 'Right ear')
%plot(freqs, ones(1,m), 'k--', 'DisplayName', '1 level')
xlabel('Frequency [Hz]'); ylabel('std (f_i) [dB SPL]')
legend('show')
title([type ' - ' Name])
grid on
if SaveFlag
    print(['dpoae_std_' Name], '-dpng', '-noui')
end
hold off