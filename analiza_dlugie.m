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
            plot(data.sfe.fclist,small,'s-.'); title([d 'ear'])
            ylabel('dP')
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
subplot(2,2,3); 
pr = plot(data.sfe.fclist,mean(gen_mean.R),'r', 'LineWidth', 1.5, 'DisplayName','Mean'); 
legend(pr)
subplot(2,2,2); boxplot(general.L,data.sfe.fp)
subplot(2,2,4); boxplot(general.R,data.sfe.fp)