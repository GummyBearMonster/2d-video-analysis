folders = dir('MB*');
%%
for i=1:size(folders,1)
    cd(folders(i,1).name)
    gunzip(dir('*.gz').name)
    cd ..
end
%%

V = niftiread(dir('1.3*.nii').name);
info1 = niftiinfo(dir('1.3*.nii').name);
imshow(double(V(:,:,6,1))./512)
%%
ymin = 20;
ymax = 44;
xmin = 1;
xmax = 36;
global_thresh = 0.88;
gaussian_sigma = 5;

ker = [23,23,9];


I = 1- double(V(ymin:ymax,xmin:xmax,:,1))./512;
I = imresize3(I,2,'method','linear');
I2 = imgaussfilt3(I,gaussian_sigma,'FilterSize',ker,'FilterDomain','Spatial');
I2 = imbinarize(I2,global_thresh);
I3 = int16(round(I2.* 512));
I3 = imgaussfilt3(I3,1.5,'FilterSize',ker,'FilterDomain','Spatial');

imshow(double(I3(:,:,12))/512)
%%

niftiwrite(I3,'info.nii')
info = niftiinfo(dir('info.nii').name);
info.ImageSize = size(I);
info.PixelDimensions = info1.PixelDimensions(1:3)./2;
info.SpaceUnits = info1.SpaceUnits;
info.SpatialDimension = info1.SpatialDimension;
%%
mkdir frames
cd frames
for i = 1:500
I = 1- double(V(ymin:ymax,xmin:xmax,:,i))./512;
I = imresize3(I,2,'method','linear');
I2 = imgaussfilt3(I,gaussian_sigma,'FilterSize',ker,'FilterDomain','Spatial');
I2 = imbinarize(I2,global_thresh);
I3 = int16(round(I2.* 512));
I3 = imgaussfilt3(I3,1.5,'FilterSize',ker,'FilterDomain','Spatial');
niftiwrite(I3,[int2str(i) '.nii'],info)
end
%%

slice1=slice(:,10:32,:);
%slice1(:,:,2)=slice(:,13:35,2);
slice2=imadjustn(slice1);
slice2 = imresize3(slice2,[size(slice2,1), size(slice2,2), size(slice2,3)]);
%slice2 = medfilt3(slice2,[5, 5, 5],'zeros');
%imshowpair(slice(:,:,2),fliplr(slice(:,:,2)))
%slice2=0.5*slice+0.5*fliplr(slice);
imshowpair(slice2(:,:,2),slice2(:,:,3),'montage')
%% save slices to dicom and jpg
slice_dist=info1.SpacingBetweenSlices; % set the distance between the center of slices
dx=info1.PixelSpacing(1);
for i = 1:6
strt=info1;
strt.ImagePositionPatient=info1.ImagePositionPatient;
strt.ImagePositionPatient(3)=i*slice_dist; 
dicomwrite(slice(:,:,i),['slice' int2str(i) '.dcm'],strt)
imwrite(slice(:,:,i),['slice' int2str(i) '.jpg'])
%disp(dicominfo(['slice' int2str(i) '.dcm']).ImagePositionPatient(3))
end
%%