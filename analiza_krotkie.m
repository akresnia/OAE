wczytanie;
n = 4; %data.cfg.numf
general_L = zeros(1,n);
general_R = zeros(1,n);
l = 0;
r = 0;
for i=1:a-1
    data = short{i,3};
    hold on
    if short{i,1}=='L'
        subplot(2,1,1); xlim([800 4200]); 
        y = abs(data.sfe.dP).^2;
        plot(data.sfe.fp,y,'s-.'); title('Left ear')
        ylabel('Power, dP^2')
        general_L = general_L + y;
        l = l + 1;
    else
        subplot(2,1,2); xlim([800 4200]);
        y = abs(data.sfe.dP).^2;
        plot(data.sfe.fp,y,'o-.'); title('Right ear')
        ylabel('Power, dP^2')
        xlabel('Frequency [Hz]')
        general_R = general_R + y;
        r = r + 1;
    end
end
subplot(2,1,1);plot(data.sfe.fp,general_L./l,'r', 'LineWidth', 1.5)
subplot(2,1,2);plot(data.sfe.fp,general_R./r,'r', 'LineWidth', 1.5); 
