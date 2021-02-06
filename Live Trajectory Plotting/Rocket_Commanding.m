% Run Parallel Simulations 
model = 'Rocket';
load_system(model);

numSims = 200;
SimTime = 50000; %s
simIn(1:numSims) = Simulink.SimulationInput(model);
%Set varabiles for each sim that is run
set_param(model, 'StopTime', num2str(SimTime));
save_system;

Xo_position = 100; %m
Yo_position = 200; %m
Zo_position = 18000; %m
Vxo = 1; %m/s
Vyo = 1; %m/s

for i = 1:numSims
Vwind_scaleX = normrnd(0,0.2);
Vwind_scaleY = normrnd(0,0.2);
RanPitch = normrnd(0,0.01);
RanYaw = normrnd(0,0.01);
simIn(i) = simIn(i).setBlockParameter([model '/Vx'], 'value', num2str(Vxo));
simIn(i) = simIn(i).setBlockParameter([model '/Vy'], 'value', num2str(Vyo));
simIn(i) = simIn(i).setBlockParameter([model '/Xo'], 'value', num2str(Xo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Yo'], 'value', num2str(Yo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Zo'], 'value', num2str(Zo_position));
simIn(i) = simIn(i).setBlockParameter([model '/RanPitch'], 'value', num2str(RanPitch));
simIn(i) = simIn(i).setBlockParameter([model '/RanYaw'], 'value', num2str(RanYaw));
simIn(i) = simIn(i).setBlockParameter([model '/WindScale_X'], 'value', num2str(Vwind_scaleX));
simIn(i) = simIn(i).setBlockParameter([model '/WindScale_Y'], 'value', num2str(Vwind_scaleY));
end

simOut = parsim(simIn,'ShowProgress', 'on') %run simulations and output to object

%% Data Processing
ExceedHeight = 0;
for i=1:numSims
    RLV_X = simOut(i).find('X');
    RLV_Y =simOut(i).find('Y');
    RLV_Z = simOut(i).find('Z');
    RLV_Ballisitc_X = simOut(i).find('X_ballisitic');
    RLV_Ballisitc_Y =simOut(i).find('Y_ballisitic');
    DynPressure = simOut(i).find('DynPressure');
    Accel = simOut(i).find('Acceleration');
    MaxQ(i) = max(abs(DynPressure));
    MaxA(i) = max(abs(Accel));
    RangeX(i) = RLV_X(end);
    RangeY(i) = RLV_Y(end);
    RangeZ(i) = RLV_Z(end);
    RangeX_ballisitic(i) = RLV_Ballisitc_X(end);
    RangeY_ballisitic(i) = RLV_Ballisitc_Y(end);
    MaxAlt(i) = max(RLV_Z);
    if MaxAlt(i) > 100000
        ExceedHeight = ExceedHeight+1;
    end
end

%% Plotting

figure()
histogram(MaxAlt)

figure()
grid_X = 10;
grid_Y = 10;
grid on
hold on
[scatplot, centers] = hist3([RangeX(:), RangeY(:)],[grid_X grid_Y]);
imagesc(centers{:}, scatplot);
alpha color
alpha scaled
colorbar
landing = max(scatplot,[],'all');
levels = [round(0.4*landing) round(0.68*landing) round(0.9*landing)];
contour(centers{1},centers{2},scatplot,levels,'k','ShowText','on')
scatter(0,0,70,'x','LineWidth', 3,'MarkerEdgeColor','k')
xlabel('X displacement [m]')
ylabel('Y displacement [m]')
title('RLV Scatter Plot') 

figure()
grid_X = 10;
grid_Y = 10;
grid on
hold on
[scatplot, centers] = hist3([RangeX_ballisitic(:), RangeY_ballisitic(:)],[grid_X grid_Y]);
imagesc(centers{:}, scatplot);
alpha color
alpha scaled
colorbar
landing = max(scatplot,[],'all');
levels = [round(0.4*landing) round(0.68*landing) round(0.9*landing)];
contour(centers{1},centers{2},scatplot,levels,'k','ShowText','on')
scatter(0,0,70,'x','LineWidth', 3,'MarkerEdgeColor','k')
xlabel('X displacement [m]')
ylabel('Y displacement [m]')
title('RLV Scatter Plot') 

ExceedHeight/numSims
