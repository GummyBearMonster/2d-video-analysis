load('all.mat','areamap2','ypos','yseg_mean','areaseg_mean','yseg_num','areaseg_num', ...
    'yseg_std','areaseg_std','widthmap2','widthseg_mean','widthseg_num','widthseg_std')
s.areamap=areamap2;
s.widthmap=widthmap2;
s.ypos=ypos;
s.yseg_mean=yseg_mean;
s.widthseg_mean=widthseg_mean;
s.areaseg_mean=areaseg_mean;
s.yseg_num=yseg_num;
s.widthseg_num=widthseg_num;
s.areaseg_num=areaseg_num;
s.yseg_std=yseg_std;
s.widthseg_std=widthseg_std;
s.areaseg_std=areaseg_std;

s.file='44%1';
arr{1,4}=s;
clear('s','areamap2','ypos','yseg_mean','areaseg_mean','yseg_num','areaseg_num', ...
    'yseg_std','areaseg_std','widthmap2','widthseg_mean','widthseg_num','widthseg_std')

%% Area Only
colormap=[[0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.5 0 0.5];[0 0 0]];

for k=1
    for j=1:4
        a=arr{k,j}.areamap;
        y=arr{k,j}.ypos;
        y2=[y,fliplr(y)];
        a2=[a,fliplr(a)];
        ysm=arr{k,j}.yseg_mean;
        asm=arr{k,j}.areaseg_mean;
        yss=arr{k,j}.yseg_std;
        ass=arr{k,j}.areaseg_std;
        ysn=arr{k,j}.yseg_num;
        asn=arr{k,j}.areaseg_num;
        i=3;
%         if k==1
%             plot(y,ysm(i,:),':','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
%         elseif k==2
%             plot(y,ysm(i,:),':','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
%         elseif k==3
%             plot(y,ysm(i,:),'--','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
%         elseif k==4
%             plot(y,ysm(i,:),'--','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
%         elseif k==5
%             plot(y,ysm(i,:),'-','LineWidth',1,'Color',colormap(mod(k,6)+1,:))
%         elseif k==6
%             plot(y,ysm(i,:),'-','LineWidth',1,'Color',colormap(mod(k,6)+1,:))
%         end
        if j<4
            plot(y,ysm(i,:),':','LineWidth',1,'Color',colormap(mod(j,6)+1,:))
        else
            plot(y,ysm(i,:),'k-','LineWidth',1)
        end
            hold on
            reg=[ysm(i,:)+yss(i,:),fliplr(ysm(i,:)-yss(i,:))];
            h=fill(y2,reg,colormap(mod(j,6)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 600])  
            ylim([0 5000])
            hold on

    end
end
    legend('Water','100cst Silicone','1000cst Silicone','44% Starch','Location','northwest')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10, 'FontName', 'Times New Roman')
    ylabel('Bubble area (mm^2)')
    xlabel('Bubble vertical position (mm)')
    saveas(gcf,'area_height.fig')
saveas(gcf,'area_height.jpg')
%%
colormap=[[0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.5 0 0.5];[0 0 0]];

for k=5
    for j=1:5
        a=arr{k,j}.areamap;
        y=arr{k,j}.ypos;
        y2=[y,fliplr(y)];
        a2=[a,fliplr(a)];
        ysm=arr{k,j}.yseg_mean;
        asm=arr{k,j}.areaseg_mean;
        yss=arr{k,j}.yseg_std;
        ass=arr{k,j}.areaseg_std;
        ysn=arr{k,j}.yseg_num;
        asn=arr{k,j}.areaseg_num;
        i=2;
        plot(a,asm(i,:),'-','LineWidth',1,'Color',colormap(mod(j,5)+1,:))
        
            
            hold on
            reg=[asm(i,:)+ass(i,:),fliplr(asm(i,:)-ass(i,:))];
            h=fill(a2,reg,colormap(mod(j,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 4000])  
            ylim([0 600])
            hold on

    end
end
    legend('0.5lpm','1lpm','1.5lpm','2lpm','2.5lpm','Location','southeast')
set(gcf,'units','inches','position',[0,0,4,3])
set(gca,'FontSize',12, 'FontName', 'Times New Roman')
    ylabel('Bubble rise velocity (mm/s)')
    xlabel('Bubble area (mm^2)')
saveas(gca,'velocity_area.fig')
saveas(gca,'velocity_area.jpg')


%% width

colormap=[[0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0 0 0];[0.9290 0.6940 0.1250];[0.5 0 0.5];[0 0 0]];

for k=1
    for j=1:5
        w=arr{k,j}.widthmap;
        w2=[w,fliplr(w)];
        wsm=arr{k,j}.widthseg_mean;
        wss=arr{k,j}.widthseg_std;
        wsn=arr{k,j}.widthseg_num;
        i=1;
        plot(w,wsm(i,:),'-','LineWidth',1,'Color',colormap(mod(j,5)+1,:))
        
            
            hold on
            reg=[wsm(i,:)+wss(i,:),fliplr(wsm(i,:)-wss(i,:))];
            h=fill(w2,reg,colormap(mod(j,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 150])  
            ylim([0 600])
            hold on

    end
end
    legend('0.5lpm','1lpm','1.5lpm','2lpm','2.5lpm','Location','northeast')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10, 'FontName', 'Times New Roman')
    ylabel('Bubble rise velocity (mm/s)')
    xlabel('Bubble width (mm)')
saveas(gcf,'velocity_width.fig')
saveas(gcf,'velocity_width.jpg')
%%
colormap=[[0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.5 0 0.5]];
for i=1:7
    figure
    t = tiledlayout(2,2,'Padding','none');
    t.Units = 'inches';
    t.OuterPosition = [0.25 0.25 6.5 5];
    nexttile;
    for j=12:15
        if j==11
            continue;
        end
        a=arr{j}.areamap;
        y=arr{j}.ypos;
        y2=[y(9:180),fliplr(y(9:180))];
        a2=[a,fliplr(a)];
        ysm=arr{j}.yseg_mean;
        asm=arr{j}.areaseg_mean;
        yss=arr{j}.yseg_std;
        ass=arr{j}.areaseg_std;
        ysn=arr{j}.yseg_num;
        asn=arr{j}.areaseg_num;
        if i<=4
            plot(y(9:180),ysm(i,9:180),'Color',colormap(mod(j,5)+1,:))
            hold on
            reg=[ysm(i,9:180)+yss(i,9:180),fliplr(ysm(i,9:180)-yss(i,9:180))];
            h=fill(y2,reg,colormap(mod(j,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 600])
        elseif i==5
            plot(y(9:180),ysn(9:180),'Color',colormap(mod(j,5)+1,:))
            xlim([20 600])
        else
            plot(a,asm(i-5,:),'Color',colormap(mod(j,5)+1,:))
            hold on
            reg=[asm(i-5,:)+ass(i-5,:),fliplr(asm(i-5,:)-ass(i-5,:))];
            h=fill(a2,reg,colormap(mod(j,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
        end
        
        hold on
    end
%     if i~=5
%         p=getframe;
%         legend([p(1) p(3) p(5) p(7) p(9)],'0.5lpm','1lpm','1.5lpm','2lpm','2.5lpm')
%     else
        legend('1lpm','1.5lpm','2lpm','2.5lpm')
%     end
    
    set(gcf, 'Position',  [100, 100, 700, 550])
    set(gca,'FontSize',10,'FontName','Times New Roman')
    if i==1
        ylabel('Bubble velocity (mm/s)')
        xlabel('Relative y position from bottom (mm)')
        saveas(gca,'v_height.fig')
        exportgraphics(t,'v_height.jpg')
    elseif i==2
        ylabel('Bubble vertical velocity (mm/s)')
        xlabel('Relative y position from bottom (mm)')
        saveas(gca,'n_height.fig')
        exportgraphics(t,'n_height.jpg')
    elseif i==3
        ylabel('Bubble area (mm2)')
        xlabel('Relative y position from bottom (mm)')
        saveas(gca,'vy_height.fig')
        exportgraphics(t,'vy_height.jpg')
    elseif i==4
        ylabel('Coalesce number')
        xlabel('Relative y position from bottom (mm)')
        saveas(gca,'area_height.fig')
        exportgraphics(t,'area_height.jpg')
    elseif i==5
        ylabel('Sample size')
        xlabel('Height (mm)')
        saveas(gca,'nc_height.fig')
        exportgraphics(t,'nc_height.jpg')
    elseif i==6
        ylabel('Bubble velocity (mm/s)')
        xlabel('Bubble area (mm2)')
        saveas(gca,'v_area.fig')
        exportgraphics(t,'v_area.jpg')
    elseif i==7
        ylabel('Bubble velocity (mm/s)')
        xlabel('Bubble area (mm2)')
        saveas(gca,'vy_area.fig')
        exportgraphics(t,'vy_area.jpg')
    end
end

%%

colormap=[[0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.5 0 0.5]];
figure
t = tiledlayout(2,2,'Padding','Compact','TileSpacing','Compact');
lb=1;
ub=118;
for i=1:4
    nexttile;
    for j=1:5
%         if j==11
%             continue;
%         end
        a=arr{j}.areamap;
        y=arr{j}.ypos;
        y2=[y(lb:ub),fliplr(y(lb:ub))];
        a2=[a,fliplr(a)];
        ysm=arr{j}.yseg_mean;
        asm=arr{j}.areaseg_mean;
        yss=arr{j}.yseg_std;
        ass=arr{j}.areaseg_std;
        ysn=arr{j}.yseg_num;
        asn=arr{j}.areaseg_num;
        if i==1
            plot(y(lb:ub),ysm(1,lb:ub),'Color',colormap(mod(j,5)+1,:))
            hold on
            reg=[ysm(1,lb:ub)+yss(1,lb:ub),fliplr(ysm(1,lb:ub)-yss(1,lb:ub))];
            h=fill(y2,reg,colormap(mod(j,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 600])
            ylim([0 max(ysm(1,lb:ub)+yss(1,lb:ub))])
        elseif i==2
            plot(a,asm(2,:),'Color',colormap(mod(j,5)+1,:))
            hold on
            reg=[asm(2,:)+ass(2,:),fliplr(asm(2,:)-ass(2,:))];
            h=fill(a2,reg,colormap(mod(j,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            ylim([0 50])
        elseif i==3
            plot(y(lb:ub),ysm(3,lb:ub),'Color',colormap(mod(j,5)+1,:))
            hold on
            reg=[ysm(3,lb:ub)+yss(3,lb:ub),fliplr(ysm(3,lb:ub)-yss(3,lb:ub))];
            h=fill(y2,reg,colormap(mod(j,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 600])
            ylim([0 max(ysm(3,lb:ub)+yss(3,lb:ub))])
        else
            plot(y(lb:ub),ysn(lb:ub),'Color',colormap(mod(j,5)+1,:))
            xlim([20 600])
            if mod(j,5)==1
                ylim([0 max(ysn(1,lb:ub))])
            end
        end
        
        hold on
    end
    set(gcf, 'Position',  [100, 100, 700, 550])
    set(gca,'FontSize',10,'FontName','Times New Roman')
    if i==1
        ylabel('Bubble Vertical Velocity (mm/s)')
        xlabel('Height (mm)')
    elseif i==2
        ylabel('Bubble Vertical Velocity (mm/s)')
        xlabel('Area (mm^2)')
    elseif i==3
        ylabel('Bubble Area (mm^2)')
        xlabel('Height (mm)')
    elseif i==4
        ylabel('Sample size')
        xlabel('Height (mm)')
    end
end
lg=legend('0.1lpm','0.2lpm','0.3lpm','0.4lpm','0.5lpm','Orientation','Horizontal','NumColumns',5);
lg.Layout.Tile = 'South';

saveas(gca,'all.fig')
exportgraphics(t,'all.jpg','Resolution',300)
%%
colormap=[[0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.5 0 0.5]];
figure
t = tiledlayout(2,2,'Padding','Compact','TileSpacing','Compact');

k=5;
for i=1:4
    nexttile;
    for j1=1:9
        if j1==3 || j1==4 ||j1==5 || j1==6 
           continue
        end
        %j=(j1-1)*5+1;
        j=j1;
        a=arr{j,k}.areamap;
        y=arr{j,k}.ypos;
        y2=[y,fliplr(y)];
        a2=[a,fliplr(a)];
        ysm=arr{j,k}.yseg_mean;
        asm=arr{j,k}.areaseg_mean;
        yss=arr{j,k}.yseg_std;
        ass=arr{j,k}.areaseg_std;
        ysn=arr{j,k}.yseg_num;
        asn=arr{j,k}.areaseg_num;
        if i==1
            plot(y,ysm(1,:),'Color',colormap(mod(j1,5)+1,:))
            hold on
            reg=[ysm(1,:)+yss(1,:),fliplr(ysm(1,:)-yss(1,:))];
            h=fill(y2,reg,colormap(mod(j1,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 600])
            ylim([0 800])
        elseif i==2
            plot(a,asm(2,:),'Color',colormap(mod(j1,5)+1,:))
            hold on
            reg=[asm(2,:)+ass(2,:),fliplr(asm(2,:)-ass(2,:))];
            h=fill(a2,reg,colormap(mod(j1,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([50 3000])
            ylim([0 900])
        elseif i==3
            plot(y(:),ysm(3,:),'Color',colormap(mod(j1,5)+1,:))
            hold on
            reg=[ysm(3,:)+yss(3,:),fliplr(ysm(3,:)-yss(3,:))];
            h=fill(y2,reg,colormap(mod(j1,5)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 600])
            ylim([0 2500])
        else
            plot(y(:),ysn(:),'Color',colormap(mod(j1,5)+1,:))
            xlim([20 600])
            if mod(j1,5)==1
                ylim([0 7000])
            end
        end
        
        hold on
    end
    set(gcf, 'Position',  [100, 100, 700, 550])
    set(gca,'FontSize',10,'FontName','Times New Roman')
    if i==1
        ylabel('Bubble Vertical Velocity (mm/s)')
        xlabel('Height (mm)')
    elseif i==2
        ylabel('Bubble Vertical Velocity (mm/s)')
        xlabel('Area (mm^2)')
    elseif i==3
        ylabel('Bubble Area (mm^2)')
        xlabel('Height (mm)')
    elseif i==4
        ylabel('Sample size')
        xlabel('Height (mm)')
    end
end
lg=legend('35% unmatched','40% unmatched','10% unmatched','20% unmatched','30% unmatched','Orientation','Horizontal','NumColumns',5,'FontSize',8.5);
lg.Layout.Tile = 'South';

saveas(gca,'2.5.fig')
exportgraphics(t,'2.5.jpg','Resolution',300)