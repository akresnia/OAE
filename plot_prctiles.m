function [] = plot_prctiles(Freqs, MeasurType, MeanFlag, Prctiles) 
load('srednie20osob_all.mat'); %mean_dp(2x6x20), mean_sfl(2x5x20), mean_sfs(2x4x20)
%p = 0:0.25:1;
data = eval(['mean_' MeasurType]);
x = Freqs;
for i= 1:2 %1 = left, 2 = right
    y = quantile(squeeze(data(i,:,:))',Prctiles);
    fill([x x(end:-1:1)],[y(2,:) y(4,end:-1:1)],[.9 .9 .9]) %// light grey
    hold on
    plot(y(2,:))
    hold on
    plot(y(3,:),'r--')
    plot(y(4,:))
end
