%clc;clear all;close all;
i=3;
%load('others_5hz-2mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
%%
i=i+1;
load('others_5hz-4mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
i=i+1;
load('others_5hz-6mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
i=i+1;
load('others_5hz-8mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
i=i+1;
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
%%
i=i+1;
load('others_5hz-10mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
i=i+1;
load('others_5hz-12mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
i=i+1;
load('others_5hz-14mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
i=i+1;
load('others_5hz-16mm-12.5slpm-10cnH-50fps.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
i=i+1;
load('others_fb-12.5slpm.mp4.mat');
difvec=squeeze(mean(difvec1_final,2));
ave_IE(i)=mean(difvec(1,:));
std_IE(i)=std(difvec(1,:));
ave_CC(i)=mean(difvec(2,:));
std_CC(i)=std(difvec(2,:));
ave_JE(i)=mean(difvec(3,:));
std_JE(i)=std(difvec(3,:));
ave_MI(i)=mean(difvec(4,:));
std_MI(i)=std(difvec(4,:));
%%
amplitude=[0.5 1 1.5];


figure
h=errorbar(amplitude,ave_JE,std_JE)
axis square
h.Marker='*'
h.LineStyle='none'
h.MarkerSize=15
h.LineWidth=1.5
xlim([0 2])
ax=gca;
ax.FontSize=14
xlabel('Flowrate (lpm)')
ylabel('Joint Entropy')
saveas(gca,'plot_JE.tiff')

figure
h=errorbar(amplitude,ave_IE,std_IE)
axis square
h.Marker='*'
h.LineStyle='none'
h.MarkerSize=15
h.LineWidth=1.5
xlim([0 2])
ax=gca;
ax.FontSize=14
xlabel('Flowrate (lpm)')
ylabel('Image Error')
saveas(gca,'plot_IE.tiff')

figure
h=errorbar(amplitude,ave_CC,std_CC)
axis square
h.Marker='*'
h.LineStyle='none'
h.MarkerSize=15
h.LineWidth=1.5
xlim([0 2])
ax=gca;
ax.FontSize=14                                                                                                                                                     
xlabel('Flowrate (lpm)')
ylabel('Correlation coefficient')
set(gca,'fontsize',14,'FontWeight','Bold')
saveas(gca,'plot_CC.tiff')

figure
h=errorbar(amplitude,ave_MI,std_MI)
axis square
h.Marker='*'
h.LineStyle='none'
h.MarkerSize=15
h.LineWidth=1.5
xlim([0 2])
ax=gca;
ax.FontSize=14
xlabel('Flowrate (lpm)')
ylabel('Mutual Information')
saveas(gca,'plot_MI.tiff')

close all;