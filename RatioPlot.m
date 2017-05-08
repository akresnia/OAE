function [y] = RatioPlot (freqs, data)
m = length(freqs);
ratio = zeros(1,m);
for i = 1:m
    for d = ['L', 'R']
    ratio.(d)(i)  = std(data.(d)(:,i))/abs(mean(data.(d)(:,i)));
    end
end

figure()
hold on
plot(freqs,ratio.L, 'DisplayName', 'Left ear')
plot(freqs, ratio.R, 'DisplayName', 'Right ear')
plot(freqs, ones(1,m), 'k--', 'DisplayName', '1 level')
xlabel('Frequency [Hz]'); ylabel('std / abs(mean) of data for each f_i')
legend('show')
hold off