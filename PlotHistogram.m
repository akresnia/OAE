function [] = PlotHistogram(data1,data2,data3,label1,label2,label3,MinX,MaxX,...
    nbins, Title,XLabel,LegendLoc)
edges = linspace(MinX,MaxX,nbins+1);
width = (edges(2)-edges(1));
[N1,~] = histcounts(data1,edges);
[N2,~] = histcounts(data2,edges);
[N3,~] = histcounts(data3,edges);
figure('Name', 'Histogram')
bar(edges(2:end)-width/2,[N1;N2;N3]')
legend(label1, label2, label3, 'Location', LegendLoc)
title(Title)
ylabel('counts')
xlabel(XLabel)
ax = gca;
ax.XTick = round(MinX:width:MaxX,1);
