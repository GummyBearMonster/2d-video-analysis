clc;clear all;close all;
i=1;
load('entropy_2hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_3hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_3.5hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_4hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_4.5hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_5hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_5.5hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_6hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_6.5hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_7hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_8hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));




i=i+1;
load('entropy_9hz-9mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));


i=i+1;
load('entropy_fb-12.5slpm.mp4.mat');
difvec=squeeze(mean(difvec_final,2));
ave_rand(i)=mean(difvec(1,:));
std_rand(i)=std(difvec(1,:));


frequency=[2,3,3.5,4,4.5,5,5.5,6,6.5,7,8,9,0];

figure
h=errorbar(frequency,ave_rand,std_rand)
axis square
h.Marker='*'
h.LineStyle='none'
h.MarkerSize=15
h.LineWidth=1.5
xlim([0 10])
ax=gca;
ax.FontSize=14
xlabel('Frequency (Hz)')
ylabel('Entropy')
saveas(gca,'plot_Entropy.tiff')

close all;