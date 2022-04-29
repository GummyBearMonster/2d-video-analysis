clc;clear all;close all;
freq=7.4;
filename='20psi-1.5lpm';
fps=250;
lim1=44;
lim2=945;
lim3=20;
lim4=303;
for i=1:5
    outputmat1=strcat('entropy_',filename);
    outputmat2=strcat('others_',filename);
    for ii=1:9
        first_ana=1000*(ii-1)+1;
        final_ana=1000*ii;
        [difvec,difvec1] = RAND_frame2(filename,freq,first_ana,final_ana,fps,ii,lim1,lim2,lim3,lim4);
        difvec_final(:,:,ii)=difvec;
        difvec1_final(:,:,ii)=difvec1;
    end
    outputname=strcat(outputmat1,'.mat');
    save(outputname,'difvec_final');
    clear difvec_final;
    outputname2=strcat(outputmat2,'.mat');
    save(outputname2,'difvec1_final');
    clear difvec1_final;
end