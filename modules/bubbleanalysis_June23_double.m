v=VideoReader('20psi-0.5lpm.mp4');
fps=v.FrameRate;
nframes=v.NumberofFrames;
%% cropping, binarizing, and making a v
% The black edges should also be included

z=read(v,200);
imshow(z);
ymin=10;
ymax=352;
xmin=49;
xmax=800;
z=z(ymin:ymax,xmin:xmax);
imshow(z);
figure
imhist(z)
    [counts,x]=imhist(z);
    gt=floor(256*otsuthresh(counts));
    counts2=counts(gt:256);
    counts1=counts(1:gt);
    gt2=(otsuthresh(counts2)*size(counts2,1)+size(counts,1)-size(counts2,1))/size(counts,1);
    gt1=(otsuthresh(counts1)*size(counts1,1))/size(counts,1);
%% Binarization
m=200; %Number black block removed from the edge from the last iteration, 
     %bigger m = less blackedge removed = faster code 
     %0 means all black edges are reduced to 1 pixel (10 minute binarization)
     %at 200, no visible difference for most frames
cycles=5;
bar=-5; %Local adaptive binarization threshold
        %0 means threshold is at Gaussian of the neighbourhood (more scientific)
        %0 works for 99% of the frames but -3 to -5 makes things safer

for h=200:300
    g=read(v,h);
    g=g(ymin-1:ymax+1,xmin-1:xmax+1); % +1 is needed here to enable search
        [counts,x]=imhist(z);
    gt=floor(256*otsuthresh(counts));
    counts2=counts(gt:256);
    gt2=(otsuthresh(counts2)*size(counts2,1)+size(counts,1)-size(counts2,1))/size(counts,1);
    I = imbinarize(g,0.55); % Global Otsu to identify white bubble areas
    I2=logical(cvAdaptiveThreshold(g,37,bar));
    
    x=1;
    I1=I;

    while x>0 % Filling all blocks within the boundaries of bubbles 
        [x,output]=combine(I1,I2);
        I1=output;
        
    end
    
    y=m+1;
    input=I2;
    I3=I1;
    n=0;
    
    while y>m && n<cycles  % Erode all boundaries to 1 pixel
        y=0;
        
        for i=2:size(input,1)-1 % Search through all black blocks
            for j=2:size(input,2)-1
                if I3(i,j)==0 && (~isEdge(input,i,j) && ~isEdge(I1,i,j)) && (I3(i-1,j)==1||I3(i,j-1)==1||I3(i+1,j)==1||I3(i,j+1)==1)
                    %if the black block is not an edge block (see isEdge)
                    %and if it neigbours a white block, change it to white
                    input(i,j)=1;
                    I1(i,j)=1;
                    y=y+1;
                end
            end
        end
        I3=I1;

    end
    %since the searching method requires one extra block on each side,
    %the intended frame is obtained via cropping.
   I1=I1(2:size(g,1)-1,2:size(g,2)-1);
   I2=I2(2:size(g,1)-1,2:size(g,2)-1);
    I=I(2:size(g,1)-1,2:size(g,2)-1);
   g=g(2:size(g,1)-1,2:size(g,2)-1);
    
   
      %imshowpair(I1,I2,'montage')
      %figure
    imshowpair(I1,g,'montage')
    binarizedArray(:,:,h) = I1;
     %imwrite(g,['origImage' int2str(h), '.jpg']);
    
end
%%
save binarizedArray.mat;
%% 
% load_bwarray= load('binarizedArray.mat');
% binarizedArray = load_bwarray.binarizedArray;
%% Separating left center right
lCentroids=zeros(2,nframes);
lAreas=zeros(1,nframes);
rCentroids=zeros(2,nframes);
rAreas=zeros(1,nframes);
lExtremes=zeros(1,nframes);
rExtremes=zeros(1,nframes);
imshow(binarizedArray(:,:,100));
%%
% Use Data tip to determine the x value that separates left from center
% from right
separate=71;
s1=25;
s2=100;
for i=1:nframes
    I=binarizedArray(:,:,i);
    L=bwconncomp(I,4);
    s=regionprops(L,'Centroid','Area','Extrema');
    centroids= cat(1,s.Centroid);
    areas=cat(1,s.Area);
    ext=cat(2,s.Extrema);
%     ext = s.Extrema;
%     bottomright = ext(5,:);
    
    kl=0;%bottom pixel
    kr=0;%bottom pixel
    kkr=1;
    kkl=1;
     for k=1:size(ext(5,:),2)/2
         if(ext(6,2*k-1)>separate && ext(5,2*k-1)<s2) %x of the bottom-right ext larger than sep (right bubble)
            
            if(ext(5,2*k)>kr) % if the bottom-right corner is more than y = 0
                kr=ext(5,2*k); % kr is the y coordinate of the right leaving bubble
                kkr=k;
            end
         end
         if(ext(5,2*k-1)<separate && ext(6,2*k-1)>s1) % left bubble
             
            if(ext(5,2*k)>kl)
                kl=ext(5,2*k); % kl is the y coordinate of the left leaving bubble
                kkl=k;

            end
         end
         
     end
     
     lAreas(1,i)=areas(kkl,1);
     lCentroids(1:2,i)=centroids(kkl,1:2);
     
     rAreas(1,i)=areas(kkr,1);
     rCentroids(1:2,i)=centroids(kkr,1:2);
     
     lExtremes(1,i)=kl; % y of left bubble
     rExtremes(1,i)=kr; % y of right bubble
     
end     
%%
% for i=1:nframes
%     figure
%     imshow(binarizedArray(:,:,i))
%     hold on
%     plot(rCentroids(1,i),rCentroids(2,i),'r*')
%     hold on
%     plot(lCentroids(1,i),lCentroids(2,i),'m*')
%     hold off
% end
%% Set dimensions
z=read(v,200);
imshow(z);
x2=923;
x1=8;
dx=400/(x2-x1);%860/size(g,1); %mm/pixel
dy=dx;
dt=1/fps;
%% 
leaveCentroidsR=zeros(2,nframes);
leaveCentroidsL=zeros(2,nframes);
leaveAreaL=zeros(1,nframes);
leaveAreaR=zeros(1,nframes);
pix=0;
%dif=ymax-ymin+1-pix; 
dif=ymax-ymin;
for i=1:nframes
    if lExtremes(1,i)>dif % 
        leaveAreaL(1,i)=lAreas(1,i);
        leaveCentroidsL(1:2,i)=lCentroids(1:2,i);
    end
    if rExtremes(1,i)>dif
        leaveAreaR(1,i)=rAreas(1,i);
        leaveCentroidsR(1:2,i)=rCentroids(1:2,i);
    end
end

%%
% for i=1:100
%     figure
%     imshow(binarizedArray(:,:,i))
%     hold on
%     plot(leaveCentroidsR(1,i),leaveCentroidsR(2,i),'r*')
%     hold on
%     plot(leaveCentroidsL(1,i),leaveCentroidsL(2,i),'m*')
%     hold off
% end
%% Plot Area vs Time
LeaveTime = 0 :dt: (nframes-1)*dt;
plot(LeaveTime, leaveAreaL(1:nframes)*dx*dy)
xlim([0,1])
%ylim([1,200])
hold on
plot(LeaveTime, leaveAreaR(1:nframes)*dx*dy)
xlim([0,1])
%hold off
ax = gca;
ax.FontSize = 16; 
xlabel('t (s)')
ylabel('Area (mm2)')
lgd = legend('Left Bubble','Right Bubble','FontSize',15);
saveas(gcf, [int2str(0) 's_to_' int2str(1) 's_1frames.jpg']);
saveas(gcf, [int2str(0) 's_to_' int2str(1) 's_1frames.fig']);
for i=1:4
LeaveTime = 0 :dt: (nframes-1)*dt;
plot(LeaveTime, leaveAreaL(1:nframes)*dx*dy)
xlim([5*i-1,5*i])
%ylim([1,200])
hold on
plot(LeaveTime, leaveAreaR(1:nframes)*dx*dy)
xlim([5*i-1,5*i])
%ylim([1,200])
ax = gca;
ax.FontSize = 16; 
hold off
xlabel('t (s)')
ylabel('Area (mm2)')
lgd2 = legend('Left Bubble','Right Bubble','FontSize',15);
saveas(gcf, [int2str(5*i-1) 's_to_' int2str(5*i) 's_1frames.jpg']);
saveas(gcf, [int2str(5*i-1) 's_to_' int2str(5*i) 's_1frames.fig']);
end
%% Perform FT calculations

leaveAreaL_cut = leaveAreaL(1:nframes)*dx*dy;
leaveAreaR_cut = leaveAreaR(1:nframes)*dx*dy;
t1 = 0:dt:dt*(size(leaveAreaL_cut,2)-1);
w_AL = fft(leaveAreaL_cut,size(t1,2));
w_AR = fft(leaveAreaR_cut,size(t1,2));
Pyy_AL = w_AL.*conj(w_AL)/size(t1,2);
Pyy_AR = w_AR.*conj(w_AR)/size(t1,2);
Pyy_AL(1) = 0;
Pyy_AL(2) = 0;
Pyy_AR(1) = 0;
Pyy_AR(2) = 0;
f_AL = 1/(dt)/size(t1,2)*(0:round(size(t1,2)/2));
f_AR = 1/(dt)/size(t1,2)*(0:round(size(t1,2)/2));
FT_AL = Pyy_AL(1:size(f_AL,2));
FT_AR = Pyy_AR(1:size(f_AR,2));

%% coarsening FT plot 

n_avg = 15; %so far this value has worked the best
FT_AL_avg = zeros(1,floor(((nframes/2)+1)/n_avg));
FT_AR_avg = zeros(1,floor(((nframes/2)+1)/n_avg));
f_AL_avg = zeros(1,floor(((nframes/2)+1)/n_avg));
f_AR_avg = zeros(1,floor(((nframes/2)+1)/n_avg));

for i = 1:floor(((nframes/2)+1)/n_avg)
    for j = 1:n_avg
        FT_AL_avg(i) = FT_AL_avg(i)+FT_AL((i-1)*n_avg+j)/n_avg;
        FT_AR_avg(i) = FT_AR_avg(i)+FT_AR((i-1)*n_avg+j)/n_avg;
        f_AL_avg(i) = f_AL_avg(i)+f_AL((i-1)*n_avg+j)/n_avg;
        f_AR_avg(i) = f_AR_avg(i)+f_AR((i-1)*n_avg+j)/n_avg;
    end
end

%% Weighted average FT vs freq for Left Bubble

lim1_L=1; %
lim2_L=100; %this limit is chosen where we mainly have noise
figure
plot(f_AL_avg,FT_AL_avg)
xlabel('Frequency (Hz)')
ylabel('Fourier Transformed of Bubble Area (Left Port)')
%ylim([0 1.5*10^4])
axis square
%res_freq_AL_avg = peakAnalysis(FT_AL_avg,f_AL_avg,xlowl_avg,xhighl_avg);
idxL = max(FT_AL_avg(:));
%res_freq_AL_avg1 = f_AL_avg(FT_AL_avg==idxL);
res_freq_AL_avg2 = sum(f_AL_avg(lim1_L:lim2_L).*FT_AL_avg(lim1_L:lim2_L))/sum(FT_AL_avg(lim1_L:lim2_L));
AvgTimeBreak_L_avg = 1/res_freq_AL_avg2;
ax = gca;
ax.FontSize = 16; 
txt = ['Resonant Frequency: ' num2str(res_freq_AL_avg2) ' Hz' newline 'Average Break Time: ' num2str(AvgTimeBreak_L_avg) ' s'];
a = annotation('textbox','String',txt,'FitBoxToText','on');
a.FontSize = 15;
xline(res_freq_AL_avg2,'r');
saveas(gcf, 'FT_Left_avg.jpg');
saveas(gcf, 'FT_Left_avg.fig');
%%  Weighted average FT vs freq for Right Bubble

lim1_R=1;
lim2_R=100;
figure
plot(f_AR_avg,FT_AR_avg)
xlabel('Frequency (Hz)')
ylabel('Fourier Transformed of Bubble Area (Right Port)')
%ylim([0 1.5*10^4])
axis square
%res_freq_AR_avg = peakAnalysis(FT_AR_avg,f_AR_avg,xlowR_avg,xhighR_avg);
idxR = max(FT_AR_avg(:));
%res_freq_AR_avg1 = f_AR_avg(FT_AR_avg==idxR);
res_freq_AR_avg2 = sum(f_AR_avg(lim1_R:lim2_R).*FT_AR_avg(lim1_R:lim2_R))/sum(FT_AR_avg(lim1_R:lim2_R));
AvgTimeBreak_R_avg = 1/res_freq_AR_avg2;
ax = gca;
ax.FontSize = 16; 
txt = ['Resonant Frequency: ' num2str(res_freq_AR_avg2) ' Hz' newline 'Average Break Time: ' num2str(AvgTimeBreak_R_avg) ' s'];
a = annotation('textbox','String',txt,'FitBoxToText','on');
a.FontSize = 15;
xline(res_freq_AR_avg2,'r');
saveas(gcf, 'FT_Right_avg.jpg');
saveas(gcf, 'FT_Right_avg.fig');

 %% Generate FT plot for the left port
% %xlowl xhighl set the start and end of averaging a peak for the left port
% figure
% plot(f_AL,FT_AL)
% 
% %%
% xlowl=24.55;
% xhighl=24.55;
% 
% figure
% plot(f_AL,FT_AL)
% xlabel('Frequency (Hz)')
% ylabel('Fourier Transformed of Bubble Area (Left Port)')
% %ylim([0 1.5*10^4])
% axis square
% res_freq_AL = peakAnalysis(FT_AL,f_AL,xlowl,xhighl);
% AvgTimeBreak_L = 1/res_freq_AL;
% ax = gca;
% ax.FontSize = 16; 
% txt = ['Resonant Frequency: ' num2str(res_freq_AL) ' Hz' newline 'Average Break Time: ' num2str(AvgTimeBreak_L) ' s'];
% %dim  = [1 1 0.5 0.5];
% a = annotation('textbox','String',txt,'FitBoxToText','on');
% a.FontSize = 15;
% xline(res_freq_AL,'r');
% saveas(gcf, 'FT_Left.jpg');
% saveas(gcf, 'FT_Left.fig');
% 
% %% Generate the FT plot of right port
% %xlowR xhighR set the start and end of averaging a peak for the right port
% figure 
% plot(f_AR,FT_AR)
% %%
% xlowR=16.25;%29.2
% xhighR=16.25;
% 
% figure 
% plot(f_AR,FT_AR)
% xlabel('Frequency (Hz)')
% ylabel('Fourier Transformed Bubble Area (Right Port)')
% %xlim([0 10])
% %ylim([0 1.5*10^4])
% axis square
% res_freq_AR = peakAnalysis(FT_AR,f_AR,xlowR,xhighR);
% AvgTimeBreak_R = 1/res_freq_AR;
% ax = gca;
% ax.FontSize = 16; 
% txt = ['Resonant Frequency: ' num2str(res_freq_AR) ' Hz' newline 'Average Break Time: ' num2str(AvgTimeBreak_R) ' s'];
% %dim  = [1 1 0.5 0.5];
% a = annotation('textbox','String',txt,'FitBoxToText','on');
% a.FontSize = 15;
% xline(res_freq_AR,'r');
% saveas(gcf, 'FT_Right.jpg');
% saveas(gcf, 'FT_Right.fig');

%% Cross Correlation Based on averaged freq
figure
[c,lags]=xcorr(leaveAreaL_cut,leaveAreaR_cut);
[~,index]=max(abs(c));
res_freq=(res_freq_AL_avg2+res_freq_AR_avg2)/2;
plot(lags*dt*res_freq, c)
% hold on
xlim([-2 2])
ax = gca;
ax.FontSize = 16;
xlabel('Time Lag (Normalized)')
ylabel('Cross Correlation')
% x_1_min = 0;
% idx_min_1 = find(lags*dt*res_freq == 0);
% y_1_min = c(idx_min_1);
% x_1_max = 0.5;
% y_1_max = interp1(lags*dt*res_freq,c,0.5);
% plot(x_1_min,y_1_min,'r*')
% hold on
% plot(x_1_max,y_1_max,'r*')
% hold on
saveas(gcf, 'crosscorrelation_avg15.jpg');
saveas(gcf, 'crosscorrelation_avg15.fig');
