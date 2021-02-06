%% Run Parallel Simulations 
%% ALP Recovery
model = 'Recover_Sim';
load_system(model);

numSims = 200;
SimTime = 10000;
simIn(1:numSims) = Simulink.SimulationInput(model);
% Set varabiles for each sim that is run
set_param(model, 'StopTime', num2str(SimTime));
save_system;

balloon_float = 15000;
Xo_position = 100; %m
Yo_position = 200; %m
Zo_position = 300; %m
Vxo = 1; %m/s
Vyo = 1; %m/s
Vzo = 1; %m/s
Mass = 45;
Cd_X_Y = 0.5;
Downward_Cd = 0.5;
DroqueChute_CrossSection = 0.5;
PrimaryChute_CrossSection = 3;
DroqueChute_SideSection = 0.5;
PrimaryChute_SideSection = 0.5;

for i = 1:numSims
simIn(i) = simIn(i).setBlockParameter([model '/Vx'], 'value', num2str(Vxo));
simIn(i) = simIn(i).setBlockParameter([model '/Vy'], 'value', num2str(Vyo));
simIn(i) = simIn(i).setBlockParameter([model '/Vz'], 'value', num2str(Vzo));
simIn(i) = simIn(i).setBlockParameter([model '/Xo'], 'value', num2str(Xo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Yo'], 'value', num2str(Yo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Zo'], 'value', num2str(Zo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Mass'], 'value', num2str(Mass));
simIn(i) = simIn(i).setBlockParameter([model '/Cd(X_Y)'], 'value', num2str(Cd_X_Y));
simIn(i) = simIn(i).setBlockParameter([model '/Downward Cd'], 'value', num2str(Downward_Cd));
simIn(i) = simIn(i).setBlockParameter([model '/Drogue Chute Cross Section'], 'value', num2str(DroqueChute_CrossSection));
simIn(i) = simIn(i).setBlockParameter([model '/Primary Chute Cross Section'], 'value', num2str(PrimaryChute_CrossSection));
simIn(i) = simIn(i).setBlockParameter([model '/Drogue Chute Side Section'], 'value', num2str(DroqueChute_SideSection));
simIn(i) = simIn(i).setBlockParameter([model '/Primary Chute Side Section'], 'value', num2str(PrimaryChute_SideSection));
end

simOut = parsim(simIn,'ShowProgress', 'on') %run simulations and output to object

%% Data Processing
for i=1:numSims
    pos_X = simOut(i).find('RVY_landing_X');
    pos_Y = simOut(i).find('RVY_landing_Y');
    pos_Z = simOut(i).find('RVY_landing_Z');
    RangeX(i) = pos_X(end);
    RangeY(i) = pos_Y(end);
end

%% Data Plotting

figure()
grid on
hold on
[scatplot, centers] = hist3([RangeX(:), RangeY(:)],[10 10]);
imagesc(centers{:}, scatplot);
alpha color
colorbar
scatter(0,0,'x','LineWidth', 3,'MarkerEdgeColor','k');
xlabel('X displacement [m]');
ylabel('Y displacement [m]');
title('ALP Scatter Plot') ;

%% RLV Emergency Recovery
model = 'Recover_Sim';
load_system(model);

numSims = 200;
SimTime = 10000;
simIn(1:numSims) = Simulink.SimulationInput(model);
% Set varabiles for each sim that is run
set_param(model, 'StopTime', num2str(SimTime));
save_system;

Vxo = 1; %m/s
Vyo = 1; %m/s
Vzo = 1; %m/s
Mass = 25;
Cd_X_Y = 0.5;
Downward_Cd = 0.5;
DroqueChute_CrossSection = 0.5;
PrimaryChute_CrossSection = 3;
DroqueChute_SideSection = 0.5;
PrimaryChute_SideSection = 0.5;


for i = 1:numSims
simIn(i) = simIn(i).setBlockParameter([model '/Vx'], 'value', num2str(Vxo));
simIn(i) = simIn(i).setBlockParameter([model '/Vy'], 'value', num2str(Vyo));
simIn(i) = simIn(i).setBlockParameter([model '/Vz'], 'value', num2str(Vzo));
simIn(i) = simIn(i).setBlockParameter([model '/Xo'], 'value', num2str(Xo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Yo'], 'value', num2str(Yo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Zo'], 'value', num2str(Zo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Mass'], 'value', num2str(Mass));
simIn(i) = simIn(i).setBlockParameter([model '/Cd(X_Y)'], 'value', num2str(Cd_X_Y));
simIn(i) = simIn(i).setBlockParameter([model '/Downward Cd'], 'value', num2str(Downward_Cd));
simIn(i) = simIn(i).setBlockParameter([model '/Drogue Chute Cross Section'], 'value', num2str(DroqueChute_CrossSection));
simIn(i) = simIn(i).setBlockParameter([model '/Primary Chute Cross Section'], 'value', num2str(PrimaryChute_CrossSection));
simIn(i) = simIn(i).setBlockParameter([model '/Drogue Chute Side Section'], 'value', num2str(DroqueChute_SideSection));
simIn(i) = simIn(i).setBlockParameter([model '/Primary Chute Side Section'], 'value', num2str(PrimaryChute_SideSection));
end

simOut = parsim(simIn,'ShowProgress', 'on') %run simulations and output to object

%% Data Processing
for i=1:numSims
    pos_X = simOut(i).find('RVY_landing_X');
    pos_Y = simOut(i).find('RVY_landing_Y');
    pos_Z = simOut(i).find('RVY_landing_Z');
    RangeX(i) = pos_X(end);
    RangeY(i) = pos_Y(end);
end

%% Data Plotting

figure()
grid on
hold on
[scatplot, centers] = hist3([RangeX(:), RangeY(:)],[10 10]);
imagesc(centers{:}, scatplot);
alpha color
colorbar
scatter(0,0,'x','LineWidth', 3,'MarkerEdgeColor','k');
xlabel('X displacement [m]');
ylabel('Y displacement [m]');
title('RLV Scatter Plot') ;
 
