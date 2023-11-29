write=false;
fps=250;
minbubarea=15;

AREA=1;
CENTROID_X=2;
CENTROID_Y=3;
TOP_LEFT_X=4;
TOP_LEFT_Y=5;
BOTTOM_LEFT_X=6;
BOTTOM_LEFT_Y=7;
ASP=8;
V_X=9;
V_Y=10;
V=11;
COALESCED=12;
SPLIT=13;
NCOALESCE=14;
RIGHT_BOTTOM_X=15;
RIGHT_BOTTOM_Y=16;
LEFT_BOTTOM_X=17;
LEFT_BOTTOM_Y=18;
%%

outputArray=zeros(100,18,30000);
I=binarizedArray(:,:,1);
I2=bwareaopen(I,minbubarea);
L=bwlabeln(I2,4);
s=regionprops(L,'Centroid','Area','Extrema');
previous_frame=frame(s,L,1);
if write
    vo=VideoWriter('track.avi');
    myfig=figure();
    open(vo)
end


for i=2:size(binarizedArray,3)
        FRAME=i;
        I=binarizedArray(:,:,FRAME);

        
        I2=bwareaopen(I,minbubarea);
        L=bwlabeln(I2,4);
        
        s=regionprops(L,'Centroid','Area','Extrema');

        current_frame=frame(s,L,i);
        current_frame=current_frame.track_frame(previous_frame,15,5000);
% 
            if write && i<1000
              current_frame.writeFrame(vo,myfig);
            end   
        outputArray(:,:,i)=frame2Array(current_frame);
        previous_frame=current_frame;
        
end
if write
    close(vo)
end

%%
ca=zeros(0,2);
caa=zeros(0,2);
can=zeros(0,1);
cau=zeros(0,1);
for i=1:30000
    for j=1:100
        if outputArray(j,COALESCED,i)~=0 && outputArray(j,CENTROID_X,i)>10 && outputArray(j,NCOALESCE,i)>0
            ca=cat(1,ca,[outputArray(j,CENTROID_X,i)*dx outputArray(j,CENTROID_Y,i)*dx]);
            caa=cat(1,caa,[outputArray(j,CENTROID_Y,i)*dx outputArray(j,AREA,i)*dx*dx]);
            can=cat(1,can,round(outputArray(j,NCOALESCE,i)*2)/2);
        end
    end
end
%%
g=gscatter(ca(:,1),ca(:,2),can,'');
set(gca,'Ydir','reverse')
xlim([1 (xmax-xmin)*dx])
ylim([1 (ymax-ymin)*dx])
daspect([1 1 1])
set(gca,'Ydir','reverse')
saveas(gcf,'coord.jpg');
saveas(gcf,'coord.fig');


%%
figure
h=gscatter((ymax-ymin)*dx-caa(:,1),caa(:,2),can);
xlim([1 ymax-ymin])
xlabel('Y Coordinates')
ylabel('Area')
saveas(gcf,'coarea.jpg');
saveas(gcf,'coarea.fig');

%%
dy=5;
height=size(binarizedArray,1);
yheight=0:dy:height;
ymap=(height-yheight)*dx;
yseg=cell(4,size(yheight,2));
darea=50;
dwidth=1;
max_area=100000;
areamap=(1:darea:max_area)*dx*dx;
areaseg=cell(3,size(areamap,2));
max_width=200;
widthmap=(1:dwidth:max_width)*dx;
widthseg=cell(1,size(widthmap,2));
for i=1:30000
    
        for j=1:100
            if outputArray(j,BOTTOM_LEFT_Y,i)<height && outputArray(j,TOP_LEFT_Y,i)>0 && outputArray(j,AREA,i)>minbubarea ...
                &&outputArray(j,SPLIT,i)==0 && outputArray(j,COALESCED,i)==0 && outputArray(j,V,i)>0 
                yseg{1,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{1,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,V,i)*fps*dx);
                yseg{2,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{2,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,V_Y,i)*fps*dx);
                yseg{3,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{3,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,AREA,i)*dx*dx);
                yseg{4,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{4,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,NCOALESCE,i));
                
                areaseg{1,floor(outputArray(j,AREA,i)/darea)+1}=cat(2,areaseg{1,floor(outputArray(j,AREA,i)/darea)+1},outputArray(j,V,i)*fps*dx);
                areaseg{2,floor(outputArray(j,AREA,i)/darea)+1}=cat(2,areaseg{2,floor(outputArray(j,AREA,i)/darea)+1},outputArray(j,V_Y,i)*fps*dx);
                areaseg{3,floor(outputArray(j,AREA,i)/darea)+1}=cat(2,areaseg{3,floor(outputArray(j,AREA,i)/darea)+1},outputArray(j,NCOALESCE,i));
                
                widthseg{1,floor((outputArray(j,RIGHT_BOTTOM_X,i)- outputArray(j,LEFT_BOTTOM_X,i))/dwidth)+1}=cat(2,widthseg{1,floor((outputArray(j,RIGHT_BOTTOM_X,i)- outputArray(j,LEFT_BOTTOM_X,i))/dwidth)+1},outputArray(j,V_Y,i)*fps*dx);
            end
        end
end

yseg2={};
ymap2=[];
ki=1;
for k=1:height/dy
    if size(yseg{1,k},2)>0
        yseg2{1,ki}=yseg{1,k};
        yseg2{2,ki}=yseg{2,k};
        yseg2{3,ki}=yseg{3,k};
        yseg2{4,ki}=yseg{4,k};
        ymap2(ki)=ymap(k);
        ki=ki+1;
    end
end


areaseg2={};
areamap2=[];
ki=1;
for k=1:max_area/darea
    if size(areaseg{1,k},2)>0
        areaseg2{1,ki}=areaseg{1,k};
        areaseg2{2,ki}=areaseg{2,k};
        areaseg2{3,ki}=areaseg{3,k};
        areamap2(ki)=areamap(k);
        ki=ki+1;
    end
end

widthseg2={};
widthmap2=[];
ki=1;
for k=1:max_width/dwidth
    if size(widthseg{1,k},2)>0
        widthseg2{1,ki}=widthseg{1,k};
        widthmap2(ki)=widthmap(k);
        ki=ki+1;
    end
end

yseg_mean=zeros(4,size(ymap2,2));
yseg_std=zeros(4,size(ymap2,2));
yseg_num=zeros(1,size(ymap2,2));

areaseg_mean=zeros(3,size(areamap2,2));
areaseg_std=zeros(3,size(areamap2,2));
areaseg_num=zeros(1,size(areamap2,2));

widthseg_mean=zeros(1,size(widthmap2,2));
widthseg_std=zeros(1,size(widthmap2,2));
widthseg_num=zeros(1,size(widthmap2,2));

for i=1:size(ymap2,2)
    for j=1:4
        yseg_mean(j,i)=mean(yseg2{j,i});
        yseg_std(j,i)=std(yseg2{j,i});
    end
    yseg_num(i)=size(yseg2{1,i},2);
end

for i=1:size(areamap2,2)
    for j=1:3
        areaseg_mean(j,i)=mean(areaseg2{j,i});
        areaseg_std(j,i)=std(areaseg2{j,i});
    end
    areaseg_num(i)=size(areaseg2{1,i},2);
end

for i=1:size(widthmap2,2)
    for j=1
        widthseg_mean(j,i)=mean(widthseg2{j,i});
        widthseg_std(j,i)=std(widthseg2{j,i});
    end
    widthseg_num(i)=size(widthseg2{1,i},2);
end

% save('all2.mat','-v7.3','areamap2','dx','fps','areaseg2','yseg','height','yheight')
% clear all
%%
figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
ypos=ymap2;
ypos2=[ypos,fliplr(ypos)];
plot(ypos,yseg_mean(1,:),'b')
hold on
reg=[yseg_mean(1,:)+yseg_std(1,:),fliplr(yseg_mean(1,:)-yseg_std(1,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
xlim([0 height*dx])
ylim([0 max(yseg_mean(1,:)+yseg_std(1,:))])
legend('Mean bubble velocity','Mean velocity ± SD')
ylabel('Bubble velocity (mm/s)')
xlabel('Relative y position from bottom (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'avg_v.fig')
exportgraphics(t,'avg_v.jpg')


figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
plot(ypos,yseg_mean(2,:),'b')
hold on
reg=[yseg_mean(2,:)+yseg_std(2,:),fliplr(yseg_mean(2,:)-yseg_std(2,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
xlim([0 height*dx])
ylim([0 max(yseg_mean(2,:)+yseg_std(2,:))])
legend('Mean bubble rising velocity','Mean rising velocity ± SD')
ylabel('Bubble vertical velocity (mm/s)')
xlabel('Relative y position from bottom (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'avg_v_y.fig')
exportgraphics(t,'avg_v_y.jpg')
%% Area
p=randperm(size(caa,1),500);
figure
ypos2=[ypos,fliplr(ypos)];
plot(ypos,yseg_mean(3,:),'b')
hold on
plot((ymax-ymin)*dx-caa(p,1),caa(p,2),'^');
reg=[yseg_mean(3,:)+yseg_std(3,:),fliplr(yseg_mean(3,:)-yseg_std(3,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
hold on
fill([1 1 54 54],[-1 1100 1100 -1],'r','facealpha',0.1)
hold on 
fill([160 160 231 231],[-1 1100 1100 -1],'r','facealpha',0.1)
hold on 
xline(160)
hold on 
xline(231)
set(h,'facealpha',0.1)
xlim([0 height*dx])
ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
legend('Mean bubble area','Coalescence events','Mean area ± SD','Location','southeast')
ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
ylabel('Bubble area (mm^2)')
xlabel('Bubble height (mm)')
set(gcf,'units','inches','position',[0,0,4,3])
set(gca,'FontSize',12,'FontName','Times New Roman')

saveas(gca,'avg_area.fig')
saveas(gca,'avg_area.svg')
%% Width
figure
widthmap3=[widthmap2,fliplr(widthmap2)];
plot(widthmap2,widthseg_mean(1,:),'b')
hold on
reg=[widthseg_mean(1,:)+widthseg_std(1,:),fliplr(widthseg_mean(1,:)-widthseg_std(1,:))];
h=fill(widthmap3,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
hold on
set(h,'facealpha',0.1)
%xlim([4 150])
ylim([0 max(widthseg_mean(1,:)+widthseg_std(1,:))])
legend('Mean v_y','Mean v_y ± SD','Location','northeast')
%ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
ylabel('Bubble rise velocity (mm/s)')
xlabel('Bubble width (mm)')
set(gcf,'units','inches','position',[0,0,4,3])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'vy_width.fig')
saveas(gca,'vy_width.jpg')
%%
figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
plot(ypos,yseg_mean(4,:),'b')
hold on
reg=[yseg_mean(4,:)+yseg_std(4,:),fliplr(yseg_mean(4,:)-yseg_std(4,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
xlim([0 height*dx])
ylim([0 max(yseg_mean(4,:)+yseg_std(4,:))])
legend('Mean coalesce number','Mean coalesce number ± SD','Location','northwest')
%  ylim([0 2.5])
ylabel('Coalesce number')
xlabel('Relative y position from bottom (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'avgco.fig')
exportgraphics(t,'avgco.jpg')

figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
plot(ypos,yseg_num)
xlim([0 height*dx]) 
ylim([0 max(yseg_num)])
ylabel('sample size')
xlabel('height (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',10)
saveas(gca,'nbubbles.fig')
exportgraphics(t,'nbubbles.jpg')

%%
figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
plot(areamap2,areaseg_mean(1,:),'b')
hold on
areamap3=[areamap2, fliplr(areamap2)];
reg=[areaseg_mean(1,:)+areaseg_std(1,:),fliplr(areaseg_mean(1,:)-areaseg_std(1,:))];
h=fill(areamap3,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
legend('Mean bubble velocity','Mean velocity ± SD','Location','northeast')
xlim([0 max(areamap2)]) 
ylim([0 max(areaseg_mean(1,:)+areaseg_std(1,:))])
ylabel('Bubble velocity (mm/s)')
xlabel('Bubble area (mm2)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'v_area.fig')
exportgraphics(t,'v_area.jpg')

figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
plot(areamap2,areaseg_mean(2,:),'b')
hold on
areamap3=[areamap2, fliplr(areamap2)];
reg=[areaseg_mean(2,:)+areaseg_std(2,:),fliplr(areaseg_mean(2,:)-areaseg_std(2,:))];
h=fill(areamap3,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
legend('Mean bubble rising velocity','Mean rising velocity ± SD','Location','northeast')
xlim([0 max(areamap2)]) 
ylim([0 max(areaseg_mean(2,:)+areaseg_std(2,:))])
ylabel('Bubble velocity (mm/s)')
xlabel('Bubble area (mm2)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'vy_area.fig')
exportgraphics(t,'vy_area.jpg')

figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
plot(areamap2,areaseg_mean(3,:),'b')
hold on
areamap3=[areamap2, fliplr(areamap2)];
reg=[areaseg_mean(3,:)+areaseg_std(3,:),fliplr(areaseg_mean(3,:)-areaseg_std(3,:))];
h=fill(areamap3,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
legend('Mean coalesce number','Mean coalesce number ± SD','Location','northeast')
xlim([0 max(areamap2)]) 
ylim([0 max(areaseg_mean(3,:)+areaseg_std(3,:))])
ylabel('Coalesce number')
xlabel('Bubble area (mm2)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'nc_area.fig')
exportgraphics(t,'nc_area.jpg')


%%
save('all.mat','-v7.3','outputArray','ypos','yseg','yseg_mean','yseg_num','yseg_std', ...
    'fps','areaseg2','areaseg_mean','areaseg_num','areaseg_std','height','dy','darea','dx', ...
    'areamap2','widthseg2','widthseg_mean','widthseg_num','widthseg_std','dwidth','widthmap2')
clear all