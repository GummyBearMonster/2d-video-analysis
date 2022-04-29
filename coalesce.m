%%
AREA_C=1;
VY_C=2;
WIDTH_C=3;
Y_C=4;
AY_C=5;
ID_C=6;
%%
ypos=ymap2;
ypos2=[ypos,fliplr(ypos)];
dc=zeros(7,0);
uc=zeros(7,0);
for i = 1:30001
    for j=1:100
        if downArray(j,1,i)>0
            dc=cat(2,dc,[downArray(j,:,i) i].');
            uc=cat(2,uc,[upArray(j,:,i) i].');
        end
    end
end

reg1_up=zeros(7,0);
reg1_down=zeros(7,0);
reg2_up=zeros(7,0);
reg2_down=zeros(7,0);
for i =1:size(uc,2)
    if dc(4,i)>525 && dc(4,i)<695
        reg2_down = cat(2, reg2_down, dc(:,i));
    elseif dc(4,i)>825 && dc(4,i)<900
        reg1_down = cat(2, reg1_down, dc(:,i));
    end
    if uc(4,i)>525 && uc(4,i)<695
        reg2_up = cat(2, reg2_up, uc(:,i));
    elseif uc(4,i)>825 && uc(4,i)<900
        reg1_up = cat(2, reg1_up, uc(:,i));
    end
    
end

%%
%loglog(b(1,:),b(2,:),'*')
%hold on
dshear=0.001;
shear=0:0.001:400;
vis=interp1(b(1,:),b(2,:),shear,'spline');
semilogx(x,avg_vis,'k')
hold on


for i =1:size(uc,2)
    if uc(2,i)/uc(3,i)>0
        if   (uc(4,i)>525 && uc(4,i)<695)
            semilogx(uc(2,i)/uc(3,i)*fps,avg_vis(round(uc(2,i)/uc(3,i)*fps/0.001+1)),'b*')
            hold on
            %loglog(dc(5,i)*fps,vis(round(dc(5,i)*fps/0.001+1)),'r*')
            %hold on
        elseif (uc(4,i)>825 && uc(4,i)<900)
            semilogx(uc(2,i)/uc(3,i)*fps,avg_vis(round(uc(2,i)/uc(3,i)*fps/0.001+1)),'b*')
            hold on
        else
            semilogx(uc(2,i)/uc(3,i)*fps,avg_vis(round(uc(2,i)/uc(3,i)*fps/0.001+1)),'g^')
            hold on
        end
    end
end
h = zeros(3, 1);
h(1) = plot(-1,-1,'k-');
h(2) = plot(-1,-1,'b*');
h(3) = plot(-1,-1,'g^');
xlim([1e-1 1e2])
ylim([1e-1 5e-1])
legend(h, '$\eta$ vs $\dot{\gamma}$','Region 1, 2','Elsewhere','interpreter','latex','Location','northwest');
ylabel('Effective viscosity $\eta$ (Pa$\cdot$s)','interpreter','latex')
xlabel('Bubble shear rate $\dot{\gamma}$ ($s^{-1}$)','interpreter','latex')

set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'region2_shear_viscosity.fig')
saveas(gca,'region2_shear_viscosity.jpg')
%%
figure
widthmap3=[widthmap2,fliplr(widthmap2)];
plot(uc(3,:)*dx,uc(2,:)*dx*fps,'b*')
hold on
plot(dc(3,:)*dx,dc(2,:)*dx*fps,'r*')
hold on
plot(widthmap2,widthseg_mean(1,:),'b')
hold on
reg=[widthseg_mean(1,:)+widthseg_std(1,:),fliplr(widthseg_mean(1,:)-widthseg_std(1,:))];
h=fill(widthmap3,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
hold on
set(h,'facealpha',0.1)
xlim([3 85])
ylim([0 900])
legend('Upper Bubble','Lower Bubble','Mean v_y','Mean v_y ± SD','Location','northeast')
%ylim([0 max(yseg_mean(3,:)+yseg_std(3,:))])
ylabel('Bubble rise velocity (mm/s)')
xlabel('Bubble width (mm)')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'ul_vy_width.fig')
saveas(gca,'ul_vy_width.jpg')

%%
ypos=ymap2;
ypos2=[ypos,fliplr(ypos)];
figure
plot((height-uc(4,:))*dx,uc(5,:)*dx*fps*fps,'b*')
hold on
plot((height-dc(4,:))*dx,dc(5,:)*dx*fps*fps,'r*')
hold on
plot(ypos,yseg_mean(5,:),'b')
hold on
reg=[yseg_mean(5,:)+yseg_std(5,:),fliplr(yseg_mean(5,:)-yseg_std(5,:))];
h=fill(ypos2,reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)
xlim([0 height*dx])
ylim([-1e5 1e5])
legend('Upper Bubble','Lower Bubble','Mean a_y','Mean a_y ± SD')
ylabel('Bubble vertical acceleration (mm/s^2)')
xlabel('Bubble vertical position (mm)')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'avg_a_y.fig')
saveas(gca,'avg_a_y.jpg')

%%


widths=[mean(reg1_down(3,:))*dx  mean(reg1_up(3,:))*dx; mean(reg2_down(3,:))*dx mean(reg2_up(3,:))*dx];
widths_err=[std(reg1_down(3,:)*dx)  std(reg1_up(3,:)*dx); std(reg2_down(3,:)*dx) std(reg2_up(3,:)*dx)];
n = [1 2];
bar(n,widths)
hold on
ylim([0 55])

[ngroups, nbars] = size(vys);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, widths(:,i), widths_err(:,i), 'k', 'linestyle', 'none');
end
hold off
set(gca, 'XTickLabel', ["Region 1" "Region 2"])
legend('Trailing Bubble','Leading Bubble','Location','northwest')
ylabel('Bubble width (mm)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg12_width.fig')
saveas(gca,'reg12_width.jpg')
%%
vys=[mean(reg1_down(2,:))*dx*fps mean(reg2_down(2,:))*dx*fps; mean(reg1_up(2,:))*dx*fps mean(reg2_up(2,:))*dx*fps];
vy_err=[std(reg1_down(2,:)*dx*fps) std(reg2_down(2,:)*dx*fps); std(reg1_up(2,:)*dx*fps) std(reg2_up(2,:)*dx*fps)];
n = [1 2];
bar(n,vys)
hold on

[ngroups, nbars] = size(vys);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, vys(:,i), vy_err(:,i), 'k', 'linestyle', 'none');
end
hold off
set(gca, 'XTickLabel', ["Region 1" "Region 2"])
legend('Trailing Bubble','Leading Bubble','Location','northeast')
ylabel('Average bubble rise velocity (mm/s)')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'reg12_vy.fig')
saveas(gca,'reg12_vy.jpg')
%%
ays=[mean(reg1_down(5,:))*dx*fps*fps mean(reg2_down(5,:))*dx*fps*fps; mean(reg1_up(5,:))*dx*fps*fps mean(reg2_up(5,:))*dx*fps*fps];
ay_err=[std(reg1_down(5,:)*dx*fps*fps) std(reg2_down(5,:)*dx*fps*fps); std(reg1_up(5,:)*dx*fps*fps) std(reg2_up(5,:)*dx*fps*fps)];
n = [1 2];
bar(n,ays)
hold on
[ngroups, nbars] = size(vys);
% Calculate the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, ays(:,i), ay_err(:,i), 'k', 'linestyle', 'none');
end
hold off
set(gca, 'XTickLabel', ["Region 1" "Region 2"])
legend('Trailing Bubble','Leading Bubble','Location','northeast')
ylabel('Bubble vertical acceleration (mm/s^2)')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'reg12_ay.fig')
saveas(gca,'reg12_ay.jpg')

%%
cnt1=0;
cnt2=0;
cnt3=0;
cnt4=0;
for i = 1:size(reg1_down,2)
    for j =1:15
        frm = reg1_down(7,i);
        x=outputArray(:,ID,frm-j);
        ind = find(x==reg1_down(6,i));
        if size(ind,1)==1
            reg1_down_series(i,:,j)=outputArray(ind,:,frm-j);
        else
            reg1_down_series(i,:,j)=nan;
            cnt1=cnt1+1;
        end
    end
end

for i = 1:size(reg2_down,2)
    for j =1:15
        frm = reg2_down(7,i);
        x=outputArray(:,ID,frm-j);
        ind = find(x==reg2_down(6,i));
        if size(ind,1)==1
            reg2_down_series(i,:,j)=outputArray(ind,:,frm-j);
        else
            reg2_down_series(i,:,j)=nan;
            cnt2=cnt2+1;
        end
    end
end

for i = 1:size(reg1_up,2)
    for j =1:15
        frm = reg1_up(7,i);
        x=outputArray(:,ID,frm-j);
        ind = find(x==reg1_up(6,i));
        if size(ind,1)==1
            reg1_up_series(i,:,j)=outputArray(ind,:,frm-j);
        else
            reg1_up_series(i,:,j)=nan;
            cnt3=cnt3+1;
        end
    end
end

for i = 1:size(reg2_up,2)
    for j =1:15
        frm = reg2_up(7,i);
        x=outputArray(:,ID,frm-j);
        ind = find(x==reg2_up(6,i));
        if size(ind,1)==1
            reg2_up_series(i,:,j)=outputArray(ind,:,frm-j);
        else
            reg2_up_series(i,:,j)=nan;
            cnt4=cnt4+1;
        end
    end
end
%%
vys_1=zeros(2,15);
vys_2=zeros(2,15);
ays_1=zeros(2,15);
ays_2=zeros(2,15);
ws_1=zeros(2,15);
ws_2=zeros(2,15);

vys_1_std=zeros(2,15);
vys_2_std=zeros(2,15);
ays_1_std=zeros(2,15);
ays_2_std=zeros(2,15);
ws_1_std=zeros(2,15);
ws_2_std=zeros(2,15);

for i =1:15
    vys_1(1,i)=meanb(reg1_down_series(:,V_Y,16-i)*dx*fps);
    vys_1(2,i)=meanb(reg1_up_series(:,V_Y,16-i)*dx*fps);
    vys_2(1,i)=meanb(reg2_down_series(:,V_Y,16-i)*dx*fps);
    vys_2(2,i)=meanb(reg2_up_series(:,V_Y,16-i)*dx*fps);
    
    vys_1_std(1,i)=stdb(reg1_down_series(:,V_Y,16-i)*dx*fps,vys_1(1,i));
    vys_1_std(2,i)=stdb(reg1_up_series(:,V_Y,16-i)*dx*fps,vys_1(2,i));
    vys_2_std(1,i)=stdb(reg2_down_series(:,V_Y,16-i)*dx*fps,vys_2(1,i));
    vys_2_std(2,i)=stdb(reg2_up_series(:,V_Y,16-i)*dx*fps,vys_2(2,i));
    
    ays_1(1,i)=meanb(reg1_down_series(:,A_Y,16-i)*dx*fps*fps);
    ays_1(2,i)=meanb(reg1_up_series(:,A_Y,16-i)*dx*fps*fps);
    ays_2(1,i)=meanb(reg2_down_series(:,A_Y,16-i)*dx*fps*fps);
    ays_2(2,i)=meanb(reg2_up_series(:,A_Y,16-i)*dx*fps*fps);
    
    ays_1_std(1,i)=stdb(reg1_down_series(:,A_Y,16-i)*dx*fps*fps,ays_1(1,i));
    ays_1_std(2,i)=stdb(reg1_up_series(:,A_Y,16-i)*dx*fps*fps,ays_1(2,i));
    ays_2_std(1,i)=stdb(reg2_down_series(:,A_Y,16-i)*dx*fps*fps,ays_2(1,i));
    ays_2_std(2,i)=stdb(reg2_up_series(:,A_Y,16-i)*dx*fps*fps,ays_2(2,i));
    
    ws_1(1,i)=meanb((reg1_down_series(:,RIGHT_BOTTOM_X,16-i)-reg1_down_series(:,LEFT_BOTTOM_X,16-i))*dx);
    ws_1(2,i)=meanb((reg1_up_series(:,RIGHT_BOTTOM_X,16-i)-reg1_up_series(:,LEFT_BOTTOM_X,16-i))*dx);
    ws_2(1,i)=meanb((reg2_down_series(:,RIGHT_BOTTOM_X,16-i)-reg2_down_series(:,LEFT_BOTTOM_X,16-i))*dx);
    ws_2(2,i)=meanb((reg2_up_series(:,RIGHT_BOTTOM_X,16-i)-reg2_up_series(:,LEFT_BOTTOM_X,16-i))*dx);
    
    ws_1_std(1,i)=stdb((reg1_down_series(:,RIGHT_BOTTOM_X,16-i)-reg1_down_series(:,LEFT_BOTTOM_X,16-i))*dx,ws_1(1,i));
    ws_1_std(2,i)=stdb((reg1_up_series(:,RIGHT_BOTTOM_X,16-i)-reg1_up_series(:,LEFT_BOTTOM_X,16-i))*dx,ws_1(2,i));
    ws_2_std(1,i)=stdb((reg2_down_series(:,RIGHT_BOTTOM_X,16-i)-reg2_down_series(:,LEFT_BOTTOM_X,16-i))*dx,ws_2(1,i));
    ws_2_std(2,i)=stdb((reg2_up_series(:,RIGHT_BOTTOM_X,16-i)-reg2_up_series(:,LEFT_BOTTOM_X,16-i))*dx,ws_2(2,i));
end
n=1:1:15;
n=(15-n)*(-4);

h1=plot(n,vys_1(1,:),'bd');
hold on
errorbar(n,vys_1(1,:),vys_1_std(1,:),'b','LineStyle','none')
hold on
h2=plot(n,vys_1(2,:),'rs');
hold on
errorbar(n,vys_1(2,:),vys_1_std(2,:),'r','LineStyle','none')
ylim([0 700])

legend([h1,h2],["Trailing Bubble","Leading Bubble"],'Location','northwest')
ylabel('Bubble rise velocity (mm/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg1_vy_15.fig')
saveas(gca,'reg1_vy_15.jpg')
%%

h1=plot(n,vys_2(1,:),'bd');
hold on
errorbar(n,vys_2(1,:),vys_2_std(1,:),'b','LineStyle','none')
hold on
h2=plot(n,vys_2(2,:),'rs');
hold on
errorbar(n,vys_2(2,:),vys_2_std(2,:),'r','LineStyle','none')
ylim([0 700])

legend([h1,h2],["Trailing Bubble","Leading Bubble"],'Location','southeast')
ylabel('Bubble rise velocity (mm/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg2_vy_15.fig')
saveas(gca,'reg2_vy_15.jpg')
%%
h1=plot(n,ays_1(1,:),'bd');
hold on
errorbar(n,ays_1(1,:),ays_1_std(1,:),'b','LineStyle','none')
hold on
h2=plot(n,ays_1(2,:),'rs');
hold on
errorbar(n,ays_1(2,:),ays_1_std(2,:),'r','LineStyle','none')
ylim([-15000 45000])

legend([h1,h2],["Trailing Bubble","Leading Bubble"],'Location','northwest')
ylabel('Bubble acceleration (mm/s^2)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg1_ay_15.fig')
saveas(gca,'reg1_ay_15.jpg')
%%
h1=plot(n,ays_2(1,:),'bd');
hold on
errorbar(n,ays_2(1,:),ays_2_std(1,:),'b','LineStyle','none')
hold on
h2=plot(n,ays_2(2,:),'rs');
hold on
errorbar(n,ays_2(2,:),ays_2_std(2,:),'r','LineStyle','none')
ylim([-10000 15000])

legend([h1,h2],["Trailing Bubble","Leading Bubble"],'Location','north')
ylabel('Bubble acceleration (mm/s^2)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg2_ay_15.fig')
saveas(gca,'reg2_ay_15.jpg')
%%
h1=plot(n,ws_1(1,:),'bd');
hold on
errorbar(n,ws_1(1,:),ws_1_std(1,:),'b','LineStyle','none')
hold on
h2=plot(n,ws_1(2,:),'rd');
hold on
errorbar(n,ws_1(2,:),ws_1_std(2,:),'r','LineStyle','none')
ylim([0 50])

legend([h1,h2],["Trailing Bubble","Leading Bubble"],'Location','northeast')
ylabel('Average bubble width (mm)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'reg1_w_15.fig')
saveas(gca,'reg1_w_15.jpg')
%%
h1=plot(n,ws_2(1,:),'bd');
hold on
errorbar(n,ws_2(1,:),ws_2_std(1,:),'b','LineStyle','none')
hold on
h2=plot(n,ws_2(2,:),'rd');
hold on
errorbar(n,ws_2(2,:),ws_2_std(2,:),'r','LineStyle','none')
ylim([0 50])

legend([h1,h2],["Trailing Bubble","Leading Bubble"],'Location','northeast')
ylabel('Average bubble width (mm)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10,'FontName','Times New Roman')
saveas(gca,'reg2_w_15.fig')
saveas(gca,'reg2_w_15.jpg')
%%
function y=meanb(arr)
    sum=0;
    n=0;
    for i=1:size(arr,1)
        if ~isnan(arr(i,1))
           sum=sum+arr(i,1);
           n=n+1;
        end
    end
    y=sum/n;
end

function y=stdb(arr,mean)
    sum=0;
    n=0;
    for i=1:size(arr,1)
        if ~isnan(arr(i,1))
           sum=sum+(arr(i,1)-mean)^2;
           n=n+1;
        end
    end
    y=sqrt(sum/n);
end