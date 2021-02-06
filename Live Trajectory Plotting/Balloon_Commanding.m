%% Run Parallel Simulations 
model = 'BalloonDrift';
load_system(model);
TimeRanges = [5, 10, 20];
TimeRanges_sec = TimeRanges*60;

numSims = 200;
SimTime = max(TimeRanges_sec); %s
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

for i = 1:numSims
Vwind_scaleX = normrnd(0,0.2);
Vwind_scaleY = normrnd(0,0.2);
simIn(i) = simIn(i).setBlockParameter([model '/Vx'], 'value', num2str(Vxo));
simIn(i) = simIn(i).setBlockParameter([model '/Vy'], 'value', num2str(Vyo));
simIn(i) = simIn(i).setBlockParameter([model '/Vz'], 'value', num2str(Vzo));
simIn(i) = simIn(i).setBlockParameter([model '/Xo'], 'value', num2str(Xo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Yo'], 'value', num2str(Yo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Zo'], 'value', num2str(Zo_position));
simIn(i) = simIn(i).setBlockParameter([model '/WindScale_X'], 'value', num2str(Vwind_scaleX));
simIn(i) = simIn(i).setBlockParameter([model '/WindScale_Y'], 'value', num2str(Vwind_scaleY));
end

simOut = parsim(simIn,'ShowProgress', 'on') %run simulations and output to object

%% Data Processing
for i=1:numSims
    time = simOut(i).find('Balloon_Time');
    ALP_X = simOut(i).find('Balloon_X');
    ALP_Y = simOut(i).find('Balloon_Y');
    ALP_Z = simOut(i).find('Balloon_Z');
    for j = 1:length(TimeRanges)
        t = round(length(time)/TimeRanges_sec(length(TimeRanges))*TimeRanges_sec(j));
        Balloon_RangeX(i,j) = ALP_X(t);
        Balloon_RangeY(i,j) = ALP_Y(t);
        Balloon_RangeZ(i,j) = ALP_Z(t);
    end
%     if mod(i,4) == 0
%     figure(1)
%     hold on
%     plot3(ALP_X,ALP_Y,ALP_Z)
%     view(45,45)
%     end
end

for i=1:length(time)
    if ALP_Z > balloon_float
        Time_to_Apogee = time(i)
    end
end


%% Plotting
figure(2)
s = length(TimeRanges);
subplot(s,s,[1 (s-1)*s])
if max(Balloon_RangeX,[],'all') > max(Balloon_RangeY,[],'all')
    grid_max = max(Balloon_RangeX,[],'all');
else
    grid_max = max(Balloon_RangeY,[],'all');
end

grid_res = 40;
grid_vec = linspace(0,grid_max,grid_res);
grid on
hold on
for i = 1:length(TimeRanges)
[scatplot, centers] = hist3([Balloon_RangeX(:,i), Balloon_RangeY(:,i)],{grid_vec grid_vec});
p=pcolor(centers{:}, scatplot);
p.FaceColor = 'interp';
set(p, 'EdgeColor', 'none');
alpha color
end
colorbar
scatter(0,0,'x','LineWidth', 3,'MarkerEdgeColor','k');

for i=1:length(TimeRanges)
        radius(:,i) = (Balloon_RangeX(:,i).^2+Balloon_RangeY(:,i).^2).^0.5;
        radius_mean = mean(radius(:,i));
        viscircles([0 0],radius_mean,'LineWidth',0.75,'LineStyle','--');
end
xlim([-100 max(Balloon_RangeX,[],'all')]);
ylim([-100 max(Balloon_RangeX,[],'all')]);
xlabel('X displacement [m]');
ylabel('Y displacement [m]');
title('RLV Scatter Plot') ;

for j=1:s
    subplot(s,s,(s-1)*s+j)
    histogram(radius(:,j)./1000)
    str = strcat('Radius [km] + ', num2str(TimeRanges(j)), ' Minutes');
    xlabel(str)
end



