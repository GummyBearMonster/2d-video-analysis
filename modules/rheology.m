vis_m=[];
shear=[];

%%
vis=vis_m/1000;
%%

fn='cs10%rheology';
dx=0.01;
x=0.1:dx:1e3;

figure

for i =1:size(vis,2)

    shear_new=[shear(1,i)];
    vis_new=[vis(1,i)];
    for j = 2:size(vis,1)
        if shear(j,i)>shear_new(end)
            shear_new=[shear_new shear(j,i)];
            vis_new=[vis_new vis(j,i)];
        end
    end
    
    
    semilogx(shear_new,vis_new,'*')
    hold on
    vis_interp(i,:)=interp1(shear_new,vis_new,x,'pchip');
    h(i)=semilogx(x,vis_interp(i,:),'DisplayName',['Run' int2str(i)]);
    hold on
end

xlabel('Shear rate (/s)')
ylabel('Viscosity (Pa s)')

for i=1:size(x,2)
    avg_vis(i)=mean(vis_interp(:,i));
end
h(4)=semilogx(x,avg_vis,'--','DisplayName','Avg');
xlim([0.1 1e3])
ylim([0 4e-2])
xlabel('Shear rate (/s)')
ylabel('Viscosity (Pa s)')
legend(h)
%%
saveas(gca,[fn '.fig'])
saveas(gca,[fn '.jpg'])
save([fn '.mat'])
%%
