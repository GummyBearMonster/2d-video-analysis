v = VideoReader('20psi-1lpm-500fps.mp4');

freq = 3.04;
frames = round(500/freq);
for i = 1:5
    
    I=v.read((i-1)*frames+1000);
    I = I(ymin:ymax,xmin:xmax);
    imshow(I,'Border','tight');
    %t = annotation('textbox',[0 0 0.25 0.04],'String',[int2str((i-6642)*1/250*1000) 'ms']);
    %t.BackgroundColor='w';
    %t.FaceAlpha=0.5;
    %t.EdgeColor='None';
    f=getframe(gcf);
    x=frame2im(f);
    imwrite(x, ['t=' int2str((i-1) / freq * 1000) 'ms.jpg']);
end

%%
v = VideoReader('20psi-1lpm.mp4');

freq = 1.91;
frames = round(500/freq);
I2=ones(ymax-ymin+1,1);
I3=ones(ymax-ymin+1,3);
for i = 1:4
    I=v.read((i-1)*frames+1000*2);
    I = I(ymin:ymax,xmin:xmax);
    I2=cat(2, I2, I);
    I2=cat(2, I2, I3*255);
end
imshow(I2)
%imwrite(I2,['delta_t=' int2str(1 / freq * 1000) 'ms.jpg'])
%% Figure 1
v = VideoReader('20psi-0.5lpm.mp4');
I2=ones(ymax-ymin+1,1);
I3=ones(ymax-ymin+1,1);

I=v.read((6680-1)*2);
I = I(ymin:ymax,xmin:xmax);
I2=cat(2, I2, I);
I2=cat(2, I2, I3*255);
I4=binarizedArray(:,:,6680);
I2=cat(2, I2, I4*255);

I=v.read((6681-1)*2);
I = I(ymin:ymax,xmin:xmax);
I2=cat(2, I2, I3*255);
I2=cat(2, I2, I);
I2=cat(2, I2, I3*255);
I4=binarizedArray(:,:,6681);
I2=cat(2, I2, I4*255);

RGB=insertShape(I2,'FilledRectangle',[0 600 1140 100; 0 850 1140 50],'Color','red','Opacity',0.3);
RGB=insertShape(RGB,'FilledRectangle',[0 0 1140 2],'Color','green','Opacity',0.8);

imshow(RGB)
imwrite(RGB,'Figure 1.jpg')

%% Image
v = VideoReader('20psi-1lpm.mp4');

vor = VideoWriter('RealTime.avi');
vos = VideoWriter('SlowMo.avi');

vor.FrameRate=25;
vos.FrameRate=25;

open(vor)
open(vos)
%rectangle_pos1=[0 height-round(ub1/dx) 500 round(ub1/dx)-round(lb1/dx)];
%rectangle_pos2=[0 height-round(ub2/dx) 500 round(ub2/dx)-round(lb2/dx)];
%myfig=figure();
for i = 1:20:10000
    frame = v.read(i);
    frame=frame(ymin:ymax,xmin:xmax);
    %frame=insertShape(frame,'FilledRectangle',[rectangle_pos1; rectangle_pos2],'Color','red','Opacity',0.3);
    writeVideo(vor,frame);
end

for i = 2001:2:3000
    frame = v.read(i);
    frame=frame(ymin:ymax,xmin:xmax);
    %frame=insertShape(frame,'FilledRectangle',[rectangle_pos1; rectangle_pos2],'Color','red','Opacity',0.3);
    writeVideo(vos,frame);
end
close(vor)
close(vos)