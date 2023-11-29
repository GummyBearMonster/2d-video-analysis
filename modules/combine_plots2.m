folders = dir('*35ms*');

for i = 1:size(folders,1)
    
    name = folders(i).name;
    %names{i}=name(8:end);
    cd(name)
    %load('all_co.mat','ypos','yseg_mean','yseg_num', ...
%         'yseg_std','num_co2')
    load('bubbles.mat')
    %s.areamap=areamap2;
%     s.ypos=ypos;
%     s.yseg_mean=yseg_mean;
%     %s.areaseg_mean=areaseg_mean;
%     s.yseg_num=yseg_num;
%     %s.areaseg_num=areaseg_num;
%     s.yseg_std=yseg_std;
%     %s.areaseg_std=areaseg_std;
%     %s.num_co=num_co2;
%     s.file=name;
    s.ypos = edges;
    s.yseg_mean = mean_area_vs_y;
    s.yseg_std = stdev_area_vs_y;
    arr{i,1}=s;
%     clear('s','ypos','yseg_mean','yseg_num', ...
%        'yseg_std','num_co2')
    cd ..
end

%%
ind=[1 2 3];

for i =1:size(ind,2)
    j = ind(i);%mod(i+9,11)+1;
    disp(j)
    y=arr{j,1}.ypos;
    ysm=arr{j,1}.yseg_mean;
    plot(y,ysm(1,:)./ysm(1,140),'LineWidth', 0.5)
%     plot(y,arr{j,1}.num_co)
%     area_200(i)=ysm(3,136);
%     area_100(i)=ysm(3,164);
%     area_20(i)=ysm(3,186);
%     area_80(i)=ysm(3,169);
    
    hold on
end
set(gca,'box','on') 
xlim([0 500])
%ylim([0 1.2])
%lgd=legend(names{ind});
lgd=legend('60','100','150');
title(lgd,['Idle' newline 'Time (ms)'])
set(gca,'FontSize',10, 'FontName', 'Times New Roman')
set(gcf,'units','inches','position',[0,0,4,3])
ylabel('Normalized Bubble Area')
xlabel('Bubble Vertical Position (mm)')
%  ylabel('Number of Coalescence')
%%
figure
bar(5:5:55,area_200./area_100);
ylim([1 2])
%legend('At 100mm','At 200mm')
ylabel('Area_{200}/Area_{100}')
xlabel('Valve Idle Time (ms)')

%%
figure
bar(65-[5:5:55],[area_80./area_20; area_200./area_100]);
ylim([1 2])
%legend('At 100mm','At 200mm')
legend('lower point','higher point')
ylabel('Area_{exit}/Area_{enter}')
xlabel('Bubble Injection Time (ms)')
%%
folders=dir('data/');

cd data
for i = 1:size(folders,1)-3
    
    name = folders(i+2).name;
    cd(name)
    load('regular.mat','res_freq1_amp','res_freq2_amp')
    res_freq1_amp_arr(i)=res_freq1_amp;
    res_freq2_amp_arr(i)=res_freq2_amp;
    cd ..
end
cd ..

%%

x=65-[5:5:55];
vals=[res_freq1_amp_arr; res_freq2_amp_arr];
vals2(:,2:11)=vals(:,1:10);
vals2(:,1)=vals(:,11);

bar(x,vals2)
ylabel('integrated signal')
xlabel('lpm')
legend('lower point','higher point')
%% Area Only
colormap=[[0.4660 0.6740 0.1880];[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.5 0 0.5];[0 0 0]];

for k=1:12
    for j=1
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
        if k==1
            plot(y,ysm(i,:),':','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
        elseif k==2
            plot(y,ysm(i,:),':','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
        elseif k==3
            plot(y,ysm(i,:),'--','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
        elseif k==4
            plot(y,ysm(i,:),'--','LineWidth',1.5,'Color',colormap(mod(k,6)+1,:))
        elseif k==5
            plot(y,ysm(i,:),'-','LineWidth',1,'Color',colormap(mod(k,6)+1,:))
        elseif k==6
            plot(y,ysm(i,:),'-','LineWidth',1,'Color',colormap(mod(k,6)+1,:))
        end
            
            hold on
            reg=[ysm(i,:)+yss(i,:),fliplr(ysm(i,:)-yss(i,:))];
            h=fill(y2,reg,colormap(mod(k,6)+1,:),'LineStyle','none','HandleVisibility','off');
            set(h,'facealpha',0.1)
            xlim([20 600])  
            ylim([0 2000])
            hold on

    end
end
    legend('10%','20%','30%','35%','40%','44%','Location','northwest')
set(gcf,'units','inches','position',[0,0,4,3])
set(gca,'FontSize',12, 'FontName', 'Times New Roman')
    ylabel('Bubble area (mm^2)')
    xlabel('Bubble height (mm)')
    saveas(gca,'area_height.fig')
saveas(gca,'area_height.jpg')
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