wczytanie;
%b - 1 - # of long trials
n = 25; %length(data.sfe.fp)
m = 5; %length(data.sfe.fclist)
general = zeros(1,n);
gen_mean = zeros(1,m);
small = zeros(1,m);

l.R = 0;
l.L = 0;
ears = ['L';'o';'R'];
figure(1)
for i=1:b-1 %for each trial in dataset
    data = long{i,3};
    y = real(data.sfe.dP);
    hold on
    for d=['L','R']
        if long{i,1}==d
            k=find(ears==d);
            subplot(2,2,k); xlim([800 4200]);
            for j=1:m
                small(j) = mean(y((j-1)*m+1 :(j-1)*m+m));
            end
            plot(data.sfe.fclist,small,'s-.'); title(['Long SFOAE, "' d '"' ' ear'])
            general.(d)(l.(d)+1,:)= y;
            gen_mean.(d)(l.(d)+1,:)= small;
            l.(d) = l.(d) + 1;
        end
    end
end
clear i j small 
            
subplot(2,2,1); 
pl = plot(data.sfe.fclist,mean(gen_mean.L),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');
legend(pl)
xlabel('Frequency [Hz]')
ylabel('Mean dP')
subplot(2,2,3); 
xlabel('Frequency [Hz]')
ylabel('Mean dP')
pr = plot(data.sfe.fclist,mean(gen_mean.R),'r', 'LineWidth', 1.5, 'DisplayName','Mean'); 
legend(pr)
subplot(2,2,2); boxplot(gen_mean.L,round(data.sfe.fclist,-1))
%xlabel('Frequency [Hz]')
subplot(2,2,4); boxplot(gen_mean.R,round(data.sfe.fclist,-1))
%xlabel('Frequency [Hz]')

for p=1:2
    ear = ears(2*p -1);
    figure(p+1)
    hold on
    grid on
    colorb = colorbar();
    for i=1:m
        scatter(1:l.(ear),ones(1,l.(ear)).*data.sfe.fclist(i),[],gen_mean.(ear)(:,i), 'filled', 'MarkerEdgeColor', 'k')
    end
    title(['Long SFOAE, "' ear '"' ' ear'])
    xlabel('Number of trial')
    ylabel('Frequency [Hz]');
    colorb.Label.String = 'Mean dP';
end