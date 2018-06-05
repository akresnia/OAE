names = {'Kasia_K','Magda_P','Ewa_K','Agnieszka_K','Krystyna',...
    'Jan_M', 'Mikolaj_M','Michal_P','Krzysztof_B','Justyna_G',...
    'Alicja_K','Joanna_K','Joanna_R', 'Kasia_P','Monika_W',...
    'Teresa_B', 'Jedrzej_R'
    };
audio = NaN(2,19,length(names));
for i=1:length(names)
name = char(names(i)); [f,l,r] = analysis_audiogram(name, i);
audio(1,:,i) = l; audio(2,:,i)=r;
end
freqs = f;
save('audiogram17zemnabezKlaudii.mat', 'audio', 'freqs');
min(min(audio(1,1:11,:))) %125-8000 Hz
min(min(audio(1,:,:))) %125 - 20000 Hz
min(min(audio(2,1:11,:)))
min(min(audio(2,:,:)))

max(max(audio(1,1:11,:)))
max(max(audio(1,:,:)))
max(max(audio(2,1:11,:)))
max(max(audio(2,:,:)))

mean(mean(audio(1,1:11,:)))
mean(mean(audio(1,:,:),'omitnan'))
mean(mean(audio(2,1:11,:)))
mean(mean(audio(2,:,:),'omitnan'))
mean(reshape(audio(:,1:11,:),1,[]),'omitnan')

median(reshape(audio(2,:,:),1,[]),'omitnan')
median(reshape(audio(1,:,:),1,[]),'omitnan')
median(reshape(audio(1,1:11,:),1,[]),'omitnan')
median(reshape(audio(2,1:11,:),1,[]),'omitnan')

std(reshape(audio(1,1:11,:),1,[]),'omitnan')
std(reshape(audio(1,:,:),1,[]),'omitnan')
std(reshape(audio(2,1:11,:),1,[]),'omitnan')
std(reshape(audio(2,:,:),1,[]),'omitnan')
std(reshape(audio(:,:,:),1,[]),'omitnan')
std(reshape(audio(:,1:11,:),1,[]),'omitnan')