directory_name = 'C:\Users\Alicja\Desktop\praca mgr\moje OAE\20_03\';
wczytanie(directory_name);
name = 'Ala';
%c - 1 - # of the longest trials
n = 60; %length(data.sfe.fp)
%m = 5; %length(data.sfe.fclist)
general = zeros(1,n);
%gen_mean = zeros(1,m);
%small = zeros(1,m);

l.R = 0;
l.L = 0;
ears = ['L';'R']; %!
figure(1)
for i=1:c-1 %for each trial in dataset
    data = longest{i,3};
    y = real(data.sfe.dP);
    hold on
    for d=['L','R']
        if longest{i,1}==d
            k=find(ears==d);
            subplot(2,1,k); xlim([800 2800]);
%             for j=1:m
%                 small(j) = mean(y((j-1)*m+1 :(j-1)*m+m));
%             end
            plot(data.sfe.fclist,y,'s-.'); title(['The longest SFOAE, "' d '"' ' ear'])
            general.(d)(l.(d)+1,:)= y;
            %gen_mean.(d)(l.(d)+1,:)= small;
            l.(d) = l.(d) + 1;
        end
    end
end
clear i j d
            
subplot(2,1,1); 
pl = plot(data.sfe.fclist,mean(general.L),'r', 'LineWidth', 1.5, 'DisplayName', 'Mean');
legend(pl)
xlabel('Frequency [Hz]')
ylabel('dP')
subplot(2,1,2); 
xlabel('Frequency [Hz]')
ylabel('dP')
pr = plot(data.sfe.fclist,mean(general.R),'r', 'LineWidth', 1.5, 'DisplayName','Mean'); 
legend(pr)
% subplot(2,2,2); boxplot(general.L,round(data.sfe.fclist,-1))
% %xlabel('Frequency [Hz]')
% subplot(2,2,4); boxplot(general.R,round(data.sfe.fclist,-1))
% %xlabel('Frequency [Hz]')

for p=1:2
    ear = ears(p); %!
    figure(p+1)
    hold on
    grid on
    colorb = colorbar();
    baseline = general.(ear)(1,:);
    y = general.(ear) - repmat(baseline,l.(ear),1);
    %for i=1:n
    %    scatter(1:l.(ear),ones(1,l.(ear)).*data.sfe.fclist(i),[],y(:,i), 'filled', 'MarkerEdgeColor', 'k')
    %end
    surf(1:l.(ear),data.sfe.fclist,y','FaceColor', 'texturemap')
    title(['The longest SFOAE trial(i) - trial(1), "' ear '"' ' ear'])
    xlabel('Number of trial')
    ylabel('Frequency [Hz]');
    colorb.Label.String = 'dP(i) - dP(1)';
end
InterTrialPlot(n, general, data.sfe.fclist, l, 'Longest SFOAE', name,0)
StdPlot(data.sfe.fclist, general, 'Longest SFOAE',name,0)