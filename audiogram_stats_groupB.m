names2 = {'Alicja_B','Ula_M', 'Urszula_O', 'Jan_B'};
audio = NaN(2,19,length(names2));
for i=1:length(names2)
name = char(names2(i)); 
[f,l,r] = analysis_audiogram(name, i);
audio(1,:,i) = l; 
audio(2,:,i) = r;
end
freqs = f;
save('audiogram4bezKlaudii.mat', 'audio', 'freqs');

figure()
XLim = [100 25000];
ala = cat(1,squeeze(audio(1,:,:))',squeeze(audio(2,:,:))');
prc2 = [0.1, 0.5, 0.9];
quantala2 = quantile(ala,prc2);
p1 = semilogx(freqs, quantala2(1,:),'--', 'DisplayName', [num2str(prc2(1)*100) ' percentile']);
hold on
p2 = semilogx(freqs, quantala2(3,:),'--', 'DisplayName', [num2str(prc2(3)*100) ' percentile']);
fill([freqs' freqs(end:-1:1)'],[quantala2(1,:) quantala2(3,end:-1:1)],[.90 .90 .90],'EdgeColor', 'none')
p3 = plot([8000, 8000], [-20,30],'r:', 'DisplayName', 'End of standard range');
xlim(XLim);
ylim([-25 35]);
set(gca,'Ydir','reverse');
ax = gca;
ax.XTick = [freqs(1:9); freqs(10:3:end)];
ylim([-20 30]);
xlabel('Frequency [Hz]');
ylabel('Hearing threshold [dB HL]');
legend([p1,p2,p3],'Location','northwest')



minsmL = min(min(audio(1,1:11,:))) %125-8000 Hz
minsmR = min(min(audio(2,1:11,:)))
minL = min(min(audio(1,:,:))) %125 - 20000 Hz
minR = min(min(audio(2,:,:)))

maxsmL = max(max(audio(1,1:11,:)))
maxsmR = max(max(audio(2,1:11,:)))
maxL = max(max(audio(1,:,:)))
maxR = max(max(audio(2,:,:)))

MeansmL = mean(mean(audio(1,1:11,:)))
MeansmR = mean(mean(audio(2,1:11,:)))
MeanL = mean(mean(audio(1,:,:),'omitnan'))
MeanR = mean(mean(audio(2,:,:),'omitnan'))
MeansmAll = mean(reshape(audio(:,1:11,:),1,[]),'omitnan')
MeanAll = mean([MeanL,MeanR])

MedsmL = median(reshape(audio(1,1:11,:),1,[]),'omitnan')
MedsmR = median(reshape(audio(2,1:11,:),1,[]),'omitnan')
MedL = median(reshape(audio(2,:,:),1,[]),'omitnan')
MedR = median(reshape(audio(1,:,:),1,[]),'omitnan')
MedsmAll = median(reshape(audio(:,1:11,:),1,[]),'omitnan')
MedAll = median(reshape(audio(:,:,:),1,[]),'omitnan')

StdsmL = std(reshape(audio(1,1:11,:),1,[]),'omitnan')
StdsmR = std(reshape(audio(2,1:11,:),1,[]),'omitnan')
StdL = std(reshape(audio(1,:,:),1,[]),'omitnan')
StdR = std(reshape(audio(2,:,:),1,[]),'omitnan')
StdAll = std(reshape(audio(:,:,:),1,[]),'omitnan')
StdsmAll = std(reshape(audio(:,1:11,:),1,[]),'omitnan')