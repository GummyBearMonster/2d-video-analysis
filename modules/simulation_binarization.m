for i = 1:size(epg,1)
    times(:,:,i) = flipud(reshape(epg(i,:,:),size(epg,2),size(epg,3)));
end
%%
z = times(:,:,100);
imshow(z)
ymin=90;
ymax=250;
xmin=1;
xmax=100;
I=z(ymin:ymax,xmin:xmax);
imshow(I);
dx=200/(xmax-xmin);
%% Test the parameters for binarization
hsnk = vision.VideoPlayer('Position',[300 0 2*(xmax-xmin) 2*(ymax-ymin)]);
startTime =1000;
thresh=0.5;
for i=startTime:size(epg,1)
    o=times(:,:,i);
    o=o(ymin:ymax,xmin:xmax);
    I3=imbinarize(o,0.5);
    I4=cat(2, I3,o);
    step(hsnk,I4);
    binarizedArray(:,:,i-startTime+1) = I3;
end
release(hsnk);
save('binarized.mat','binarizedArray','thresh', ...
'xmax','xmin','ymax','ymin','-v7.3','dx')

%%
