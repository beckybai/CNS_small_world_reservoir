% For Figure 4 in the paper.
% draw the time-variant firing rate of each neuron
close all;

tot = 1:1200;
tot = setdiff(tot,find_x_list);
tot = setdiff(tot,find_y_list);
tot = setdiff(tot,find_xy_list);
index = 5:10:10*7+6;
ftsize = 15;

% these neurons ids are prepared in advance by observation.
% the selection criteria is according to Figure 1 in (Machen et al.2010)
valid_a = [368,491,542,686,739,834,1,61,1];
for i = 1:9
    valid_a(i) = tot(valid_a(i));
end
valid_a(7) = find_xy_list(6);
valid_a(9) = 1058;
valid_a(3) = 1187;

pick_neuron = valid_a;
pick_neuron = reshape(pick_neuron,max(size(pick_neuron)),1)';
colOrd = [1,0,0;
    1,0.5,0.1;
    1,1,0;
    0,1,0.5;
    0.5,0.8,0.1;
    0,0.8,1;
    0,0.6,1;
    0,0.4,1;
    ]
colOrd = colOrd(8:-1:1,:);
figure;
for nn = 1:size(pick_neuron,2)
    h_fig = subplot(3,3,nn);
    PPP=get(h_fig,'pos');
    PPP(3)=PPP(3)+0.01;
    PPP(4)=PPP(4)+0.04;
    set(h_fig,'pos',PPP)%
    %h_fig = figure('Visible', 'on');
    hold on;
    color = [211 211 211]/255;
    xsq = [100,200,200,100];
    if(nn==1)
        fill(xsq,[0.1,0.1,0.2,0.2],color,'edgealpha',0);
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[]);
        set(h_fig,'Ylim',[0.1,0.2],'ytick',[0.1,0.15,0.2],'yticklabel',[0.1,0.15,0.2]);
        %        set(h_fig.Children,'xtick',[0,100,200,800],'xticklabel',[]);
        %        set(h_fig.Children,'Ylim',[0.1,0.2],'ytick',[0.1,0.15,0.2],'yticklabel',[0.1,0.15,0.2]);
        ylabel('firing rate')
    end
    if(nn==2)
        fill(xsq,[0.05,0.05,0.3,0.3],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[]);
        set(h_fig,'Ylim',[0.05,0.3],'ytick',[0.05,0.1,0.3],'yticklabel',[0.05,0.1,0.3]);
    end
    if(nn==3)
        fill(xsq,[0.08,0.08,0.14,0.14],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[]);
        set(h_fig,'Ylim',[0.08,0.14],'ytick',[0.08,0.1,0.14],'yticklabel',[0.08,0.1,0.14]);
    end
    if(nn==4)
        fill(xsq,[0,0,0.15,0.15],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[]);
        set(h_fig,'Ylim',[0,0.15],'ytickmode','manual','ytick',[0.,0.1,0.15],'yticklabel',[0,0.1,0.15]);
        ylabel('firing rate')
        
        %         PPP=get(h_fig,'pos');%第NN张子图的当前位置
        %         PPP(3)=PPP(3)+0.01;%向右边延展0.04
        %         PPP(4)=PPP(4)+0.04;%向上方延展0.03
        %         set(h_fig,'pos',PPP)%根据新的边界设置。
        
    end
    if(nn==5)
        fill(xsq,[0.1,0.1,0.15,0.15],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[]);
        set(h_fig,'Ylim',[0.1,0.15],'ytick',[0.1,0.125,0.15],'yticklabel',[0.1,0.125,0.15]);
    end
    if(nn==6)
        fill(xsq,[0.08,0.08,0.11,0.11],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[]);
        set(h_fig,'Ylim',[0.08,0.11],'ytick',[0.08,0.1,0.11],'yticklabel',[0.08,0.1,0.11]);
    end
    if(nn==7)
        fill(xsq,[0.08,0.08,0.21,0.21],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'Ylim',[0.08,0.21],'ytick',[0.08,0.1,0.21],'yticklabel',[0.08,0.1,0.21]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[0,0.5,1,4]);
        ylabel('firing rate');
        xlabel('time (sec)');
    end
    if(nn==8)
        fill(xsq,[0,0,0.7,0.7],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'Ylim',[0,0.7],'ytick',[0,0.1,0.7],'yticklabel',[0,0.1,0.7]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[0,0.5,1,4]);
        xlabel('time (sec)');
    end
    if(nn==9)
        fill(xsq,[0.08,0.08,0.24,0.24],color,'edgealpha',0)
        set(h_fig,'Xlim',[0,800]);
        set(h_fig,'Ylim',[0.08,0.24],'ytick',[0.08,0.1,0.24],'yticklabel',[0.08,0.1,0.24]);
        set(h_fig,'xtick',[0,100,200,800],'xticklabel',[0,0.5,1,4]);
        xlabel('time (sec)');
    end
    ii=1;
    box off;
    set(findall(h_fig,'-property','FontSize'),'FontSize',ftsize);
    a = 1:800;
    for i = index
        c = polyfit(a, rateList{i}(pick_neuron(1,nn),a), 8);  %        d = polyval(c, a, 1);
        d = polyval(c, a, 1);
        col = colOrd(ii,:);   
        plot(d,'LineWidth',2.5,'Color',col);
        box off;
        ii=ii+1;
    end
    hold off;
    
end
