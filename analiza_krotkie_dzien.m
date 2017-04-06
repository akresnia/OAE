%comparison of averages and variances for different days 
wczytanie;
n = 4; %data.cfg.numf
d = 3; %number of days
L = zeros(d,2*n);
R = zeros(d,2*n); %n values and n variances for each day
l = 0;
r = 0;
for i=1:a-1
    data = short{i,3};
    day = short{i,2};
    if short{i,1}=='L'
        y = abs(data.sfe.dP).^2;
        plot(data.sfe.fp,y,'s-.'); title('Left ear')
        ylabel('Power, dP^2')
        L = L + y;
        l = l + 1;
    else
        subplot(2,1,2); xlim([800 4200]);
        y = abs(data.sfe.dP).^2;
        plot(data.sfe.fp,y,'o-.'); title('Right ear')
        ylabel('Power, dP^2')
        xlabel('Frequency [Hz]')
        R = R + y;
        r = r + 1;
    end
end
subplot(2,1,1); xlim([800 4200]);
subplot(2,1,1);plot(data.sfe.fp,L./l,'r', 'LineWidth', 1.5)
subplot(2,1,2);plot(data.sfe.fp,R./r,'r', 'LineWidth', 1.5); 
