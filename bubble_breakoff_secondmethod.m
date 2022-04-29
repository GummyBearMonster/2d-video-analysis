clear all
clc
v=VideoReader('20psi-1+5-1.5lpm-40cm.mp4');
fps=v.FrameRate;
nframes=v.NumberofFrames;
%%  convert frames to images
% for i = 1:50
%     frames = read(v,i);
%     imwrite(frames,['Image' int2str(i), '.jpg']);
%     im(i)=image(frames);
% end
%% cropping, binarizing, and making a v
% The black edges should also be included
z=read(v,36);
imshow(z);
%%
ymin=476;%289;
ymax=595;%389;
xmin=103;%18;
xmax=422;%437;

z=z(ymin:ymax,xmin:xmax);
imshow(z);
 
figure
imhist(z)
[counts,x]=imhist(z);
counts2=counts(floor(256*otsuthresh(counts)):256);
gt=(otsuthresh(counts2)*size(counts2,1)+size(counts,1)-size(counts2,1))/size(counts,1);
minbubarea=10;
%minbubarea=20;

%%
%Determining the bubble pinch off by recognizing the black and white pixel

meanGrayLevel_L = zeros(1,nframes);
meanGrayLevel_R = zeros(1,nframes);
bubble_L = zeros(1,nframes);
bubble_R = zeros(1,nframes);
for i=1:nframes
    grayImage = read(v,i);
    croppedFrame=grayImage(ymin:ymax,xmin:xmax);
    thisIntensity = impixel(croppedFrame, 5, 39); %column row
%     meanGrayLevel_L(i) = mean2(croppedFrame(90:91, 60:67));
%     meanGrayLevel_R(i)= mean2(croppedFrame(90:91, 263:277));
    meanGrayLevel_L(i) = mean2(croppedFrame(55:56, 63:72));
    meanGrayLevel_R(i)= mean2(croppedFrame(55:56, 265:273));
%     if meanGrayLevel_L(i) > 0.5* max(meanGrayLevel_L)
%         bubble_L(i) = 1;
%     else
%         bubble_L(i) = 0;
%     end
%     
%     if meanGrayLevel_R(i) > 0.5* max(meanGrayLevel_R)
%         bubble_R(i) = 1;
%     else
%         bubble_R(i) = 0;
%     end
end

save('meanGrayLevel_L.mat')
save('meanGrayLevel_R.mat')
%%

dt=1/fps;
LeaveTime = 0 :dt: (nframes-1)*dt;
plot(LeaveTime, meanGrayLevel_L(1:nframes))
xlim([0,1])
%ylim([1,200])
hold on
plot(LeaveTime, meanGrayLevel_R(1:nframes))
xlim([0,1])
%hold off
ax = gca;
ax.FontSize = 16; 
xlabel('t (s)')
ylabel('Bubble Breakoff')
lgd = legend('Left Bubble','Right Bubble','FontSize',15);
saveas(gcf, [int2str(0) 's_to_' int2str(1) 's_breakoff.jpg']);
saveas(gcf, [int2str(0) 's_to_' int2str(1) 's_breakoff.fig']);

%% Perform FT calculations

t1 = 0:dt:dt*(size(meanGrayLevel_L,2)-1);
w_AL = fft(meanGrayLevel_L,size(t1,2));
w_AR = fft(meanGrayLevel_R,size(t1,2));
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

%% coarse FT plot 

n_avg = 20;
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
%%
lim1_L=1;
lim2_L=find(FT_AL_avg < 0.05*max(FT_AL_avg),1,'last');
figure
plot(f_AL_avg,FT_AL_avg)
xlabel('Frequency (Hz)')
ylabel('Fourier Transformed of Bubble Breakoff (Left Port)')
axis square
%res_freq_AL_avg = peakAnalysis(FT_AL_avg,f_AL_avg,xlowl_avg,xhighl_avg);
idxL = max(FT_AL_avg(:));
res_freq_AL_avg1 = f_AL_avg(FT_AL_avg==idxL);
res_freq_AL_avg2 = sum(f_AL_avg(lim1_L:lim2_L).*FT_AL_avg(lim1_L:lim2_L))/sum(FT_AL_avg(lim1_L:lim2_L));
AvgTimeBreak_L_avg = 1/res_freq_AL_avg1;
ax = gca;
ax.FontSize = 16; 
txt = ['Resonant Frequency: ' num2str(res_freq_AL_avg1) ' Hz' newline 'Average Break Time: ' num2str(AvgTimeBreak_L_avg) ' s'];
%dim  = [1 1 0.5 0.5];
a = annotation('textbox','String',txt,'FitBoxToText','on');
a.FontSize = 15;
xline(res_freq_AL_avg1,'r');
saveas(gcf, 'FTbb_Left_avg.jpg');
saveas(gcf, 'FTbb_Left_avg.fig');
%%
lim1_R=1;
lim2_R=find(FT_AR_avg < 0.05*max(FT_AR_avg),1,'first');
figure
plot(f_AR_avg,FT_AR_avg)
xlabel('Frequency (Hz)')
ylabel('Fourier Transformed of Bubble Breakoff (Right Port)')
%ylim([0 1.5*10^4])
axis square
%res_freq_AR_avg = peakAnalysis(FT_AR_avg,f_AR_avg,xlowR_avg,xhighR_avg);
idxR = max(FT_AR_avg(:));
res_freq_AR_avg1 = f_AR_avg(FT_AR_avg==idxR);
res_freq_AR_avg2 = sum(f_AR_avg(lim1_R:lim2_R).*FT_AR_avg(lim1_R:lim2_R))/sum(FT_AR_avg(lim1_R:lim2_R));
AvgTimeBreak_R_avg = 1/res_freq_AR_avg1;
ax = gca;
ax.FontSize = 16; 
txt = ['Resonant Frequency: ' num2str(res_freq_AR_avg1) ' Hz' newline 'Average Break Time: ' num2str(AvgTimeBreak_R_avg) ' s'];
%dim  = [1 1 0.5 0.5];
a = annotation('textbox','String',txt,'FitBoxToText','on');
a.FontSize = 15;
xline(res_freq_AR_avg1,'r');
saveas(gcf, 'FTbb_Right_avg.jpg');
saveas(gcf, 'FTbb_Right_avg.fig');
%% cross correlation

figure
[c,lags]=xcorr(meanGrayLevel_L,meanGrayLevel_R);
[~,index]=max(abs(c));
res_freq=(res_freq_AL_avg2+res_freq_AR_avg2)/2;
plot(lags*dt*res_freq, c)
hold on
xlim([-2 2])
ax = gca;
ax.FontSize = 16;
xlabel('Time Lag (Normalized)')
ylabel('Cross Correlation')
% 
xmin = 0;
xmax = 0.5;
ind_min = find(lags*dt*res_freq==0);
ymin = c(ind_min);
ymax = interp1(lags*dt*res_freq,c,0.5);
plot(xmin,ymin,'r*')
plot(xmax,ymax,'r*')

saveas(gcf, 'bb_crosscorrelation.jpg');
saveas(gcf, 'bb_crosscorrelation.fig');
