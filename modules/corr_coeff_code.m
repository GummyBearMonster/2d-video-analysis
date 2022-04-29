%% Bursting Bubbles 59cm-60cm
start_frame=1;
end_frame=25000;
top_avg_intensity=zeros(1,end_frame+1-start_frame);
height= size(binarizedArray,1);
lb_60cm = height-round(600/dx);
ub_59cm = height-round(590/dx);

for i =start_frame:end_frame
    region = binarizedArray(lb_60cm:ub_59cm,:,i);
    top_avg_intensity(1,i-start_frame+1)=mean2(region);
end

plot(top_avg_intensity)
%%
Fs = 250;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 30000;             % Length of signal
t = (0:L-1)*T;        % Time vector
Y=fft(top_avg_intensity);
P2=abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
xlow=0.1;
xhigh=2.5;

A=0;
Aa=0;
step=f(2)-f(1);
for i=round(xlow/step):round(xhigh/step)
    A=A+P1(i+1);
    Aa=Aa+P1(i+1)*(i+1);
end

res_freq=Aa/A*step;

plot(f(2:end),P1(2:end))
hold on
xline(res_freq)

xlim([0.1 20])
ylim([0 0.02])
%xlabel('Frequency (Hz)')
%[m,ind] = max(P1(10:end));
%ind=ind+9;
set(gcf,'units','inches','position',[0,0,2.16,1])
set(gca,'FontSize',10, 'FontName', 'Times New Roman')
saveas(gca,['Bursting Frequency' sprintf('%.2f',res_freq) 'Hz.jpg'])
saveas(gca,['Bursting Frequency ' sprintf('%.2f',res_freq) 'Hz.fig'])
%%
v = VideoReader('20psi-0.5lpm-2+4.mp4');

freq = res_freq;
frames = round(500/freq);
I2=ones(ymax-ymin+1,1);
I3=ones(ymax-ymin+1,3);
for i = 1:4
    I=v.read((i-1)*frames+1000*2);
    I = I(ymin:ymax,xmin:xmax);
    I2=cat(2, I2, I);
    I2=cat(2, I2, I3*255);
end
imwrite(I2,['delta_t=' int2str(1 / freq * 1000) 'ms.jpg'])
%%
freq = res_freq;
nframes = round(250/freq);
corr_coeff=zeros(1,end_frame+1-start_frame);
for i =start_frame:end_frame
    corr_coeff(i-start_frame+1)=corr2(binarizedArray(:,:,i),binarizedArray(:,:,i+nframes));
end
figure
plot(corr_coeff)
save('corr.mat','corr_coeff','freq')
