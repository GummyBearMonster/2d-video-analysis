%%
corr_coeffs(2,:)=corr_coeff;

%plot(corr_coeffs(1,:))
%%
flrt=[0.5 1 1.5 2 2.5];
pcfr=[10 20 30 35 40 44];
for i =1:5
mean_c(i) = mean(corr_coeffs(i,2:20000));
pct_25(i) = prctile(corr_coeffs(i,2:20000),25);
pct_75(i) = prctile(corr_coeffs(i,2:20000),75);
mean_c2(i) = mean(corr_coeffs2(i,2:20000));
pct_252(i) = prctile(corr_coeffs2(i,2:20000),25);
pct_752(i) = prctile(corr_coeffs2(i,2:20000),75);
end

b=bar(flrt,[mean_c; mean_c2],1);
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10, 'FontName', 'Times New Roman')

hold on
[ngroups,nbars] = size([mean_c; mean_c2]);
x = nan(ngroups, nbars);
for i = 1:ngroups
    x(i,:) = b(i).XEndPoints;
end

errorbar(x,[mean_c; mean_c2],[mean_c; mean_c2]-[pct_25; pct_252],-[mean_c; mean_c2]+[pct_75; pct_752],'k','linestyle','none');
%errorbar(pcfr,mean_c, mean_c-pct_25, pct_75-mean_c,'k','LineWidth',1)
hold off
xlim([0 3])
xticks([0.5 1 1.5 2 2.5])
ylim([0 1])
xlabel('Flowrate (lpm)')
ylabel('Correlation Coefficient')
legend('40%','40% density matched')
saveas(gca,'corr.jpg')
saveas(gcf,'corr2.jpg')

%%
interval=[100 150 200 250 300 350];
pcfr=[10 20 30 35 40 44];
for i =1:6
mean_c(i) = mean(corr_coeffs(i,2:20000));
pct_25(i) = prctile(corr_coeffs(i,2:20000),25);
pct_75(i) = prctile(corr_coeffs(i,2:20000),75);
end

b=bar(interval,mean_c,1);
set(gcf,'units','inches','position',[0,0,3.25,2.5])
set(gca,'FontSize',10, 'FontName', 'Times New Roman')

hold on
%[ngroups,nbars] = size([mean_c; mean_c2]);
%x = nan(ngroups, nbars);
%for i = 1:ngroups
%    x(i,:) = b(i).XEndPoints;
%end

%errorbar(i,[mean_c; mean_c2],[mean_c; mean_c2]-[pct_25; pct_252],-[mean_c; mean_c2]+[pct_75; pct_752],'k','linestyle','none');
errorbar(interval,mean_c, mean_c-pct_25, pct_75-mean_c,'k','LineWidth',1)
hold off
%xlim([0 3])
%xticks([0.5 1 1.5 2 2.5])
%ylim([0 1])
xlabel('Interval (ms)')
ylabel('Correlation Coefficient')
legend('40%')
saveas(gca,'corr.jpg')
saveas(gcf,'corr2.jpg')