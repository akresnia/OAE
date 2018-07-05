function [freqs,left,right] = analysis_audiogram(name, id, AudiogramsFilename)
% MATLAB2015A
%%% analysis of audiogram
%%% this version does not  support plotting audiograms from beyond saved
%%% file and the population percentiles on one plot
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
        audiograms = audio;
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
    p6 = plot([8000,8000],[-40,40],'r:', 'DisplayName', 'End of standard range');
%     legend([p3 p4 p5], 'Location', 'northwest');
    ylabel('Hearing threshold [dB HL]');
    xlim(XLim);
    ylim([-25 35]);
    set(gca,'Ydir','reverse')
    ax = gca;
    ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
%     title(['Audiogram, patient ID: ' num2str(id)]);
    
    subplot(2,1,2)
%     fill([freqs' freqs(end:-1:1)'],[quant2(1,:) quant2(3,end:-1:1)],[.95 .95 .95]) %// light grey
%     hold on
    p0 = semilogx(freqs, quant2(1,:),'--', 'DisplayName', ['Pop. ' num2str(prc(1)*100) ' percentile']);
    %plot(quant(2,:),'r--', 'DisplayName', 'Population median')
    hold on
    p1 = semilogx(freqs, quant2(3,:),'--', 'DisplayName', ['Pop. ' num2str(prc(3)*100) ' percentile']);
    p2 = semilogx(freqs,right,'go-','MarkerFaceColor','g', 'DisplayName', 'Right ear');
%     legend([p0 p1 p2], 'Location', 'southwest');
    p6 = plot([8000,8000],[-40,40],'r:', 'DisplayName', 'End of standard range');

    xlim(XLim);
    ylim([-25 35]);
    set(gca,'Ydir','reverse')
    ax = gca;
    ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
    ylabel('Hearing threshold [dB HL]');
else
    
p2 = semilogx(freqs,right,'go-','MarkerFaceColor','g', 'DisplayName', 'Right');
p3 = semilogx(freqs,left,'ro-','DisplayName', 'Left');
legend([p2 p3], 'Location', 'southwest');
xlim(XLim);
ylim([-25 35]);
set(gca,'Ydir','reverse')
ax = gca;
ax.XTick = [freqs(1:9); freqs(10:3:end)];%;freqs(12:3:end)];
% title(['Audiogram, patient ID: ' num2str(id)]);
end
hold off

ylabel('Hearing threshold [dB HL]');
xlabel('Frequency [Hz]');

% % when breakpoint in line 34, to plot only percentiles with shaded area:
% figure()
% ala = cat(1,squeeze(audiograms(1,:,:))',squeeze(audiograms(2,:,:))');
% prc2 = [0.1, 0.5, 0.9];
% quantala2 = quantile(ala,prc2);
% p1 = semilogx(freqs, quantala2(1,:),'--', 'DisplayName', [num2str(prc2(1)*100) ' percentile']);
% hold on
% p2 = semilogx(freqs, quantala2(3,:),'--', 'DisplayName', [num2str(prc2(3)*100) ' percentile']);
% fill([freqs' freqs(end:-1:1)'],[quantala2(1,:) quantala2(3,end:-1:1)],[.90 .90 .90],'EdgeColor', 'none')
% p3 = plot([8000, 8000], [-25,25],'r:', 'DisplayName', 'End of standard range');
% xlim(XLim);
% ylim([-25 35]);
% set(gca,'Ydir','reverse');
% ax = gca;
% ax.XTick = [freqs(1:9); freqs(10:3:end)];
% ylim([-25 20]);
% xlabel('Frequency [Hz]');
% ylabel('Hearing threshold [dB HL]');
% ylim([-25 25]);
% legend([p1,p2,p3],'Location','northwest')