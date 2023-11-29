%% single bubble
bubble_id = 13;
plot((system_height-bubbles.CentroidY(bubbles.Track==bubble_id))*dx,bubbles.Area(bubbles.Track==bubble_id)*dx*dx)
ylabel('Area (mm^2)')
xlabel('y (mm)')

plot((system_height-bubbles.CentroidY(bubbles.Track==bubble_id))*dx,bubbles.Vy_mm_s(bubbles.Track==bubble_id))
ylabel('vy (mm/s)')
xlabel('y (mm)')

%% statistics area vs y
dy = 5;
edges = (1:dy:system_height)*dx;
y_bin_ind = discretize((system_height - bubbles.CentroidY) *dx,edges);
mean_area_vs_y = zeros(size(edges));
stdev_area_vs_y = zeros(size(edges));

for i =1:size(edges,2)
    if ~isempty(bubbles.Area(y_bin_ind==i))
    mean_area_vs_y(i) = mean(bubbles.Area(y_bin_ind==i) * dx*dx);
    stdev_area_vs_y(i) = std(bubbles.Area(y_bin_ind==i) * dx*dx);
    end
end
nonzero = mean_area_vs_y~=0;
plot(edges(nonzero),mean_area_vs_y(nonzero))
hold on
reg=[(mean_area_vs_y(nonzero) +stdev_area_vs_y(nonzero)),...
    fliplr( mean_area_vs_y(nonzero)-stdev_area_vs_y(nonzero) )];
h=fill([edges(nonzero), fliplr(edges(nonzero))],reg,[0.6 0.6 0.7],'LineStyle','--','LineWidth',0.5);
set(h,'facealpha',0.1)

xlim([0 system_height*dx])
ylim([0 max(mean_area_vs_y(nonzero) +stdev_area_vs_y(nonzero))])
legend('Mean bubble area','Mean area ± SD','Location','southeast')

ylabel('Bubble area (mm^2)')
xlabel('Bubble height (mm)')
set(gcf,'units','inches','position',[0,0,4,3])
set(gca,'FontSize',12,'FontName','Times New Roman')
saveas(gca,'area_vs_y.jpg')
saveas(gca,'area_vs_y.fig')
save('bubbles.mat','mean_area_vs_y','stdev_area_vs_y','edges',"-append")
%% Leading bubble, trailing bubble before coalescence
interval = 15;


leading_tracks = bubbles(bubbles.LeadTrail>0,["Track","Frame"]); %find leading tracks
ending_centroidy = (system_height-bubbles.CentroidY(bubbles.LeadTrail(bubbles.LeadTrail>0)))*dx;
leading_tracks_region1 = leading_tracks(ending_centroidy > lb1 &...
    ending_centroidy < ub1 ,:); %find leading tracks ends in region 1
leading_tracks_region2 = leading_tracks(ending_centroidy > lb2 &...
    ending_centroidy < ub2 ,:); %find leading tracks ends in region 2

trailing_tracks = bubbles(bubbles.LeadTrail<0,["Track","Frame"]); %find trailing tracks
ending_centroidy = (system_height-bubbles.CentroidY(-bubbles.LeadTrail(bubbles.LeadTrail<0)))*dx;
trailing_tracks_region1 = trailing_tracks(ending_centroidy > lb1 &...
    ending_centroidy < ub1,:); %find trailing tracks ends in region 1
trailing_tracks_region2 = trailing_tracks(ending_centroidy > lb2 &...
    ending_centroidy < ub2,:); 

% y velocity
leading_vy_region1=NaN(interval,size(leading_tracks_region1,1));
leading_vy_region2=NaN(interval,size(leading_tracks_region2,1));
trailing_vy_region1=NaN(interval,size(trailing_tracks_region1,1));
trailing_vy_region2=NaN(interval,size(trailing_tracks_region2,1));

% acceleration
leading_ay_region1=NaN(interval,size(leading_tracks_region1,1));
leading_ay_region2=NaN(interval,size(leading_tracks_region2,1));
trailing_ay_region1=NaN(interval,size(trailing_tracks_region1,1));
trailing_ay_region2=NaN(interval,size(trailing_tracks_region2,1));

% width
leading_w_region1=NaN(interval,size(leading_tracks_region1,1));
leading_w_region2=NaN(interval,size(leading_tracks_region2,1));
trailing_w_region1=NaN(interval,size(trailing_tracks_region1,1));
trailing_w_region2=NaN(interval,size(trailing_tracks_region2,1));



for i = 1:size(leading_tracks_region1,1)
    vy = bubbles.Vy_mm_s(bubbles.Track == leading_tracks_region1.Track(i) & ...
        bubbles.Frame > leading_tracks_region1.Frame(i) -interval & bubbles.Frame <= leading_tracks_region1.Frame(i));
    leading_vy_region1(end-length(vy)+1:end,i) = vy;
    ay = bubbles.Ay_mm_s2(bubbles.Track == leading_tracks_region1.Track(i) & ...
        bubbles.Frame > leading_tracks_region1.Frame(i) -interval & bubbles.Frame <= leading_tracks_region1.Frame(i));
    leading_ay_region1(end-length(ay)+1:end,i) = ay;
    w = dx * bubbles.Width(bubbles.Track == leading_tracks_region1.Track(i) & ...
        bubbles.Frame > leading_tracks_region1.Frame(i) -interval & bubbles.Frame <= leading_tracks_region1.Frame(i));
    leading_w_region1(end-length(w)+1:end,i) = w;
end
for i = 1:size(leading_tracks_region2,1)
    vy = bubbles.Vy_mm_s(bubbles.Track == leading_tracks_region2.Track(i) & ...
        bubbles.Frame > leading_tracks_region2.Frame(i) -interval & bubbles.Frame <= leading_tracks_region2.Frame(i));
    leading_vy_region2(end-length(vy)+1:end,i) = vy;
    ay = bubbles.Ay_mm_s2(bubbles.Track == leading_tracks_region2.Track(i) & ...
        bubbles.Frame > leading_tracks_region2.Frame(i) -interval & bubbles.Frame <= leading_tracks_region2.Frame(i));
    leading_ay_region2(end-length(ay)+1:end,i) = ay;
    w = dx * bubbles.Width(bubbles.Track == leading_tracks_region2.Track(i) & ...
        bubbles.Frame > leading_tracks_region2.Frame(i) -interval & bubbles.Frame <= leading_tracks_region2.Frame(i));
    leading_w_region2(end-length(w)+1:end,i) = w;
end
for i = 1:size(trailing_tracks_region1,1)
    vy = bubbles.Vy_mm_s(bubbles.Track == trailing_tracks_region1.Track(i) & ...
        bubbles.Frame > trailing_tracks_region1.Frame(i) -interval & bubbles.Frame <= trailing_tracks_region1.Frame(i));
    trailing_vy_region1(end-length(vy)+1:end,i) = vy;
    ay = bubbles.Ay_mm_s2(bubbles.Track == trailing_tracks_region1.Track(i) & ...
        bubbles.Frame > trailing_tracks_region1.Frame(i) -interval & bubbles.Frame <= trailing_tracks_region1.Frame(i));
    trailing_ay_region1(end-length(ay)+1:end,i) = ay;
    w = dx * bubbles.Width(bubbles.Track == trailing_tracks_region1.Track(i) & ...
        bubbles.Frame > trailing_tracks_region1.Frame(i) -interval & bubbles.Frame <= trailing_tracks_region1.Frame(i));
    trailing_w_region1(end-length(w)+1:end,i) = w;
end
for i = 1:size(trailing_tracks_region2,1)
    vy = bubbles.Vy_mm_s(bubbles.Track == trailing_tracks_region2.Track(i) & ...
        bubbles.Frame > trailing_tracks_region2.Frame(i) -interval & bubbles.Frame <= trailing_tracks_region2.Frame(i));
    trailing_vy_region2(end-length(vy)+1:end,i) = vy;
    ay = bubbles.Ay_mm_s2(bubbles.Track == trailing_tracks_region2.Track(i) & ...
        bubbles.Frame > trailing_tracks_region2.Frame(i) -interval & bubbles.Frame <= trailing_tracks_region2.Frame(i));
    trailing_ay_region2(end-length(ay)+1:end,i) = ay;
    w = dx * bubbles.Width(bubbles.Track == trailing_tracks_region2.Track(i) & ...
        bubbles.Frame > trailing_tracks_region2.Frame(i) -interval & bubbles.Frame <= trailing_tracks_region2.Frame(i));
    trailing_w_region2(end-length(w)+1:end,i) = w;
end
%% mean vy

mean_leading_region1 = mean(rmoutliers(leading_vy_region1.','percentiles',[10,90]).',2,'omitnan');
std_leading_region1 = std(rmoutliers(leading_vy_region1.','percentiles',[10,90]).',0,2,'omitnan');
mean_trailing_region1 = mean(rmoutliers(trailing_vy_region1.','percentiles',[10,90]).',2,'omitnan');
std_trailing_region1 = std(rmoutliers(trailing_vy_region1.','percentiles',[10,90]).',0,2,'omitnan');

mean_leading_region2 = mean(rmoutliers(leading_vy_region2.','percentiles',[10,90]).',2,'omitnan');
std_leading_region2 = std(rmoutliers(leading_vy_region2.','percentiles',[10,90]).',0,2,'omitnan');
mean_trailing_region2 = mean(rmoutliers(trailing_vy_region2.','percentiles',[10,90]).',2,'omitnan');
std_trailing_region2 = std(rmoutliers(trailing_vy_region2.','percentiles',[10,90]).',0,2,'omitnan');

figure
h1=plot((-interval:1:-1)/fps*1000,mean_leading_region1,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,mean_leading_region1, std_leading_region1,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,mean_trailing_region1,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,mean_trailing_region1, std_trailing_region1,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','southwest')
ylabel('Bubble rise velocity (mm/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
ylim([0 2000])
saveas(gca,'mean_reg1_vy_15.fig')
saveas(gca,'mean_reg1_vy_15.svg')


figure 
h1=plot((-interval:1:-1)/fps*1000,mean_leading_region2,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,mean_leading_region2, std_leading_region2,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,mean_trailing_region2,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,mean_trailing_region2, std_trailing_region2,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','southwest')
ylabel('Bubble rise velocity (mm/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
ylim([0 2000])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'mean_reg2_vy_15.fig')
saveas(gca,'mean_reg2_vy_15.svg')

save('bubbles.mat','lb1','lb2','ub1','ub2',...
    'leading_vy_region1','leading_vy_region2','trailing_vy_region1','trailing_vy_region2','interval',"-append");

%% median vy

median_leading_region1 = median(leading_vy_region1,2,'omitnan');
quartile_leading_region1 = prctile(leading_vy_region1,[25, 75],2);
median_trailing_region1 = median(trailing_vy_region1,2,'omitnan');
quartile_trailing_region1 = prctile(trailing_vy_region1,[25, 75],2);

median_leading_region2 = median(leading_vy_region2,2,'omitnan');
quartile_leading_region2 = prctile(leading_vy_region2,[25, 75],2);
median_trailing_region2 = median(trailing_vy_region2,2,'omitnan');
quartile_trailing_region2 = prctile(trailing_vy_region2,[25, 75],2);

figure
h1=plot((-interval:1:-1)/fps*1000,median_leading_region1,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,median_leading_region1, median_leading_region1-quartile_leading_region1(:,1),quartile_leading_region1(:,2)-median_leading_region1,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,median_trailing_region1,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,median_trailing_region1, median_trailing_region1-quartile_trailing_region1(:,1),quartile_trailing_region1(:,2)-median_trailing_region1,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','southwest')
ylabel('Rise velocity (mm/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
ylim([0 2000])
saveas(gca,'reg1_vy_15.fig')
saveas(gca,'reg1_vy_15.svg')


figure 
h1=plot((-interval:1:-1)/fps*1000,median_leading_region2,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,median_leading_region2, median_leading_region2-quartile_leading_region2(:,1),quartile_leading_region2(:,2)-median_leading_region2,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,median_trailing_region2,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,median_trailing_region2, median_trailing_region2-quartile_trailing_region2(:,1),quartile_trailing_region2(:,2)-median_trailing_region2,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','southwest')
ylabel('Rise velocity (mm/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
ylim([0 2000])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg2_vy_15.fig')
saveas(gca,'reg2_vy_15.svg')

save('bubbles.mat','lb1','lb2','ub1','ub2',...
    'leading_vy_region1','leading_vy_region2','trailing_vy_region1','trailing_vy_region2','interval',"-append");

%% median ay
median_leading_region1 = median(leading_ay_region1,2,'omitnan');
quartile_leading_region1 = prctile(leading_ay_region1,[25, 75],2);
median_trailing_region1 = median(trailing_ay_region1,2,'omitnan');
quartile_trailing_region1 = prctile(trailing_ay_region1,[25, 75],2);

median_leading_region2 = median(leading_ay_region2,2,'omitnan');
quartile_leading_region2 = prctile(leading_ay_region2,[25, 75],2);
median_trailing_region2 = median(trailing_ay_region2,2,'omitnan');
quartile_trailing_region2 = prctile(trailing_ay_region2,[25, 75],2);

figure
h1=plot((-interval:1:-1)/fps*1000,median_leading_region1,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,median_leading_region1, median_leading_region1-quartile_leading_region1(:,1),quartile_leading_region1(:,2)-median_leading_region1,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,median_trailing_region1,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,median_trailing_region1, median_trailing_region1-quartile_trailing_region1(:,1),quartile_trailing_region1(:,2)-median_trailing_region1,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','northeast')
ylabel('Vertical acceleration (mm^2/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
%ylim([0 800])
saveas(gca,'reg1_ay_15.fig')
saveas(gca,'reg1_ay_15.svg')


figure 
h1=plot((-interval:1:-1)/fps*1000,median_leading_region2,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,median_leading_region2, median_leading_region2-quartile_leading_region2(:,1),quartile_leading_region2(:,2)-median_leading_region2,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,median_trailing_region2,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,median_trailing_region2, median_trailing_region2-quartile_trailing_region2(:,1),quartile_trailing_region2(:,2)-median_trailing_region2,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','northeast')
ylabel('Vertical acceleration (mm^2/s)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
ylim([-1e4 1.5e4])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg2_ay_15.fig')
saveas(gca,'reg2_ay_15.svg')

save('bubbles.mat','lb1','lb2','ub1','ub2',...
    'leading_ay_region1','leading_ay_region2','trailing_ay_region1','trailing_ay_region2','interval',"-append");

%% median width

median_leading_region1 = median(leading_w_region1,2,'omitnan');
quartile_leading_region1 = prctile(leading_w_region1,[25, 75],2);
median_trailing_region1 = median(trailing_w_region1,2,'omitnan');
quartile_trailing_region1 = prctile(trailing_w_region1,[25, 75],2);

median_leading_region2 = median(leading_w_region2,2,'omitnan');
quartile_leading_region2 = prctile(leading_w_region2,[25, 75],2);
median_trailing_region2 = median(trailing_w_region2,2,'omitnan');
quartile_trailing_region2 = prctile(trailing_w_region2,[25, 75],2);

figure
h1=plot((-interval:1:-1)/fps*1000,median_leading_region1,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,median_leading_region1, median_leading_region1-quartile_leading_region1(:,1),quartile_leading_region1(:,2)-median_leading_region1,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,median_trailing_region1,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,median_trailing_region1, median_trailing_region1-quartile_trailing_region1(:,1),quartile_trailing_region1(:,2)-median_trailing_region1,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','northeast')
ylabel('Width (mm)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
set(gca,'FontSize',9,'FontName','Times New Roman')
ylim([0 100])
saveas(gca,'reg1_w_15.fig')
saveas(gca,'reg1_w_15.svg')


figure 
h1=plot((-interval:1:-1)/fps*1000,median_leading_region2,'rs');
hold on
errorbar((-interval:1:-1)/fps*1000,median_leading_region2, median_leading_region2-quartile_leading_region2(:,1),quartile_leading_region2(:,2)-median_leading_region2,'r','LineStyle','none')
h2=plot((-interval:1:-1)/fps*1000,median_trailing_region2,'bd');
hold on
errorbar((-interval:1:-1)/fps*1000,median_trailing_region2, median_trailing_region2-quartile_trailing_region2(:,1),quartile_trailing_region2(:,2)-median_trailing_region2,'b','LineStyle','none')
%legend([h2,h1],["Trailing Bubble","Leading Bubble"],'Location','northeast')
ylabel('Width (mm)')
xlabel('Time to coalesce (ms)')
set(gcf,'units','inches','position',[0,0,2.16,2])
ylim([0 100])
set(gca,'FontSize',9,'FontName','Times New Roman')
saveas(gca,'reg2_w_15.fig')
saveas(gca,'reg2_w_15.svg')

save('bubbles.mat','lb1','lb2','ub1','ub2',...
    'leading_w_region1','leading_w_region2','trailing_w_region1','trailing_w_region2','interval',"-append");

