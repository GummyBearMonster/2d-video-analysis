files = dir('*.mp4');
for i=1:size(files,1)
    mkdir(files(i,1).name(1:end-4))
    movefile(files(i,1).name, files(i,1).name(1:end-4))
end
%% Binarize individually

filename='4psi_10';
v=VideoReader([filename '.mp4']);
fps=v.FrameRate;
nframes = v.NumFrames;
z=v.read(3);
imshow(z)
%% Crop the image
ymin=8;
ymax=740;
xmin=12;
xmax=208;
I=z(ymin:ymax,xmin:xmax);
imshow(I);
dx=200/(xmax-xmin);
%% Test the parameters for binarization
z=v.read(6);
I=z(ymin:ymax,xmin:xmax);
bg=I;
gaussian_sigma=1.5;
bar=-10;
nblock=121;
hsnk = vision.VideoPlayer('Position',[300 0 2*(xmax-xmin) 2*(ymax-ymin)]);
vo=VideoWriter('binarized.avi','Uncompressed AVI');
vo.open();
for i=200:1200
    o=v.read(i);
    I=o(ymin:ymax,xmin:xmax);
    I2=imgaussfilt(I,gaussian_sigma);
    I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
    I3=bwareaopen(I3,200);
    I3=imcomplement(I3);
    I3=bwareaopen(I3,2000);
    I3=imcomplement(I3);
    I4=cat(2, cast(I3.*255, 'uint8'),I);
    step(hsnk,I4);
    writeVideo(vo,cat(2,double(I3*1),double(I)/255));
    %imshow(I4)
end
release(hsnk);
vo.close()

%% Individual

vfr = vision.VideoFileReader([filename '.mp4'], ...
                                  'ImageColorSpace', 'RGB', ...
                                  'VideoOutputDataType', 'uint8');
binarizedArray=false(ymax-ymin+1,xmax-xmin+1,total_frames);
frameCnt = 1;  
vo=VideoWriter('binarized.avi','Uncompressed AVI');
vo.open();
while ~isDone(vfr)
    % Read frame
    frame1  = step(vfr);
    I=frame1(ymin:ymax,xmin:xmax);
    I2=imgaussfilt(I,gaussian_sigma);
    I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
    I3=bwareaopen(I3,100);
    I3=imcomplement(I3);
    I3=bwareaopen(I3,2000);
    I3=imcomplement(I3);
    
    binarizedArray(:,:,frameCnt)=I3;
    if mod(frameCnt,10)==0 && frameCnt < 2000
        writeVideo(vo,cat(2,double(I3*1),double(I)/255));
    end
    frameCnt=frameCnt+1;
end
vo.close()
save([filename '_co.mat'],'binarizedArray','nblock','bar', ...
'gaussian_sigma','xmax','xmin','ymax','ymin','-v7.3','dx')

%%
folders = dir('*psi*');

parfor j=1:size(folders,1)
    cd(['/mnt/Boyuan/Single Bubble/' folders(j,1).name])
    vfr = vision.VideoFileReader([folders(j,1).name '.mp4'], ...
        'ImageColorSpace', 'RGB', ...
        'VideoOutputDataType', 'uint8');
    binarizedArray=false(ymax-ymin+1,xmax-xmin+1,nframes);
    frameCnt = 1;
    vo=VideoWriter('binarized.avi','Motion JPEG AVI');
    vo.open();
    while ~isDone(vfr)
        % Read frame
        frame1  = step(vfr);
        I=frame1(ymin:ymax,xmin:xmax)-bg;
        I2=imgaussfilt(I,gaussian_sigma);
        I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
        I3=bwareaopen(I3,200);
        I3=imcomplement(I3);
        I3=bwareaopen(I3,2000);
        I3=imcomplement(I3);
        
        binarizedArray(:,:,frameCnt)=I3;
        if mod(frameCnt,10)==0 && frameCnt < 2000
            writeVideo(vo,cat(2,I3*255,I));
        end
        frameCnt=frameCnt+1;
    end
    vo.close()
    parsave([folders(j,1).name '.mat'],binarizedArray,nblock,bar, gaussian_sigma,xmax,xmin,ymax,ymin,dx)
    delete('*.mj2')
    cd ..
end

%%
for i=1:size(folders,1)
    cd(folders(i,1).name)
    load([folders(i,1).name '.mat'])
    fast_process
    cd ..
end
