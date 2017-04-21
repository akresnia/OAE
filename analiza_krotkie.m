wczytanie;
%a - 1 - # of short trials
n = 4; %length(data.sfe.fp)
general = zeros(1,n);

l.R = 0;
l.L = 0;
ears = ['L';'o';'R'];
figure(1)
for i=1:a-1 %for each trial in dataset
    data = short{i,3};
    y = real(data.sfe.dP);
    hold on
    for d=['L','R']
        if short{i,1}==d
            k=find(ears==d);
            subplot(2,2,k); xlim([800 4200]);
            plot(data.sfe.fp,y,'s-.'); title(['Quick SFOAE, "' d '"' ' ear'])
            general.(d)(l.(d)+1,:)= y;
            l.(d) = l.(d) + 1;
        end
    end
end
clear i j d
            
subplot(2,2,1); 
pl = plot(data.sfe.fp,mean(general.L),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');
legend(pl, 'Location','northwest')
xlabel('Frequency [Hz]')
ylabel('dP')
subplot(2,2,3); 
xlabel('Frequency [Hz]')
ylabel('dP')
pr = plot(data.sfe.fp,mean(general.R),'r', 'LineWidth', 1.5, 'DisplayName','Mean'); 
legend(pr, 'Location','northwest')
subplot(2,2,2); boxplot(general.L,round(data.sfe.fp,-1))
%xlabel('Frequency [Hz]')
subplot(2,2,4); boxplot(general.R,round(data.sfe.fp,-1))
%xlabel('Frequency [Hz]')

for p=1:2
    ear = ears(2*p -1);
    figure(p+1)
    hold on
    grid on
    colorb = colorbar();
    for i=1:n
        scatter(1:l.(ear),ones(1,l.(ear)).*data.sfe.fp(i),[],general.(ear)(:,i), 'filled', 'MarkerEdgeColor', 'k')
    end
    title(['Quick SFOAE, "' ear '"' ' ear'])
    xlabel('Number of trial')
    ylabel('Frequency [Hz]');
    colorb.Label.String = 'dP';
end