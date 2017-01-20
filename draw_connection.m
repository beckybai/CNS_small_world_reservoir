close all
h = figure('Position',[100,100,800,500]);
imagesc(ei)
A= [[1,1,1];[0.5,0.5,0.5];[0,0,0]];
cmap = flipud(A);
colormap(cmap)
%hc =colorbar

%colormap(cmap)
hold on
plot([1],[1],'bs','MarkerFaceColor','k','MarkerEdgeColor','k')
plot([1],[1],'bs','MarkerFaceColor','w','MarkerEdgeColor','k')
plot([1],[1],'bs','MarkerFaceColor',[0.5,0.5,0.5],'MarkerEdgeColor',[0.5,0.5,0.5])
%legend({'inh'},'Location','Northwestoutside')
set(gca,'xtick',[1,40,50],'xticklabel',[1,40,50]);
set(gca,'ytick',[1,40,50],'xticklabel',[1,40,50]);
[hleg, hobj, hout, mout]=legend({'inhibitory','excitatory','none'},'FontSize',20,'Location','BestOUTSIDE','Box','off');
hobj(5).MarkerSize = 20;
hobj(7).MarkerSize = 20;
hobj(9).MarkerSize = 20;
hobj(1).FontSize=20;
hobj(2).FontSize=20;
hobj(3).FontSize=20
xlabel('Inhibitory Neuron ID');
ylabel('Excitatory Neuron ID');
set(findall(h,'-property','FontSize'),'FontSize',20)
savepdf(h,'connection_matrix');
