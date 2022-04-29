files = dir('*.mp4');
for i=1:size(files,1)
    mkdir(files(i,1).name(1:end-4))
    movefile(files(i,1).name, files(i,1).name(1:end-4))
end
%% Binarize individually

filename='2.5psi_400-15';
v=VideoReader([filename '.mp4']);
fps=v.FrameRate;
total_frames = v.Duration*fps;
z=v.read(3);
imshow(z)
%% Crop the image
ymin=10;
ymax=720;
xmin=35;
xmax=210;
I=z(ymin:ymax,xmin:xmax);
imshow(I);
dx=200/(xmax-xmin);
%% Test the parameters for binarization

gaussian_sigma=2.5;
bar=-2;
nblock=241;
hsnk = vision.VideoPlayer('Position',[300 0 2*(xmax-xmin) 2*(ymax-ymin)]);
vo=VideoWriter('binarized.avi','Uncompressed AVI');
vo.open();
for i=2000:1:2200
    o=v.read(i);
    I=o(ymin:ymax,xmin:xmax);
    I2=imgaussfilt(I,gaussian_sigma);
    I3=logical(cvAdaptiveThreshold(I2,nblock,bar));
    I3=bwareaopen(I3,100);
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
    cd(['/mnt/Boyuan/2D_45p_5min/' folders(j,1).name])
    vfr = vision.VideoFileReader([folders(j,1).name '.mp4'], ...
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
    parsave([folders(j,1).name '.mat'],binarizedArray,nblock,bar, gaussian_sigma,xmax,xmin,ymax,ymin,dx)
    cd ..
end

%%
for i=1:size(folders,1)
    cd(folders(i,1).name)
    load([folders(i,1).name '.mat'])
    fast_process
    cd ..
end
