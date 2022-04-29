%%
plot(ypos(2:end),-diff(yseg_mean(3,:)))
ylim([0 100])
xlabel('Bubble height (mm)')
ylabel('Δ area (mm^2)')

%%
start_frame=1;
end_frame=30000;
top_avg_intensity=zeros(1,end_frame+1-start_frame);
height= size(binarizedArray,1);
lb_3cm = height-round(3/dx);
ub_1cm = height-round(1/dx);

for i =start_frame:end_frame
    region = binarizedArray(lb_3cm:ub_1cm,:,i);
    top_avg_intensity(1,i-start_frame+1)=mean2(region);
end

Fs = 250;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 30000;             % Length of signal
t = (0:L-1)*T;        % Time vector

Y=fft(top_avg_intensity);
P2=abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

xlow=14;
xhigh=15;

res_freq=peakAnalysis(P1,f,xlow,xhigh);

plot(f(2:end),P1(2:end))
hold on
xline(res_freq,'r-')

xlim([0.1 20])
%ylim([0 0.02])
%xlabel('Frequency (Hz)')
%[m,ind] = max(P1(10:end));
%ind=ind+9;
set(gcf,'units','inches','position',[0,0,2.16,1])
set(gca,'FontSize',10, 'FontName', 'Times New Roman')
saveas(gca,['Pinching Frequency ' sprintf('%.2f',res_freq) 'Hz.jpg'])
saveas(gca,['Pinching Frequency ' sprintf('%.2f',res_freq) 'Hz.fig'])
%%



CENTROID_X=2;
CENTROID_Y=3;
COALESCED=12;


lb1=8;
ub=height-round(lb1/dx);

ub1=65;
lb=height-round(ub1/dx);

regular_co1=zeros(1,30000);
for i=1:size(outputArray,3)
        for j=1:100
            if outputArray(j,CENTROID_Y,i)<ub && outputArray(j,CENTROID_Y,i)>lb && outputArray(j,COALESCED,i)==1  
                regular_co1(i) = 1;
            end
        end
end

figure
plot(regular_co1)
hold on

lb2=100;
ub=height-round(lb2/dx);

ub2=200;
lb=height-round(ub2/dx);


regular_co2=zeros(1,30000);
for i=1:size(outputArray,3)
        for j=1:100
            if outputArray(j,CENTROID_Y,i)<ub && outputArray(j,CENTROID_Y,i)>lb && outputArray(j,COALESCED,i)==1  
                regular_co2(i) = 1;
            end
        end
end
plot(regular_co2)
%xlim([6000 7000])
yticks([0 1])
yticklabels({'No','Yes'})
ylabel('Coalescence Occuring')
%xticks(6000:125:7000)
%xticklabels({'0','500','1000','1500','2000','2500','3000','3500','4000'})
xlabel('Time (ms)')
legend('1mm to 54mm','160mm to 231mm')
set(gcf,'units','inches','position',[0,0,4,3])
set(gca,'FontSize',12, 'FontName', 'Times New Roman')
%saveas(gca,'time.jpg')
%saveas(gca,'time.fig')

%%

Fs = 250;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 30000;             % Length of signal
t = (0:L-1)*T;        % Time vector

Y=fft(regular_co1);
P2=abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

xlow=7.2;
xhigh=9;

res_freq1=peakAnalysis(P1,f,xlow,xhigh);
res_freq1_amp=FTPeakInt(P1,f,res_freq1);

figure
plot(f(2:end),P1(2:end))
hold on
xline(res_freq1,'r')
txt = ['Resonant Frequency: ' num2str(res_freq1) 'Hz' newline 'Average Coalesce Time: ' num2str(1/res_freq1) ' s'];
%a = annotation('textbox',[0.4 0.9 0.15 0.04],'String',txt,'FitBoxToText','on');
xlim([0.1 20])
%ylim([0 0.02])
xlabel('Frequency (Hz)')
set(gcf,'units','inches','position',[0,0,4,1.5])
set(gca,'FontSize',12, 'FontName', 'Times New Roman')
saveas(gca,['Coalescing Frequency ' sprintf('%.2f',res_freq1) 'Hz ' int2str(lb1) 'mm to ' int2str(ub1) 'mm.jpg'])
saveas(gca,['Coalescing Frequency ' sprintf('%.2f',res_freq1) 'Hz ' int2str(lb1) 'mm to ' int2str(ub1) 'mm.fig'])

figure
Y=fft(regular_co2);
P2=abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
xlow=2;
xhigh=2.9;

res_freq2=peakAnalysis(P1,f,xlow,xhigh);
res_freq2_amp=FTPeakInt(P1,f,res_freq2);


plot(f(2:end),P1(2:end))
hold on
xline(res_freq2,'r')
txt = ['Resonant Frequency: ' num2str(res_freq2) 'Hz' newline 'Average Coalesce Time: ' num2str(1/res_freq2) ' s'];
%a = annotation('textbox',[0.4 0.9 0.15 0.04],'String',txt,'FitBoxToText','on');
xlim([0.1 20])
%ylim([0 0.02])
xlabel('Frequency (Hz)')
%ylabel('Amplitude')
set(gcf,'units','inches','position',[0,0,4,1.5])
set(gca,'FontSize',12, 'FontName', 'Times New Roman')
saveas(gca,['Coalescing Frequency ' sprintf('%.2f',res_freq2) 'Hz ' int2str(lb2) 'mm to ' int2str(ub2) 'mm.jpg'])
saveas(gca,['Coalescing Frequency ' sprintf('%.2f',res_freq2) 'Hz ' int2str(lb2) 'mm to ' int2str(ub2) 'mm.fig'])


save('regular.mat','ub1','ub2','lb1','lb2','regular_co1','regular_co2','res_freq1','res_freq2','res_freq1_amp','res_freq2_amp')
%%


