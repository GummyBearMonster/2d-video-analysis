filename='2.5psi-100ms-35ms-2000';
v=VideoReader([filename '.mp4']);
fps=v.FrameRate;
nframes = v.NumFrames;
z=v.read(3);
imshow(z)
%% Crop the image
ymin=2;
ymax=746;
xmin=10;
xmax=283;
I=z(ymin:ymax,xmin:xmax);
imshow(I);
dx=200/(xmax-xmin);

%% Compute Background

vfr = vision.VideoFileReader([filename '.mp4'], ...
                                  'ImageColorSpace', 'RGB', ...
                                  'VideoOutputDataType', 'uint8');
sframes=3000;                              
% Create background/foreground segmentation object
bgsub = BackgroundSubtractor(sframes,500,false,5);
frameCnt = 1;

while frameCnt<=sframes %~isDone(hsrc)
  % Read frame
  frame1  = step(vfr);
  
  % Compute foreground and background mask
  fgMask = getForegroundMask(bgsub, frame1);
  %imshow(frame)
  frameCnt = frameCnt + 1;
end

bgMask = getBackgroundMask(bgsub);
bg=bgMask(ymin:ymax,xmin:xmax);
release(bgsub);
release(vfr);
clear('bgsub','vfr')
imshow(bg)
save('bg.mat','bg','dx')
%% Test the parameters for binarization
z=v.read(6);
I=z(ymin:ymax,xmin:xmax);
%bg=I;
gaussian_sigma=2.5;
bar=-15;
nblock=161;
hsnk = vision.VideoPlayer('Position',[300 0 2*(xmax-xmin) 2*(ymax-ymin)]);
frame_s = 200;
frame_e = 1500;
for i=frame_s:frame_e
    o=v.read(i);
    o=o(ymin:ymax,xmin:xmax);
    I=o-bg;
    I2=imgaussfilt(I,gaussian_sigma);
    I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
    I3=bwareaopen(I3,100);
    I3=imcomplement(I3);
    I3=bwareaopen(I3,2000);
    I3=imcomplement(I3);
    I4=cat(2, cast(I3.*255, 'uint8'),o);
    step(hsnk,I4);
    %imshow(I4)
end
release(hsnk);

%% Bubbles in a dark background (like in starch suspensions)



vfr = vision.VideoFileReader([filename '.mp4'], ...
                                  'ImageColorSpace', 'RGB', ...
                                  'VideoOutputDataType', 'uint8');
binarizedArray=false(ymax-ymin+1,xmax-xmin+1,nframes/2);
frameCnt = 1;                              
while ~isDone(vfr)
    % Read frame
    frame1  = step(vfr);
     if mod(frameCnt,2)==0
        frame1=frame1(ymin:ymax,xmin:xmax);
        I=frame1-bg;
        I2=imgaussfilt(I,gaussian_sigma);
        I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
        I3=bwareaopen(I3,100);
        I3=imcomplement(I3);
        I3=bwareaopen(I3,2000);
        I3=imcomplement(I3);
        
        binarizedArray(:,:,round(frameCnt/2))=I3;
     end
    frameCnt=frameCnt+1;
end

save([filename '.mat'],'binarizedArray','nblock','bar', ...
'gaussian_sigma','xmax','xmin','ymax','ymin','-v7.3','dx')
%%

gaussian_sigma=2.5;
bar=-10;
nblock=501;
hsnk = vision.VideoPlayer('Position',[300 0 2*(xmax-xmin) 2*(ymax-ymin)]);
for i=1:100
    z=v.read(i);
    
    z=z(ymin:ymax,xmin:xmax);
    %I=z;
    I=abs(bg-z);
    I2=imgaussfilt(I,gaussian_sigma,'FilterSize',101);

    I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
    I3=bwareaopen(I3,400);
    I3=imcomplement(I3);
    I3=bwareaopen(I3,2000);
    I3=imcomplement(I3);
    I4=cat(2, cast(I3.*255, 'uint8'),z);
    
     step(hsnk,I4);
%    imshow(I4)
end

%% Bubbles in a clear background (like silicone oil)
vfr = vision.VideoFileReader([filename '.mp4'], ...
                                  'ImageColorSpace', 'RGB', ...
                                  'VideoOutputDataType', 'uint8');
binarizedArray=false(ymax-ymin+1,xmax-xmin+1,30000);
frameCnt = 1;  
%nblock=0;
%bar=0;
while ~isDone(vfr)
    % Read frame
    frame1  = step(vfr);
    frame1=frame1(ymin:ymax,xmin:xmax);
    
    I=abs(bg-frame1);
    I2=imgaussfilt(I,gaussian_sigma,'FilterSize',101);

    I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
    I3=bwareaopen(I3,400);
    I3=imcomplement(I3);
    I3=bwareaopen(I3,2000);
    I3=imcomplement(I3);
    
    binarizedArray(:,:,frameCnt)=I3;
    
    frameCnt=frameCnt+1;
end

save([filename '.mat'],'binarizedArray','nblock','bar', ...
'gaussian_sigma','xmax','xmin','ymax','ymin','-v7.3','dx')
