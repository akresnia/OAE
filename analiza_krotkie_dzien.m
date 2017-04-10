
%3d plot for different times
wczytanie;
%a-1 = number of short trials
n = 4; %data.cfg.numf
%d = 3; %number of days
L = zeros(a-1,n);
R = zeros(a-1,n); %n values and n variances for each day
times_l = zeros(a-1,1);
times_r = zeros(a-1,1);
l = 0;
r = 0;
for i=1:a-1
    data = short{i,3};
    day = short{i,2};
    hour =short{i,4}(1:4);
    y = real(data.sfe.dP);
    if short{i,1}=='L'
        L(l+1,:) = y;
        times_l(l+1) = str2double(day);
        l = l + 1;
    else
        R(r+1,:) = y;
        %times_r(r+1) = str2double(strcat(day, hour));
        r = r + 1;
    end
end
t_l = datetime(times_l,'ConvertFrom','yyyymmdd');
surf([1:l],data.sfe.fp,L(1:l,:)'); title('Left ear') %mesh
xlabel('trial')
ylabel('Frequency [Hz]')
zlabel('dP')
colorbar()
% plot(data.sfe.fp,y,'o-.'); title('Right ear')
% ylabel('Power, dP^2')
% xlabel('Frequency [Hz]')
% ylabel('dP')
% subplot(2,1,1); xlim([800 4200]);
% subplot(2,1,1);plot(data.sfe.fp,L./l,'r', 'LineWidth', 1.5)
% subplot(2,1,2);plot(data.sfe.fp,R./r,'r', 'LineWidth', 1.5); 
