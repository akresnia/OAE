function [] = PlotHistogram2(data1,data2,label1,label2,MinX,MaxX,...
    nbins, Title,XLabel,LegendLoc)
edges = linspace(MinX,MaxX,nbins+1);
width = (edges(2)-edges(1));
[N1,~] = histcounts(data1,edges);
[N2,~] = histcounts(data2,edges);
figure('Name', 'Histogram')
bar(edges(2:end)-width/2,[N1;N2]')
legend(label1, label2, 'Location', LegendLoc)
title(Title)
ylabel('counts')
xlabel(XLabel)
ax = gca;
ax.XTick = round(MinX:width:MaxX,1);
