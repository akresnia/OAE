function [freqs,left,right] = analysis_audiogram(name, id, AudiogramsFilename)
% MATLAB2015A
%%% analysis of audiogram
directory_name = ['C:\Users\Alicja\Desktop\praca mgr\OAE ' name '\'];
filename = ['audiom ' name '.xls'];
prc = 0.25:0.25:0.75; % population percentiles values

switch nargin
    case 2
        data = xlsread([directory_name filename]);
        freqs = data(:,1);
        left = data(:,2);
        right = data(:,3);
    case 3
        load(AudiogramsFilename);
        left = audiograms(1,:,id);
        right = audiograms(2,:,id);

end 

XLim = [100 25000];
figure()
semilogx(XLim, [0 0], '-.');

hold on
if nargin == 3
    load(AudiogramsFilename)
    quant1 = quantile(squeeze(audiograms(1,:,:))',prc); %1st column is left ear
    quant2 = quantile(squeeze(audiograms(2,:,:))',prc); %2nd column is right ear
    
    subplot(2,1,1)
    %fill([freqs' freqs(end:-1:1)'],[quant1(1,:) quant1(3,end:-1:1)],[.95 .95 .95]) %// light grey
%     hold on
    p3 = semilogx(freqs, quant1(1,:),'--', 'DisplayName', ['Pop. ' num2str(prc(1)*100) ' percentile']);
    %plot(quant(2,:),'r--', 'DisplayName', 'Population median')
    
    hold on
    p4 = semilogx(freqs, quant1(3,:),'--', 'DisplayName', ['Pop. ' num2str(prc(3)*100) ' percentile']);
    p5 = semilogx(freqs,left,'ro-','DisplayName', 'Left ear');
    legend([p3 p4 p5], 'Location', 'northwest');

    xlim(XLim);
    ylim([-25 35]);
    set(gca,'Ydir','reverse')
    ax = gca;
    ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
    title(['Audiogram, patient ID: ' num2str(id)]);
    
    subplot(2,1,2)
%     fill([freqs' freqs(end:-1:1)'],[quant2(1,:) quant2(3,end:-1:1)],[.95 .95 .95]) %// light grey
%     hold on
    p0 = semilogx(freqs, quant2(1,:),'--', 'DisplayName', ['Pop. ' num2str(prc(1)*100) ' percentile']);
    %plot(quant(2,:),'r--', 'DisplayName', 'Population median')
    hold on
    p1 = semilogx(freqs, quant2(3,:),'--', 'DisplayName', ['Pop. ' num2str(prc(3)*100) ' percentile']);
    p2 = semilogx(freqs,right,'go-','MarkerFaceColor','g', 'DisplayName', 'Right ear');
    legend([p0 p1 p2], 'Location', 'southwest');
    xlim(XLim);
    ylim([-25 35]);
    set(gca,'Ydir','reverse')
    ax = gca;
    ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
else
    
p2 = semilogx(freqs,right,'go-','MarkerFaceColor','g', 'DisplayName', 'Right');
p3 = semilogx(freqs,left,'ro-','DisplayName', 'Left');
legend([p2 p3], 'Location', 'southwest');
xlim(XLim);
ylim([-25 35]);
set(gca,'Ydir','reverse')
ax = gca;
ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
title(['Audiogram, patient ID: ' num2str(id)]);
end
hold off

ylabel('dB HL');
xlabel('Frequency [Hz]');