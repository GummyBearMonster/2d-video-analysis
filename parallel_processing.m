%%
filename='3psi-400ms-60ms-50pc';
v=VideoReader([filename '.mp4']);
fps=v.FrameRate;
z=v.read(30);
imshow(z)
%% Crop the image
ymin=100;
ymax=783;
xmin=35;
xmax=240;
I=z(ymin:ymax,xmin:xmax);
imshow(I);
dx=200/(xmax-xmin);

%%
delete(gcp('nocreate'))
videos = dir('*.mp4');
if size(videos,1) < 6
    parpool(size(videos,1))
else
    parpool(numlabs)
end


gaussian_sigma=2.5;
bar=-15;
nblock=145;
spmd
    v=VideoReader(videos(labindex,1).name);
    for i=1:1000
        o=v.read(i);
        o=o(ymin:ymax,xmin:xmax);
        I=imgaussfilt(o,gaussian_sigma);
        I=logical(cvAdaptiveThreshold(I,nblock,bar));
        I=bwareaopen(I,100);
        I=imcomplement(I);
        I=bwareaopen(I,2000);
        I=imcomplement(I);
        I4(:,:,i)=cat(2, cast(I.*255, 'uint8'),o);
    end
end
clear('o','I');