wczytanie;
%b - 1 - # of long trials
n = 25; %length(data.sfe.fp)
m = 5; %length(data.sfe.fclist)
general_L = zeros(1,n);
sL = zeros(1,m);
small_L = zeros(1,m);
general_R = zeros(1,n);
sR = zeros(1,m);
small_R = zeros(1,m);
l = 0;
r = 0;
for i=1:b-1 %for each trial in dataset
    data = long{i,3};
    hold on
    for d=['L','R']
        if long{i,1}==d
        subplot(2,2,1); xlim([800 4200]); 
        y = real(data.sfe.dP);
        for j=1:m
            sL(j) = mean(y((j-1)*m+1 :(j-1)*m+m));
        end
        plot(data.sfe.fclist,sL,'s-.'); title('Left ear')
        ylabel('dP')
        general_L(l+1,:)= y;
        small_L(l+1,:)= sL;
        l = l + 1;
    elif long{i,1}=='R'
        subplot(2,2,3); xlim([800 4200]);
        y = real(data.sfe.dP);
        plot(data.sfe.fp,y,'o-.'); title('Right ear')
        ylabel('dP')
        xlabel('Frequency [Hz]')
        general_R(r+1,:) = y;
        r = r + 1;
    end
end
subplot(2,2,1); 
pl = plot(data.sfe.fclist,mean(small_L),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');
%legend(pl)
%subplot(2,2,3); 
%pr = plot(data.sfe.fp,mean(general_R),'r', 'LineWidth', 1.5, 'DisplayName','Mean'); 
%legend(pr)
subplot(2,2,2); boxplot(general_L,data.sfe.fp)
subplot(2,2,4); boxplot(general_R,data.sfe.fp)