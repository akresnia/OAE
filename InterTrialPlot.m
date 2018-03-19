function [y] = InterTrialPlot (NoFreqs, Data, fclist, NoTrials, MeasurType, Name, SaveFlag)
%%% data: rows - measurements, columns - frequencies %%%

l = NoTrials;
colors = {'m','c','r','g','b','k'};
ears = ['L';'R'];
for p=1:2
    ear = ears(p);
    figure()
    hold on
    grid on
    for i=1:NoFreqs
        plot(1:l.(ear),5*i+Data.(ear)(:,i)-mean(Data.(ear)(:,i), 'omitnan'),'s-','Color', char(colors(mod(i,6)+1)),'DisplayName', ...
            ['f_' num2str(i) ' = ' num2str(round(fclist(i),-2))...
             ' [Hz]'])
        plot(1:l.(ear),zeros(1,l.(ear))+5*i, '-.', 'Color', char(colors(mod(i,6)+1)), ...
            'DisplayName', ['Zero level for f_', num2str(i)])
    end
    title([MeasurType ', "' ear '"' ' ear - ' Name])
    xlabel('Number of trial')
    ylabel('Level(f_i) - mean(f_i) + 5*i [dB SPL]');
    legend('Location', 'eastoutside')
    if SaveFlag
        dir_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' Name '\images\'];
        print([dir_name MeasurType '_intertrial_' ear '_' Name], '-dpng', '-noui')
    end
end
hold off
end