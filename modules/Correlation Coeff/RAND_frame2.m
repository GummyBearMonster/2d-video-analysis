function [difvec,difvec1] = RAND_frame2(filename,freq,first_ana,final_ana,fps,ii,lim1,lim2,lim3,lim4)
num=final_ana-first_ana+1;
v=VideoReader([filename '.mp4']);
g=read(v,1);
g=g(lim1:lim2,lim3:lim4);
P2=round(1/freq*fps);
difvec=zeros(1,num);
frame=zeros(size(g,1)*size(g,2),num);
for i= first_ana:final_ana
    g=read(v,i);
    g2=g(:,:,1);
    x=g2(lim1:lim2,lim3:lim4);
    frame(:,i-(ii-1)*1000)=x(:);
end

for i=1:size(frame,2)
    g1=frame(:,i);
    difvec(1,i) = entropy(uint8(g1));
end

difvec1=zeros(4,num-P2);
for i=(P2+1):size(frame,2)
    g1=frame(:,i);
    g0=frame(:,i-P2);
    difvec1(1,i-P2)=norm(g1-g0)/norm(g0);
    difvec1(2,i-P2)=(sum((g1-mean(g1)).*(g0-mean(g0))))/(sqrt((sum((g1-mean(g1)).^2))*(sum((g0-mean(g0)).^2))));
    difvec1(3,i-P2)=joint_entropy(g0,g1);
    difvec1(4,i-P2)=mutual_information(g0,g1);
end
end