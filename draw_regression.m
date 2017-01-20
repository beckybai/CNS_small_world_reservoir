% For drawing the Figure 6(c) in the paper
% Finding the right confidential region.
observetunning;
f1 = testingResult(:,1);
f2 = testingResult(:,2);
nt = size(testingResult,1);

s11 = sum((f1-mean(f1)).^2);
s22 = sum((f2-mean(f2)).^2);
s12 = sum((f1-mean(f1)).*(f2-mean(f2)));
p = 3; %the number of the regreesion factor

%for v1=169,v2=3
%fcdf(F1,v1,v2)=0.99
%fcdf(F2,v1,v2)=0.95
F1 = 26.182;
F2 = 8.54;

t = 90;% we have 5 points in totoal now

for t = 94
    ft = fire{t}';
    clear all_b;
    all_b = [];
    delta = [];
    
    regfact = zeros(num_neuron,4);
    ignore1 = 1;
    ignore0 = 1;
    find_tot = 0;
    
    find_tot_x = 0;
    find_x_list = [];
    find_tot_y = 0;
    find_y_list = [];
    find_tot_xy = 0;
    find_xy_list = [];
    find_zero_list = [];
    find_none_list = [];
    temle = [];
    x = [ones(nt,1) f1-mean(f1),f2-mean(f2)];
    xr = [ones(nt,1) f1-mean(f1),f2-mean(f2)];
    
    for i=1:size(ft,2)
        if(mean(ft(:,i)>1.95)) & ~ignore1
            large = large + 1;
            continue;
        else
            nowfiring = ft(:,i);
            [b,bint1,r1,rint1,s] = regress(nowfiring,xr);
            coeff{i, t} = [b(2), b(3)];
            s2 = (x*b - nowfiring)'*(x*b - nowfiring)/(nt-p);
            K1 = s2*p*F1;
            K2 = s2*p*F2;
            
            % significance from the origin
            beta_1 = 0;
            beta_2 = 0;
            delta_beta_1 = beta_1 - b(2);
            delta_beta_2 = beta_2 - b(3);
            temleft = delta_beta_1^2*s11 + delta_beta_2^2*s22 + 2*delta_beta_1*delta_beta_2*s12;
            temle = [temle; temleft];
            
            if temleft <= K1 % origion
                coeff{i, t} = [coeff{i, t}, 0];
            else
                
                delta_y = (-2*(s22*b(3)+b(2)*s12))^2 - 4*s22*(b(2)^2*s11+b(3)^2*s22+2*s12*b(2)*b(3)-K2);
                delta_x = (-2*(s12*b(3)+s11*b(2)))^2 - 4*s11*(b(2)^2*s11+b(3)^2*s22+2*s12*b(2)*b(3)-K2);
                delta_xy = (2*(s11*b(2)-s22*b(3)+s12*b(3)-s12*b(2)))^2 - 4*(s11+s22-2*s12)*(b(2)^2*s11+b(3)^2*s22+2*s12*b(2)*b(3)-K2);
                delta_y_v = (-2*(s22*b(3)+b(2)*s12))^2-4*s22*(b(2)^2*s11+b(3)^2*s22+2*s12*b(2)*b(3)-K1);
                delta_x_v = (-2*(s12*b(3)+s11*b(2)))^2 - 4*s11*(b(2)^2*s11+b(3)^2*s22+2*s12*b(2)*b(3)-K1);
                delta_xy_v = (2*(s11*b(2)-s22*b(3)+s12*b(3)-s12*b(2)))^2-4*(s11+s22-2*s12)*(b(2)^2*s11+b(3)^2*s22+2*s12*b(2)*b(3)-K1);
                delta = [delta;[i delta_x,delta_y,delta_xy, delta_x_v, delta_y_v, delta_xy_v]];
                if delta_y > 0 && delta_x_v <= 0 && delta_xy_v <=0 % vertical
                    coeff{i, t} = [coeff{i, t}, 1];
                    find_tot_y = find_tot_y+1;
                    find_y_list = [find_y_list;[i,b']];
                    if(b(3)>0)
                        coeff_s(i,t) = 10;% +f2
                    else
                        coeff_s(i,t) = 20;% -f2
                    end
                elseif delta_x > 0  && delta_y_v <= 0 && delta_xy_v <=0 % horizon
                    coeff{i, t} = [coeff{i, t}, 2];
                    find_tot_x = find_tot_x+1;
                    find_x_list = [find_x_list;[i,b']];
                    if(b(2)>0)
                        coeff_s(i,t) = 30;
                    else
                        coeff_s(i,t) = 40;
                    end
                    
                    
                elseif delta_xy > 0 && delta_x_v <= 0  && delta_y_v <= 0 % diagnol
                    coeff{i, t} = [coeff{i, t}, 3];
                    find_tot_xy = find_tot_xy+1;
                    find_xy_list = [find_xy_list;[i,b']];
                    if(b(2)<0)
                        coeff_s(i,t) = 50;%f2-f1
                    else
                        coeff_s(i,t) = 60;
                    end
                    
                else                                                     % another
                    coeff{i, t} = [coeff{i, t}, 4];
                    coeff_s(i,t) = -20;
                    find_none_list = [find_none_list;[i,b']];
                end
            end
            all_b = [all_b ;[b(1:2,:)',s(1)]];
        end
        
    end
    
    p2 = figure;
    hold on;
    if(find_tot_x)
        scatter(find_x_list(:,3),find_x_list(:,4),30,'MarkerEdgeColor',colors(1,:));
    end
    if(find_tot_y)
        scatter(find_y_list(:,3),find_y_list(:,4),30,'MarkerEdgeColor',colors(2,:));
    end
    if(find_tot_xy)
        scatter(find_xy_list(:,3),find_xy_list(:,4),30,'MarkerEdgeColor',colors(3,:));
    end
    
    xlim([-1,1]);
    ylim([-1,1]);
    a = -1:0.1:1;
    
end

plot(a*0,-a,'--','Color',[201/255,31/255,55/255]);
plot(a,-a,'--','Color',[255,166,49]./255);
plot(a,a*0,'--','Color',colors(6,:));
set(gca,'box','off')
set(gca,'Xtick',[-1:1:1]);
set(gca,'Ytick',[-1:1:1]);
title('$$ t = 4.7 s$$','Interpreter','latex');
xlabel('$$ b_1 $$','Interpreter','latex');
ylabel('$$ b_2 $$','Interpreter','latex');
set(findall(p2,'-property','FontSize'),'FontSize',28)
savepdf(p2,'regression3')

