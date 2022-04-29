write=true;
fps=50;
minbubarea=50;

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
A_X=19;
A_Y=20;
A=21;
ID=22;
%%
startFrame = 1;
outputArray=zeros(100,22,size(binarizedArray,3));
I=zeros(size(binarizedArray,1),size(binarizedArray,2));
I2=bwareaopen(I,minbubarea);
L=bwlabeln(I2,4);
s=regionprops(L,'Centroid','Area','Extrema');
previous_frame=frame(s,L,1);
if write
    vo=VideoWriter('track.avi');
    vo.FrameRate=25;
    open(vo)
end
id_cnt=0;
height=size(binarizedArray,1);
for i=startFrame:size(binarizedArray,3)
        FRAME=i;
        I=binarizedArray(:,:,FRAME);

        I=imcomplement(I);
        I=bwareaopen(I,3);
        I=imcomplement(I);
        
        I2=bwareaopen(I,minbubarea);
        L=bwlabeln(I2,8);
        
        s=regionprops(L,'Centroid','Area','Extrema');

        current_frame=frame(s,L,i);
        current_frame=current_frame.track_frame(previous_frame,9,100,id_cnt,7);
% 
            if write && i<startFrame+100
              current_frame.writeFrame(vo,I);
            end   
        [arr,uparr,downarr,id_cnt]=frame2Array(current_frame);
        outputArray(:,:,i-startFrame+1)=arr;
        upArray(:,:,i-startFrame+1)=uparr;
        downArray(:,:,i-startFrame+1)=downarr;
        previous_frame=current_frame;
        
end
if write
    close(vo)
end

%%
height=size(binarizedArray,1);
width=size(binarizedArray,2);
ca=zeros(0,2);
caa=zeros(0,2);
can=zeros(0,1);
cau=zeros(0,1);
cnt=0;
for i=1:size(outputArray,3)
    for j=1:100
        if outputArray(j,COALESCED,i)~=0 && outputArray(j,NCOALESCE,i)>0 %&& outputArray(j,CENTROID_X,i)>10 
            ca=cat(1,ca,[outputArray(j,CENTROID_X,i) outputArray(j,CENTROID_Y,i)]);
            caa=cat(1,caa,[outputArray(j,CENTROID_Y,i) outputArray(j,AREA,i)]);
            can=cat(1,can,round(outputArray(j,NCOALESCE,i)*2)/2);
            cnt=cnt+1;
        end
    end
end
%%
figure
g=gscatter(ca(:,1)*dx,ca(:,2)*dx,can);
axis equal
set(gca,'Ydir','reverse')
lgn = legend();
lgn.Location='eastoutside';
xlim([1 width*dx])
ylim([1 height*dx])
set(gcf,'OuterPosition',[200 200 250 440]);
saveas(gcf,'coord.jpg');
saveas(gcf,'coord.fig');

figure
h=gscatter((height-caa(:,1))*dx,caa(:,2)*dx*dx,can);
lgn = legend();
lgn.Location='eastoutside';
xlim([1 600])
xlabel('Height (mm)')
ylabel('Area (mm^2)')
saveas(gcf,'coarea.jpg');
saveas(gcf,'coarea.fig');

%%
dy=10;

yheight=0:dy:height;
ymap=(height-yheight)*dx;
yupmap=(height-yheight)*dx;
ydownmap=(height-yheight)*dx;
yseg=cell(6,size(yheight,2));
yupseg=cell(6,size(yheight,2));
ydownseg=cell(6,size(yheight,2));
num_co=zeros(1,size(yheight,2));
num_split=zeros(1,size(yheight,2));

darea=5;
dwidth=1;
max_area=50000;
areamap=(1:darea:max_area)*dx*dx;
areaseg=cell(3,size(areamap,2));
max_width=1000;
widthmap=(1:dwidth:max_width)*dx;
widthseg=cell(1,size(widthmap,2));
for i=1:size(outputArray,3)
    
        for j=1:100
            if outputArray(j,BOTTOM_LEFT_Y,i)<height-1 && outputArray(j,TOP_LEFT_Y,i)>0 && outputArray(j,AREA,i)>minbubarea ...
                &&outputArray(j,SPLIT,i)==0 && outputArray(j,COALESCED,i)==0 && outputArray(j,V,i)>0 ...
                &&outputArray(j,LEFT_BOTTOM_X,i)>25 && outputArray(j,RIGHT_BOTTOM_X,i)<width-25
                yseg{1,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{1,floor(outputArray(j,CENTROID_Y,i)/dy)+1},(outputArray(j,RIGHT_BOTTOM_X,i)- outputArray(j,LEFT_BOTTOM_X,i))*dx);
                yseg{2,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{2,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,V_Y,i)*fps*dx);
                yseg{3,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{3,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,AREA,i)*dx*dx);
                yseg{4,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{4,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,NCOALESCE,i));
                yseg{5,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{5,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,A_Y,i)*fps*fps*dx);
                yseg{6,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{6,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,V_Y,i)*fps/(outputArray(j,RIGHT_BOTTOM_X,i)- outputArray(j,LEFT_BOTTOM_X,i)));
                
                areaseg{1,floor(outputArray(j,AREA,i)/darea)+1}=cat(2,areaseg{1,floor(outputArray(j,AREA,i)/darea)+1},outputArray(j,V,i)*fps*dx);
                areaseg{2,floor(outputArray(j,AREA,i)/darea)+1}=cat(2,areaseg{2,floor(outputArray(j,AREA,i)/darea)+1},outputArray(j,V_Y,i)*fps*dx);
                areaseg{3,floor(outputArray(j,AREA,i)/darea)+1}=cat(2,areaseg{3,floor(outputArray(j,AREA,i)/darea)+1},outputArray(j,NCOALESCE,i));
                
                widthseg{1,floor((outputArray(j,RIGHT_BOTTOM_X,i)- outputArray(j,LEFT_BOTTOM_X,i))/dwidth)+1}=cat(2,widthseg{1,floor((outputArray(j,RIGHT_BOTTOM_X,i)- outputArray(j,LEFT_BOTTOM_X,i))/dwidth)+1},outputArray(j,V_Y,i)*fps*dx);
                
            end
            num_co(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)=num_co(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)+outputArray(j,COALESCED,i);
            num_split(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)=num_split(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)+outputArray(j,SPLIT,i);
            if downArray(j,1,i)>0
                yupseg{1,floor(upArray(j,4,i)/dy)+1}=cat(2,yupseg{1,floor(upArray(j,4,i)/dy)+1},upArray(j,1,i)*dx*dx);
                yupseg{2,floor(upArray(j,4,i)/dy)+1}=cat(2,yupseg{2,floor(upArray(j,4,i)/dy)+1},upArray(j,2,i)*fps*dx);
                yupseg{3,floor(upArray(j,4,i)/dy)+1}=cat(2,yupseg{3,floor(upArray(j,4,i)/dy)+1},upArray(j,3,i)*dx);
                yupseg{5,floor(upArray(j,4,i)/dy)+1}=cat(2,yupseg{5,floor(upArray(j,4,i)/dy)+1},upArray(j,5,i)*fps*fps*dx);
                
                ydownseg{1,floor(downArray(j,4,i)/dy)+1}=cat(2,ydownseg{1,floor(downArray(j,4,i)/dy)+1},downArray(j,1,i)*dx*dx);
                ydownseg{2,floor(downArray(j,4,i)/dy)+1}=cat(2,ydownseg{2,floor(downArray(j,4,i)/dy)+1},downArray(j,2,i)*fps*dx);
                ydownseg{3,floor(downArray(j,4,i)/dy)+1}=cat(2,ydownseg{3,floor(downArray(j,4,i)/dy)+1},downArray(j,3,i)*dx);
                ydownseg{5,floor(downArray(j,4,i)/dy)+1}=cat(2,ydownseg{5,floor(downArray(j,4,i)/dy)+1},downArray(j,5,i)*fps*fps*dx);
            
            end
                
        end
end
%%
num_co2=[];
num_split2=[];
yseg2={};
ymap2=[];
ki=1;
for k=1:height/dy
    if size(yseg{1,k},2)>0
        yseg2{1,ki}=yseg{1,k};
        yseg2{2,ki}=yseg{2,k};
        yseg2{3,ki}=yseg{3,k};
        yseg2{4,ki}=yseg{4,k};
        yseg2{5,ki}=yseg{5,k};
        yseg2{6,ki}=yseg{6,k};
        num_co2(1,ki)=num_co(1,k);
        num_split2(1,ki)=num_split(1,k);
        
        ymap2(ki)=ymap(k);
        ki=ki+1;
    end
end

yupseg2={};
yupmap2=[];
ki=1;
for k=1:height/dy
    if size(yupseg{1,k},2)>0
        yupseg2{1,ki}=yupseg{1,k};
        yupseg2{2,ki}=yupseg{2,k};
        yupseg2{3,ki}=yupseg{3,k};
        yupseg2{4,ki}=yupseg{4,k};
        yupmap2(ki)=yupmap(k);
        ki=ki+1;
    end
end

ydownseg2={};
ydownmap2=[];
ki=1;
for k=1:height/dy
    if size(yseg{1,k},2)>0
        ydownseg2{1,ki}=ydownseg{1,k};
        ydownseg2{2,ki}=ydownseg{2,k};
        ydownseg2{3,ki}=ydownseg{3,k};
        ydownseg2{4,ki}=ydownseg{4,k};
        ydownmap2(ki)=ydownmap(k);
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

yseg_mean=zeros(6,size(ymap2,2));
yseg_std=zeros(6,size(ymap2,2));
yseg_num=zeros(1,size(ymap2,2));

yupseg_mean=zeros(3,size(yupmap2,2));
yupseg_std=zeros(3,size(yupmap2,2));
yupseg_num=zeros(1,size(yupmap2,2));

ydownseg_mean=zeros(3,size(ydownmap2,2));
ydownseg_std=zeros(3,size(ydownmap2,2));
ydownseg_num=zeros(1,size(ydownmap2,2));

areaseg_mean=zeros(3,size(areamap2,2));
areaseg_std=zeros(3,size(areamap2,2));
areaseg_num=zeros(1,size(areamap2,2));

widthseg_mean=zeros(1,size(widthmap2,2));
widthseg_std=zeros(1,size(widthmap2,2));
widthseg_num=zeros(1,size(widthmap2,2));

for i=1:size(ymap2,2)
    for j=1:6
        yseg_mean(j,i)=mean(yseg2{j,i});
        yseg_std(j,i)=std(yseg2{j,i});
    end
    yseg_num(i)=size(yseg2{1,i},2);
end


for i=1:size(yupmap2,2)
    for j=1:3
        yupseg_mean(j,i)=mean(yupseg2{j,i});
        yupseg_std(j,i)=std(yupseg2{j,i});
        ydownseg_mean(j,i)=mean(ydownseg2{j,i});
        ydownseg_std(j,i)=std(ydownseg2{j,i});
    end
    yupseg_num(i)=size(yupseg2{1,i},2);
    ydownseg_num(i)=size(ydownseg2{1,i},2);
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
ypos=ymap2;
% save('all2.mat','-v7.3','areamap2','dx','fps','areaseg2','yseg','height','yheight')
% clear all
%%
figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;

ypos2=[ypos,fliplr(ypos)];
plot(ypos,yseg_mean(1,:),'b')
hold on
reg=[yseg_mean(1,:)+yseg_std(1,:),fliplr(yseg_mean(1,:)-yseg_std(1,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
%xlim([0 height*dx])
%ylim([0 max(yseg_mean(1,:)+yseg_std(1,:))])
legend('Mean bubble width','Mean velocity ± SD')
ylabel('Bubble width (mm)')
xlabel('Relative y position from bottom (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'avg_width.fig')
exportgraphics(t,'avg_width.jpg')


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
%xlim([0 height*dx])
ylim([0 max(yseg_mean(2,:)+yseg_std(2,:))])
legend('Mean bubble rising velocity','Mean rising velocity ± SD')
ylabel('Bubble vertical velocity (mm/s)')
xlabel('Relative y position from bottom (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'avg_v_y.fig')
exportgraphics(t,'avg_v_y.jpg')
%%
figure
ypos2=[ypos,fliplr(ypos)];
plot(ypos,yseg_mean(3,:),'b')
hold on
reg=[yseg_mean(3,:)+yseg_std(3,:),fliplr(yseg_mean(3,:)-yseg_std(3,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
%hold on
%fill([1 1 54 54],[-1 1100 1100 -1],'r','facealpha',0.1)
%hold on 
%fill([146 146 266 266],[-1 1100 1100 -1],'r','facealpha',0.1)
% hold on 
% xline(160)
% hold on 
% xline(231)
set(h,'facealpha',0.1)
%xlim([0 height*dx])
%ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
legend('Mean bubble area','Mean area ± SD','Location','northeast')
ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
ylabel('Bubble area (mm^2)')
xlabel('Bubble height (mm)')
%set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'avg_area.fig')
saveas(gca,'avg_area.jpg')

%% Shear rate
figure
ypos2=[ypos,fliplr(ypos)];
plot(ypos,yseg_mean(6,:),'b')
hold on
reg=[yseg_mean(6,:)+yseg_std(6,:),fliplr(yseg_mean(6,:)-yseg_std(6,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
%xlim([0 height*dx])
%ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
legend('Mean bubble shear','Mean shear ± SD','Location','northeast')
ylim([0 max(yseg_mean(6,:)+yseg_std(6,:))])
ylabel('Shear Rate (s^{-1})')
xlabel('Bubble height (mm)')
%set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'avg_shear.fig')
saveas(gca,'avg_shear.jpg')

% 
% figure
% semilogx(x,avg_vis,'k')
% hold on
% for i=1:size(yseg_mean,2)
%     semilogx(yseg_mean(6,i),avg_vis(round((yseg_mean(6,i)-0.1)/0.001+1)),'b*')
% end
% xlim([0.1 20])
% ylim([0 2])
% ylabel(['Effective viscosity, $\eta$' newline ' (Pa$\cdot$s)'],'interpreter','latex')
% xlabel('Shear rate, $\dot{\gamma}$ ($s^{-1}$)','interpreter','latex')
% set(gcf,'units','inches','position',[5,6,2.16,2])
% set(gca,'FontSize',10,'FontName','Times New Roman')
% 
% saveas(gca,'avg_shear_vis.fig')
% saveas(gca,'avg_shear_vis.jpg')
% 
% figure
% semilogx(x,avg_vis,'k')
% hold ona
% dc=zeros(7,0);
% uc=zeros(7,0);
% for i = 1:size(downArray,3)
%     for j=1:100
%         if downArray(j,1,i)>0
%             dc=cat(2,dc,[downArray(j,:,i) i].');
%             uc=cat(2,uc,[upArray(j,:,i) i].');
%         end
%     end
% end
% 
% for i =1:size(uc,2)
%     if (uc(2,i)/uc(3,i)*fps-0.1)>0 
%             semilogx(uc(2,i)/uc(3,i)*fps,avg_vis(round((uc(2,i)/uc(3,i)*fps-0.1)/0.001+1)),'g^')
%     end
% end
% h = zeros(3, 1);
% h(1) = plot(-1,-1,'k-');
% h(2) = plot(-1,-1,'r*');
% h(3) = plot(-1,-1,'g^');
% ylim([0 0.004])
% legend(h(3), 'Leading','Location','northeast');
% ylabel(['Effective viscosity, $\eta$' newline ' (Pa$\cdot$s)'],'interpreter','latex')
% xlabel('Shear rate, $\dot{\gamma}$ ($s^{-1}$)','interpreter','latex')
% 
% set(gcf,'units','inches','position',[5,6,2.16,2])
% set(gca,'FontSize',10,'FontName','Times New Roman')
% saveas(gca,'leading_shear_viscosity.fig')
% saveas(gca,'leading_shear_viscosity.jpg')
%% Width
figure
widthmap3=[widthmap2,fliplr(widthmap2)];
plot(widthmap2,widthseg_mean(1,:),'b')
hold on
reg=[widthseg_mean(1,:)+widthseg_std(1,:),fliplr(widthseg_mean(1,:)-widthseg_std(1,:))];
h=fill(widthmap3,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
hold on
set(h,'facealpha',0.1)
%xlim([0 100])
%ylim([0 max(widthseg_mean(1,:)+widthseg_std(1,:))])
legend('Mean v_y','Mean v_y ± SD','Location','southeast')
%ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
ylabel('Bubble rise velocity (mm/s)')
xlabel('Bubble width (mm)')
%set(gcf,'units','inches','position',[0,0,4,3])
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
%xlim([0 height*dx])
%ylim([0 max(yseg_mean(4,:)+yseg_std(4,:))])
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
%xlim([0 height*dx]) 
%ylim([0 max(yseg_num)])
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
colororder([0.5 0 0.5; 0 0 0])

yyaxis right
plot(ypos,yseg_mean(3,:),'k')
ylabel('Area (mm^2)')

yyaxis left
plot(ypos,num_co2,'r')

hold on
plot(ypos,num_split2,'b-')
legend('Coalescence','Splitting')
xlim([0 600]) 
ylabel('Number of Ocurrences')
xlabel('Height (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',10)
saveas(gca,'area_coalesce_split.fig')
exportgraphics(t,'area_coalesce_split.jpg')
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
%xlim([0 max(areamap2)]) 
%ylim([0 max(areaseg_mean(1,:)+areaseg_std(1,:))])
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
legend('Mean bubble rising velocity','Mean rising velocity ± SD')
%xlim([0 max(areamap2)]) 
%ylim([0 max(areaseg_mean(2,:)+areaseg_std(2,:))])
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
legend('Mean coalesce number','Mean coalesce number ± SD')
%xlim([0 max(areamap2)]) 
%ylim([0 max(areaseg_mean(3,:)+areaseg_std(3,:))])
ylabel('Coalesce number')
xlabel('Bubble area (mm2)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'nc_area.fig')
exportgraphics(t,'nc_area.jpg')







%%
save('all_co.mat','-v7.3','outputArray','ypos','yseg','yseg_mean','yseg_num','yseg_std', ...
    'fps','areaseg2','areaseg_mean','areaseg_num','areaseg_std','height','dy','darea','dx', ...
    'areamap2','widthseg2','widthseg_mean','widthseg_num','widthseg_std','dwidth','widthmap2',...
    'yupseg2','ydownseg2','yupseg_mean','ydownseg_mean','yupseg_std','ydownseg_std','yupmap2','ydownmap2', ...
    'upArray','downArray','num_co2')
clear all
close all