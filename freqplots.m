load('freq short.mat'); %ds
%load('freq long.mat'); %dl
load('freq cluster.mat'); %d
load('freq dp.mat'); %f2s
figure()

hold on
%yl = ones(size(dl));
%yl(1:2:end) = -1;
yc = ones(size(d));
yc(1:2:end) = -1;
%p2 = stem(dl, 3.*ones(size(dl))+0.06*yl, 'diamondb', 'DisplayName', 'Long');
p3 = stem(d, 1.5*ones(size(d))+0.06*yc, '^g', 'DisplayName', 'Cluster');
p4 = stem(f2s, ones(size(f2s)), 'b', 'filled', 'DisplayName', 'DPOAE f_2');
p1 = stem(ds, ones(size(ds))*0.5,'diamondr', 'filled', 'DisplayName', 'Quick');

legend('show')
xlabel('Frequency [Hz]')
xlim([800 6200])