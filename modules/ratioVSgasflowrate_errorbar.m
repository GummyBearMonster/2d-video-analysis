clear all
clc

%%
% Air properties
rho_g = 1.225; %kg/m3
mu_g = 1.81*10^(-5); %Pa·s
g = 9.8; %gravity[m/s]
do = 4.5*10^-3 ;%nozzle diameter [m]
A0 = pi* do^2/4;

%%
% %Read the ratios from the table
% rw_15_3 = 0.803236939561422;%ratio of max to min in cross correlation
% rw_23_3 = 1.24865857451462;
% rw_24_3 = 1.01923867901533;
% 
% rw_15_6 = 1.04262401655057;
% rw_23_6 = 1.55801209911153;
% rw_24_6 = 1.1141583332729;
% 
% rw_15_9 = 1.44326278742991;
% rw_23_9 = 1.60299749223489;
% rw_24_9 = 1.29190542386746;
% 
% % water properties
% rho_lw = 1000; %kg/m3 (water)
% mu_lw = 8.9* 10^(-4); %pa.s
% si_lw = 72*10^(-3) ;%surface tension (N/m)
% 
% %dimensionless numbers
% uw_3 = (1.5*10^-3/60)/A0 ; %jet velocity [m3/s]
% uw_6 = (3*10^-3/60)/A0 ;
% uw_9 = (4.5*10^-3/60)/A0 ;
% 
% Frw_3 = (uw_3*uw_3)/(g*do);
% Frw_6 = (uw_6*uw_6)/(g*do);
% Frw_9 = (uw_9*uw_9)/(g*do);
% 
% Wew_3 = (rho_g*uw_3*uw_3)/si_lw;
% Wew_6 = (rho_g*uw_6*uw_6)/si_lw;
% Wew_9 = (rho_g*uw_9*uw_9)/si_lw;
% 
% Rew_3 = (rho_lw*uw_3*do)/mu_lw;
% Rew_6 = (rho_lw*uw_6*do)/mu_lw;
% Rew_9 = (rho_lw*uw_9*do)/mu_lw;
% 
% Caw_3 = (mu_lw*uw_3)/si_lw;
% Caw_6 = (mu_lw*uw_6)/si_lw;
% Caw_9 = (mu_lw*uw_9)/si_lw;
%%
%Si oil 100 cst (low viscosity)
% 10 cm high
rsl_15_3 = 1.0158;%1.01651845131414;%ratio of max to min in cross correlation
rsl_23_3 = 1.1484;%1.14947729926162;
rsl_24_3 = 1.0319;%1.03277823347403;

rsl_15_6 = 1.0023;%1.01678151046584;
rsl_23_6 = 1.3473;%1.35931856958674;
rsl_24_6 = 1.0833;%1.08553033733651;

rsl_15_9 = 1.0210;%1.02783611713745;
rsl_23_9 = 1.1987;%1.35012046655506;
rsl_24_9 = 1.0968;%1.12834890574978;

stdrsl_15_3 = 0.0274;%ratio of max to min in cross correlation
stdrsl_23_3 = 0.035;
stdrsl_24_3 = 0.0365;

stdrsl_15_6 = 0.0100;
stdrsl_23_6 = 0.0714;
stdrsl_24_6 = 0.0379;

stdrsl_15_9 = 0.0935;
stdrsl_23_9 = 0.028;
stdrsl_24_9 = 0.0593;


% si oil properties
rho_lsl = 960; %kg/m3 (Si Oil)
mu_lsl = 0.096; %pa.s
si_lsl = 20.9*10^(-3) ;%surface tension

%dimensionless numbers
usl_3 = (1.5*10^-3/60)/A0 ; %jet velocity [m3/s]
usl_6 = (3*10^-3/60)/A0 ;
usl_9 = (4.5*10^-3/60)/A0 ;

Frsl_3 = (usl_3*usl_3)/(g*do);
Frsl_6 = (usl_6*usl_6)/(g*do);
Frsl_9 = (usl_9*usl_9)/(g*do);

Wesl_3 = (rho_g*usl_3*usl_3)/si_lsl;
Wesl_6 = (rho_g*usl_6*usl_6)/si_lsl;
Wesl_9 = (rho_g*usl_9*usl_9)/si_lsl;

Resl_3 = (rho_lsl*usl_3*do)/mu_lsl;
Resl_6 = (rho_lsl*usl_6*do)/mu_lsl;
Resl_9 = (rho_lsl*usl_9*do)/mu_lsl;

Casl_3 = (mu_lsl*usl_3)/si_lsl;
Casl_6 = (mu_lsl*usl_6)/si_lsl;
Casl_9 = (mu_lsl*usl_9)/si_lsl;
%%
%Si oil 10,000 cst (high viscosity)
% rsh_15_3 = 1.92049766584736;%ratio of max to min in cross correlation
% rsh_23_3 = 0.611980334939763;
% rsh_24_3 = 0.856697921642181;
% 
% rsh_15_6 = 1.26769578929463;
% rsh_23_6 = 0.58730240920442;
% rsh_24_6 = 0.779770662687037;
% 
% rsh_15_9 = 0.795178277417219;
% rsh_23_9 = 0.529122036765719;
% rsh_24_9 = 0.744997960028457;
% 
% %si oil properties
% rho_lsh = 971; %kg/m3 (Si Oil 10,000 cst)
% mu_lsh = 9.71; %pa.s
% si_lsh = 21.5*10^(-3) ;%surface tension (N/m)
% 
% ush_3 = (0.2*10^-3/60)/A0 ; %jet velocity [m3/s]
% ush_6 = (0.3*10^-3/60)/A0 ;
% ush_9 = (0.4*10^-3/60)/A0 ;
% 
% Frsh_3 = (ush_3*ush_3)/(g*do);
% Frsh_6 = (ush_6*ush_6)/(g*do);
% Frsh_9 = (ush_9*ush_9)/(g*do);
% 
% Wesh_3 = (rho_g*ush_3*ush_3)/si_lsh;
% Wesh_6 = (rho_g*ush_6*ush_6)/si_lsh;
% Wesh_9 = (rho_g*ush_9*ush_9)/si_lsh;
% 
% Resh_3 = (rho_lsh*ush_3*do)/mu_lsh;
% Resh_6 = (rho_lsh*ush_6*do)/mu_lsh;
% Resh_9 = (rho_lsh*ush_9*do)/mu_lsh;
% 
% Cash_3 = (mu_lsh*ush_3)/si_lsh;
% Cash_6 = (mu_lsh*ush_6)/si_lsh;
% Cash_9 = (mu_lsh*ush_9)/si_lsh;

%% Ratio VS Fr

figure
% plot(Frw_3,rw_23_3,'rd',Frw_6,rw_23_6,'rd',Frw_9,rw_23_9,'rd','MarkerSize',14)
% hold on
% plot(Frw_3,rw_24_3,'ro',Frw_6,rw_24_6,'ro',Frw_9,rw_24_9,'ro','MarkerSize',14)
% hold on
% plot(Frw_3,rw_15_3,'rs',Frw_6,rw_15_6,'rs',Frw_9,rw_15_9,'rs','MarkerSize',14)
% hold on 
Fr_1 = [Frsl_3,Frsl_6,Frsl_9];
ave_ra_1 = [rsl_23_3,rsl_23_6,rsl_23_9];
std_rat_1 = [stdrsl_23_3,stdrsl_23_6,stdrsl_23_9];
Fr_2 = [Frsl_3,Frsl_6,Frsl_9];
ave_ra_2 = [rsl_24_3,rsl_24_6,rsl_24_9];
std_rat_2 = [stdrsl_24_3,stdrsl_24_6,stdrsl_24_9];
Fr_3 = [Frsl_3,Frsl_6,Frsl_9];
ave_ra_3 = [rsl_15_3,rsl_15_6,rsl_15_9];
std_rat_3 = [stdrsl_15_3,stdrsl_15_6,stdrsl_15_9];

h1= errorbar(Fr_1,ave_ra_1,std_rat_1,'MarkerEdgeColor','red')
axis square
h1.Marker='d';
h1.LineStyle='none';
h1.MarkerSize=12;
h1.LineWidth=1.5;
h1.Color = 'blue';
hold on
h2= errorbar(Fr_2,ave_ra_2,std_rat_2,'MarkerEdgeColor','red')
h2.Marker='o';
h2.LineStyle='none';
h2.MarkerSize=12;
h2.LineWidth=1.5;
h2.Color = 'blue';
hold on
h3= errorbar(Fr_3,ave_ra_3,std_rat_3,'MarkerEdgeColor','red')
h3.Marker='s';
h3.LineStyle='none';
h3.MarkerSize=12;
h3.LineWidth=1.5;
h3.Color = 'blue';


% plot(Frsh_3,rsh_23_3,'kd',Frsh_6,rsh_23_6,'kd',Frsh_9,rsh_23_9,'kd','MarkerSize',14)
% hold on
% plot(Frsh_3,rsh_24_3,'ko',Frsh_6,rsh_24_6,'ko',Frsh_9,rsh_24_9,'ko','MarkerSize',14)
% hold on
% plot(Frsh_3,rsh_15_3,'ks',Frsh_6,rsh_15_6,'ks',Frsh_9,rsh_15_9,'ks','MarkerSize',14)

xlabel('Fr')
ylabel('Max/Min Cross Correlation')
% xlim([0 5])
ylim([0.4 2])
%lgd = legend('ports 2+3,3 lpm','ports 2+3,6 lpm','ports 2+3,9 lpm','ports 2+4,3 lpm','ports 2+4,6 lpm','ports 2+4,9 lpm','ports 1+5,3 lpm','ports 1+5,6 lpm','ports 1+5,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);
set(gca,'fontsize',14,'FontWeight','Bold')
saveas(gcf,'RatioVsFr.fig')
saveas(gcf,'RatioVsFr.jpg')

%% Ratio VS Ca
% figure
% plot(Caw_3,rw_23_3,'rd',Caw_6,rw_23_6,'rd',Caw_9,rw_23_9,'rd','MarkerSize',14)
% hold on
% plot(Caw_3,rw_24_3,'ro',Caw_6,rw_24_6,'ro',Caw_9,rw_24_9,'ro','MarkerSize',14)
% hold on
% plot(Caw_3,rw_15_3,'rs',Caw_6,rw_15_6,'rs',Caw_9,rw_15_9,'rs','MarkerSize',14)
% hold on 

Ca_1 = [Casl_3,Casl_6,Casl_9];
ave_ra_1 = [rsl_23_3,rsl_23_6,rsl_23_9];
std_rat_1 = [stdrsl_23_3,stdrsl_23_6,stdrsl_23_9];
Ca_2 = [Casl_3,Casl_6,Casl_9];
ave_ra_2 = [rsl_24_3,rsl_24_6,rsl_24_9];
std_rat_2 = [stdrsl_24_3,stdrsl_24_6,stdrsl_24_9];
Ca_3 = [Casl_3,Casl_6,Casl_9];
ave_ra_3 = [rsl_15_3,rsl_15_6,rsl_15_9];
std_rat_3 = [stdrsl_15_3,stdrsl_15_6,stdrsl_15_9];

h1= errorbar(Ca_1,ave_ra_1,std_rat_1,'MarkerEdgeColor','red')
axis square
h1.Marker='d';
h1.LineStyle='none';
h1.MarkerSize=12;
h1.LineWidth=1.5;
h1.Color = 'blue';
hold on
h2= errorbar(Ca_2,ave_ra_2,std_rat_2,'MarkerEdgeColor','red')
h2.Marker='o';
h2.LineStyle='none';
h2.MarkerSize=12;
h2.LineWidth=1.5;
h2.Color = 'blue';
hold on
h3= errorbar(Ca_3,ave_ra_3,std_rat_3,'MarkerEdgeColor','red')
h3.Marker='s';
h3.LineStyle='none';
h3.MarkerSize=12;
h3.LineWidth=1.5;
h3.Color = 'blue';

% plot(Cash_3,rsh_23_3,'kd',Cash_6,rsh_23_6,'kd',Cash_9,rsh_23_9,'kd','MarkerSize',14)
% hold on
% plot(Cash_3,rsh_24_3,'ko',Cash_6,rsh_24_6,'ko',Cash_9,rsh_24_9,'ko','MarkerSize',14)
% hold on
% plot(Cash_3,rsh_15_3,'ks',Cash_6,rsh_15_6,'ks',Cash_9,rsh_15_9,'ks','MarkerSize',14)
% 
ax = gca;
ax.FontSize = 20;
xlabel('Ca')
ylabel('Max/Min Cross Correlation')
xlim([-10 200])
ylim([0.4 2])
%lgd = legend('ports 2+3,3 lpm','ports 2+3,6 lpm','ports 2+3,9 lpm','ports 2+4,3 lpm','ports 2+4,6 lpm','ports 2+4,9 lpm','ports 1+5,3 lpm','ports 1+5,6 lpm','ports 1+5,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);
saveas(gcf,'RatioVsCa.fig')
saveas(gcf,'RatioVsCa.jpg')

%% Bubble Breakoff Frequency

%water
wLbbf_15_3 = 22.5864;
wLbbf_23_3 = 27.8221;
wLbbf_24_3 = 26.3823;

wLbbf_15_6 = 25.6705;
wLbbf_23_6 = 22.6823;
wLbbf_24_6 = 25.7446;

wLbbf_15_9 = 19.1585;
wLbbf_23_9 = 21.3941;
wLbbf_24_9 = 21.2989;

wRbbf_15_3 = 33.3239;
wRbbf_23_3 = 20.6768;
wRbbf_24_3 = 15.4849;

wRbbf_15_6 = 28.0664;
wRbbf_23_6 = 22.2906;
wRbbf_24_6 = 22.2235;

wRbbf_15_9 = 22.8545;
wRbbf_23_9 = 21.5529;
wRbbf_24_9 = 20.7629;

%si oil 100 cst
slLbbf_15_3 = 14.2458;
slLbbf_23_3 = 27.0792;
slLbbf_24_3 = 28.4125;

slLbbf_15_6 = 8.6942;
slLbbf_23_6 = 27.7458;
slLbbf_24_6 = 24.4125;

slLbbf_15_9 = 19.5368;
slLbbf_23_9 = 28.4125;
slLbbf_24_9 = 22.9125;

slRbbf_15_3 = 14.4125;
slRbbf_23_3 = 28.7458;
slRbbf_24_3 = 29.2458;

slRbbf_15_6 = 8.7105;
slRbbf_23_6 = 26.2458;
slRbbf_24_6 = 26.0792;

slRbbf_15_9 = 16.7935;
slRbbf_23_9 = 17.473;
slRbbf_24_9 = 16.7566;

%si oil 10,000 cst
shLbbf_15_3 = 0.24583;
shLbbf_23_3 = 0.4125;
shLbbf_24_3 = 0.24583;

shLbbf_15_6 = 0.24583;
shLbbf_23_6 = 0.52749;
shLbbf_24_6 = 0.24583;

shLbbf_15_9 = 0.52576;
shLbbf_23_9 = 0.49159;
shLbbf_24_9 = 0.24583;

shRbbf_15_3 = 0.24583;
shRbbf_23_3 = 0.4125;
shRbbf_24_3 = 0.24583;

shRbbf_15_6 = 0.24583;
shRbbf_23_6 = 0.44841;
shRbbf_24_6 = 0.4125;

shRbbf_15_9 = 0.3973;
shRbbf_23_9 = 0.44791;
shRbbf_24_9 = 0.40528;

%%
%Left bubble break off frequency
% figure
% plot(Ca_3,Lbbf_23_3,'rd',Ca_6,Lbbf_23_6,'rd',Ca_9,Lbbf_23_9,'rd','MarkerSize',14)
% hold on
% plot(Ca_3,Lbbf_24_3,'bo',Ca_6,Lbbf_24_6,'bo',Ca_9,Lbbf_24_9,'bo','MarkerSize',14)
% hold on
% plot(Ca_3,Lbbf_15_3,'ks',Ca_6,Lbbf_15_6,'ks',Ca_9,Lbbf_15_9,'ks','MarkerSize',14)
% ax = gca;
% ax.FontSize = 16;
% xlabel('Ca')
% ylabel('Left Bubble Breakoff Frequency')
% %xlim([0 2500])
% % ylim([10 30])
% %lgd = legend('ports 2+3,3 lpm','ports 2+3,6 lpm','ports 2+3,9 lpm','ports 2+4,3 lpm','ports 2+4,6 lpm','ports 2+4,9 lpm','ports 1+5,3 lpm','ports 1+5,6 lpm','ports 1+5,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);
% saveas(gcf,'LbbfVsCa.fig')
% saveas(gcf,'LbbfVsCa.jpg')
% %%
% %Right bubble break off frequency
% figure
% plot(Ca_3,Rbbf_23_3,'rd',Ca_6,Rbbf_23_6,'rd',Ca_9,Rbbf_23_9,'rd','MarkerSize',14)
% hold on
% plot(Ca_3,Rbbf_24_3,'bo',Ca_6,Rbbf_24_6,'bo',Ca_9,Rbbf_24_9,'bo','MarkerSize',14)
% hold on
% plot(Ca_3,Rbbf_15_3,'ks',Ca_6,Rbbf_15_6,'ks',Ca_9,Rbbf_15_9,'ks','MarkerSize',14)
% ax = gca;
% ax.FontSize = 16;
% xlabel('Ca')
% ylabel('Left Bubble Breakoff Frequency')
% %xlim([0 2500])
% % ylim([10 30])
% %lgd = legend('ports 2+3,3 lpm','ports 2+3,6 lpm','ports 2+3,9 lpm','ports 2+4,3 lpm','ports 2+4,6 lpm','ports 2+4,9 lpm','ports 1+5,3 lpm','ports 1+5,6 lpm','ports 1+5,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);
% saveas(gcf,'RbbfVsCa.fig')
% saveas(gcf,'RbbfVsCa.jpg')
%% bubble radii

%water
wbubble_radii_3_23 = sqrt((1.5*1.667*10^(-5))/(pi*0.01*((wLbbf_23_3+wRbbf_23_3)/2)));
wbubble_radii_3_24 = sqrt((1.5*1.667*10^(-5))/(pi*0.01*((wLbbf_24_3+wRbbf_24_3)/2)));
wbubble_radii_3_15 = sqrt((1.5*1.667*10^(-5))/(pi*0.01*((wLbbf_15_3+wRbbf_15_3)/2)));
wbubble_radii_6_23 = sqrt((3*1.667*10^(-5))/(pi*0.01*((wLbbf_23_6+wRbbf_23_6)/2)));
wbubble_radii_6_24 = sqrt((3*1.667*10^(-5))/(pi*0.01*((wLbbf_24_6+wRbbf_24_6)/2)));
wbubble_radii_6_15 = sqrt((3*1.667*10^(-5))/(pi*0.01*((wLbbf_15_6+wRbbf_15_6)/2)));
wbubble_radii_9_23 = sqrt((4.5*1.667*10^(-5))/(pi*0.01*((wLbbf_23_9+wRbbf_23_9)/2)));
wbubble_radii_9_24 = sqrt((4.5*1.667*10^(-5))/(pi*0.01*((wLbbf_24_9+wRbbf_24_9)/2)));
wbubble_radii_9_15 = sqrt((4.5*1.667*10^(-5))/(pi*0.01*((wLbbf_15_9+wRbbf_15_9)/2)));

%si oil 100 cst
slbubble_radii_3_23 = sqrt((1.5*1.667*10^(-5))/(pi*0.01*((slLbbf_23_3+slRbbf_23_3)/2)));
slbubble_radii_3_24 = sqrt((1.5*1.667*10^(-5))/(pi*0.01*((slLbbf_24_3+slRbbf_24_3)/2)));
slbubble_radii_3_15 = sqrt((1.5*1.667*10^(-5))/(pi*0.01*((slLbbf_15_3+slRbbf_15_3)/2)));
slbubble_radii_6_23 = sqrt((3*1.667*10^(-5))/(pi*0.01*((slLbbf_23_6+slRbbf_23_6)/2)));
slbubble_radii_6_24 = sqrt((3*1.667*10^(-5))/(pi*0.01*((slLbbf_24_6+slRbbf_24_6)/2)));
slbubble_radii_6_15 = sqrt((3*1.667*10^(-5))/(pi*0.01*((slLbbf_15_6+slRbbf_15_6)/2)));
slbubble_radii_9_23 = sqrt((4.5*1.667*10^(-5))/(pi*0.01*((slLbbf_23_9+slRbbf_23_9)/2)));
slbubble_radii_9_24 = sqrt((4.5*1.667*10^(-5))/(pi*0.01*((slLbbf_24_9+slRbbf_24_9)/2)));
slbubble_radii_9_15 = sqrt((4.5*1.667*10^(-5))/(pi*0.01*((slLbbf_15_9+slRbbf_15_9)/2)));

% si oil 10,000 cst
shbubble_radii_3_23 = sqrt((0.2*1.667*10^(-5))/(pi*0.01*((shLbbf_23_3+shRbbf_23_3)/2)));
shbubble_radii_3_24 = sqrt((0.2*1.667*10^(-5))/(pi*0.01*((shLbbf_24_3+shRbbf_24_3)/2)));
shbubble_radii_3_15 = sqrt((0.2*1.667*10^(-5))/(pi*0.01*((shLbbf_15_3+shRbbf_15_3)/2)));
shbubble_radii_6_23 = sqrt((0.3*1.667*10^(-5))/(pi*0.01*((shLbbf_23_6+shRbbf_23_6)/2)));
shbubble_radii_6_24 = sqrt((0.3*1.667*10^(-5))/(pi*0.01*((shLbbf_24_6+shRbbf_24_6)/2)));
shbubble_radii_6_15 = sqrt((0.3*1.667*10^(-5))/(pi*0.01*((shLbbf_15_6+shRbbf_15_6)/2)));
shbubble_radii_9_23 = sqrt((0.4*1.667*10^(-5))/(pi*0.01*((shLbbf_23_9+shRbbf_23_9)/2)));
shbubble_radii_9_24 = sqrt((0.4*1.667*10^(-5))/(pi*0.01*((shLbbf_24_9+shRbbf_24_9)/2)));
shbubble_radii_9_15 = sqrt((0.4*1.667*10^(-5))/(pi*0.01*((shLbbf_15_9+shRbbf_15_9)/2)));

%%
%Bubble Radii VS Ca
figure
plot(Caw_3,wbubble_radii_3_23,'rd',Caw_6,wbubble_radii_6_23,'rd',Caw_9,wbubble_radii_9_23,'rd','MarkerSize',14)
hold on
plot(Caw_3,wbubble_radii_3_24,'ro',Caw_6,wbubble_radii_6_24,'ro',Caw_9,wbubble_radii_9_24,'ro','MarkerSize',14)
hold on
plot(Caw_3,wbubble_radii_3_15,'rs',Caw_6,wbubble_radii_6_15,'rs',Caw_9,wbubble_radii_9_15,'rs','MarkerSize',14)
hold on
%lgd = legend('ports 2+3','ports 2+3','ports 2+3','ports 2+4','ports 2+4','ports 2+4','ports 1+5','ports 1+5','ports 1+5','Location','southeast','NumColumns',3,'FontSize',12);

plot(Casl_3,slbubble_radii_3_23,'bd',Casl_6,slbubble_radii_6_23,'bd',Casl_9,slbubble_radii_9_23,'bd','MarkerSize',14)
hold on
plot(Casl_3,slbubble_radii_3_24,'bo',Casl_6,slbubble_radii_6_24,'bo',Casl_9,slbubble_radii_9_24,'bo','MarkerSize',14)
hold on
plot(Casl_3,slbubble_radii_3_15,'bs',Casl_6,slbubble_radii_6_15,'bs',Casl_9,slbubble_radii_9_15,'bs','MarkerSize',14)
hold on
%lgd = legend('ports 2+3,3 lpm','ports 2+3,6 lpm','ports 2+3,9 lpm','ports 2+4,3 lpm','ports 2+4,6 lpm','ports 2+4,9 lpm','ports 1+5,3 lpm','ports 1+5,6 lpm','ports 1+5,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);

plot(Cash_3,shbubble_radii_3_23,'kd',Cash_6,shbubble_radii_6_23,'kd',Cash_9,shbubble_radii_9_23,'kd','MarkerSize',14)
hold on
plot(Cash_3,shbubble_radii_3_24,'ko',Cash_6,shbubble_radii_6_24,'ko',Cash_9,shbubble_radii_9_24,'ko','MarkerSize',14)
hold on
plot(Cash_3,shbubble_radii_3_15,'ks',Cash_6,shbubble_radii_6_15,'ks',Cash_9,shbubble_radii_9_15,'ks','MarkerSize',14)
%lgd = legend('ports 2+3,3 lpm','ports 2+3,6 lpm','ports 2+3,9 lpm','ports 2+4,3 lpm','ports 2+4,6 lpm','ports 2+4,9 lpm','ports 1+5,3 lpm','ports 1+5,6 lpm','ports 1+5,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);

ax = gca;
ax.FontSize = 20;
xlabel('Ca')
ylabel('Bubble Radii')
xlim([-10 200])
ylim([0 0.03])
%lgd = legend('ports 2+3,3 lpm','ports 2+3,6 lpm','ports 2+3,9 lpm','ports 2+4,3 lpm','ports 2+4,6 lpm','ports 2+4,9 lpm','ports 1+5,3 lpm','ports 1+5,6 lpm','ports 1+5,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);
saveas(gcf,'bubbleradiiVsCa.fig')
saveas(gcf,'bubbleradiiVsCa.jpg')
%%
% max/min ratio vs bubbleradiii/dsep
dsep23= 0.02; %m
dsep24= 0.04; %m
dsep15= 0.08; %m

figure
plot(wbubble_radii_3_23/dsep23,rw_23_3,'rd',wbubble_radii_6_23/dsep23,rw_23_6,'bd',wbubble_radii_9_23/dsep23,rw_23_9,'kd','MarkerSize',14)
hold on
plot(wbubble_radii_3_24/dsep24,rw_24_3,'ro',wbubble_radii_6_24/dsep24,rw_24_6,'bo',wbubble_radii_9_24/dsep24,rw_24_9,'ko','MarkerSize',14)
hold on
plot(wbubble_radii_3_15/dsep15,rw_15_3,'rs',wbubble_radii_6_15/dsep15,rw_15_6,'bs',wbubble_radii_9_15/dsep15,rw_15_9,'ks','MarkerSize',14)
hold on

plot(slbubble_radii_3_23/dsep23,rsl_23_3,'rd',slbubble_radii_6_23/dsep23,rsl_23_6,'bd',slbubble_radii_9_23/dsep23,rsl_23_9,'kd','MarkerSize',14)
hold on
plot(slbubble_radii_3_24/dsep24,rsl_24_3,'ro',slbubble_radii_6_24/dsep24,rsl_24_6,'bo',slbubble_radii_9_24/dsep24,rsl_24_9,'ko','MarkerSize',14)
hold on
plot(slbubble_radii_3_15/dsep15,rsl_15_3,'rs',slbubble_radii_6_15/dsep15,rsl_15_6,'bs',slbubble_radii_9_15/dsep15,rsl_15_9,'ks','MarkerSize',14)
hold on

plot(shbubble_radii_3_23/dsep23,rsh_23_3,'rd',shbubble_radii_6_23/dsep23,rsh_23_6,'bd',shbubble_radii_9_23/dsep23,rsh_23_9,'kd','MarkerSize',14)
hold on
plot(shbubble_radii_3_24/dsep24,rsh_24_3,'ro',shbubble_radii_6_24/dsep24,rsh_24_6,'bo',shbubble_radii_9_24/dsep24,rsh_24_9,'ko','MarkerSize',14)
hold on
plot(shbubble_radii_3_15/dsep15,rsh_15_3,'rs',shbubble_radii_6_15/dsep15,rsh_15_6,'bs',shbubble_radii_9_15/dsep15,rsh_15_9,'ks','MarkerSize',14)

ax = gca;
ax.FontSize = 20;
xlabel('bubble radii/dsep')
ylabel('Max/Min Cross Correlation')
%xlim([0 2500])
ylim([0.4 2])
%lgd = legend('dsep=20,3 lpm','dsep=20,6 lpm','dsep=20,9 lpm','dsep=40,3 lpm','dsep=40,6 lpm','dsep=40,9 lpm','dsep=80,3 lpm','dsep=80,6 lpm','dsep=80,9 lpm','Location','southeast','NumColumns',3,'FontSize',12);
saveas(gcf,'RatioVsbubbleradii.fig')
saveas(gcf,'RatioVsbubbleradii.jpg')
