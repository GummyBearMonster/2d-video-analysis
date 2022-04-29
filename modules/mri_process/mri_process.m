%%
write=true;
fps=25;
minbubarea=0;

AREA=1;
CENTROID_X=2;
CENTROID_Y=3;
TOP_LEFT_X=4;
TOP_LEFT_Y=5;
BOTTOM_LEFT_X=6;
BOTTOM_LEFT_Y=7;
V_Y=8;
V=9;
COALESCED=10;
SPLIT=11;
NCOALESCE=12;
RIGHT_BOTTOM_X=13;
RIGHT_BOTTOM_Y=14;
LEFT_BOTTOM_X=15;
LEFT_BOTTOM_Y=16;
ID=17;

%%

%dx = dx/2;
startFrame = 1;
outputArray=zeros(50,17,size(binarizedArray,3));
I=zeros(size(binarizedArray,1),size(binarizedArray,2));
I2=bwareaopen(I,minbubarea);
L=bwlabeln(I2,4);
s=regionprops(L,'Centroid','Area','Extrema');
previous_frame=frame_mri(s,L,1);
if write
    vo=VideoWriter('track.avi');
    vo.FrameRate=5;
    open(vo)
end
id_cnt=0;
height=size(binarizedArray,1);
width=size(binarizedArray,2);
for i=startFrame:size(binarizedArray,3)
        FRAME=i;
        I=binarizedArray(:,:,FRAME);

        I=imcomplement(I);
        I=bwareaopen(I,3);
        I=imcomplement(I);
        
        I2=bwareaopen(I,minbubarea);
        L=bwlabeln(I2,8);
        
        s=regionprops(L,'Centroid','Area','Extrema');

        current_frame=frame_mri(s,L,i);
        current_frame=current_frame.track_frame(previous_frame,10,500,id_cnt,7);

            if write && i<startFrame+3000
              current_frame.writeFrame(vo,I);
            end   
        [arr,id_cnt]=frame2Array(current_frame);
        outputArray(:,:,i-startFrame+1)=arr;
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
cnt=0;
for i=1:size(outputArray,3)
    for j=1:50
        if outputArray(j,COALESCED,i)~=0  && outputArray(j,LEFT_BOTTOM_X,i)>2 && outputArray(j,RIGHT_BOTTOM_X,i)<width-2
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
xlim([1 300])
xlabel('Height (mm)')
ylabel('Area (mm^2)')
saveas(gcf,'coarea.jpg');
saveas(gcf,'coarea.fig');


%%
dy=10;

yheight=0:dy:height;
ymap=(height-yheight)*dx;
yseg=cell(1,size(yheight,2));
num_co=zeros(1,size(yheight,2));
num_split=zeros(1,size(yheight,2));


for i=1:size(outputArray,3)
    
    for j=1:50
        if outputArray(j,BOTTOM_LEFT_Y,i)<height-1 && outputArray(j,TOP_LEFT_Y,i)>0 ...
                &&outputArray(j,LEFT_BOTTOM_X,i)>2 && outputArray(j,RIGHT_BOTTOM_X,i)<width-2
            yseg{1,floor(outputArray(j,CENTROID_Y,i)/dy)+1}=cat(2,yseg{1,floor(outputArray(j,CENTROID_Y,i)/dy)+1},outputArray(j,AREA,i)*dx*dx);
            num_co(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)=num_co(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)+outputArray(j,COALESCED,i);
            num_split(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)=num_split(1,floor(outputArray(j,CENTROID_Y,i)/dy)+1)+outputArray(j,SPLIT,i);
            
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
        num_co2(1,ki)=num_co(1,k);
        num_split2(1,ki)=num_split(1,k);
        
        ymap2(ki)=ymap(k);
        ki=ki+1;
    end
end
yseg_mean=zeros(1,size(ymap2,2));
yseg_std=zeros(1,size(ymap2,2));
yseg_num=zeros(1,size(ymap2,2));

for i=1:size(ymap2,2)
    yseg_mean(1,i)=mean(yseg2{1,i});
    yseg_std(1,i)=std(yseg2{1,i});
    yseg_num(i)=size(yseg2{1,i},2);
end
ypos=ymap2;
%%
figure
ypos2=[ypos,fliplr(ypos)];
plot(ypos,yseg_mean(1,:),'b')
hold on
reg=[yseg_mean(1,:)+yseg_std(1,:),fliplr(yseg_mean(1,:)-yseg_std(1,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
xlim([0 300])
legend('Mean bubble area','Mean area ± SD','Location','northeast')
ylim([0 max(yseg_mean(1,:)+yseg_std(1,:))])
ylabel('Bubble area (mm^2)')
xlabel('Bubble height (mm)')
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'avg_area.fig')
saveas(gca,'avg_area.jpg')

figure
t = tiledlayout(1,1,'Padding','none');
t.Units = 'inches';
t.OuterPosition = [0.25 0.25 6.5 5];
nexttile;
colororder([0.5 0 0.5; 0 0 0])

yyaxis right
plot(ypos,yseg_mean(1,:),'k')
ylabel('Area (mm^2)')

yyaxis left
plot(ypos,num_co2,'r')

%hold on
%plot(ypos,num_split2,'b-')
legend('Coalescence')
xlim([0 300]) 
ylabel('Number of Ocurrences')
xlabel('Height (mm)')
set(gcf, 'Position',  [100, 100, 700, 550])
set(gca,'FontSize',10)
saveas(gca,'area_coalesce_split.fig')
exportgraphics(t,'area_coalesce_split.jpg')

%%
save('all_co.mat','-v7.3','outputArray','ypos','yseg','yseg_mean','yseg_num','yseg_std', ...
    'fps','height','dy','dx', 'num_co2')
close all