function [y] = InterTrialPlot (m, gen_mean, fclist, NoTrials)
l = NoTrials;
colors = {'m','c','r','g','b'};
ears = ['L';'R'];
for p=1:2
    ear = ears(p);
    figure(p+1)
    hold on
    grid on
    for i=1:m
        plot(1:l.(ear),2*i+gen_mean.(ear)(:,i),'Color', char(colors(i)),'DisplayName', ...
            ['f' num2str(i) ' = ' num2str(round(fclist(i),-2)) ' Hz'])
        plot(1:l.(ear),zeros(1,l.(ear))+2*i, '-.', 'Color', char(colors(i)), ...
            'DisplayName', ['Zero level for f', num2str(i)])
    end
    title(['Long SFOAE, "' ear '"' ' ear'])
    xlabel('Number of trial')
    ylabel('dP + 2*i');
    legend('Location', 'eastoutside')
end
hold off
end