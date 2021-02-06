%% Run Parallel Simulations 
model = 'Rocket';
load_system(model);

numSims = 600;
SimTime = 1000; %s
simIn(1:numSims) = Simulink.SimulationInput(model);
% Set varabiles for each sim that is run
set_param(model, 'StopTime', num2str(SimTime));
save_system;

Xo_position = 100; %m
Yo_position = 200; %m
Zo_position = 25000; %m
Vxo = 1; %m/s
Vyo = 1; %m/s
Vzo = 1; %m/s


for i = 1:numSims
Vwind_scaleX = normrnd(0,0.2);
Vwind_scaleY = normrnd(0,0.2);
RanPitch(i) = normrnd(0,0.025);
RanYaw(i) = normrnd(0,0.025);
simIn(i) = simIn(i).setBlockParameter([model '/RanPitch'], 'value', num2str(RanPitch(i)));
simIn(i) = simIn(i).setBlockParameter([model '/RanYaw'], 'value', num2str(RanYaw(i)));
simIn(i) = simIn(i).setBlockParameter([model '/Vx'], 'value', num2str(Vxo));
simIn(i) = simIn(i).setBlockParameter([model '/Vy'], 'value', num2str(Vyo));
simIn(i) = simIn(i).setBlockParameter([model '/Xo'], 'value', num2str(Xo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Yo'], 'value', num2str(Yo_position));
simIn(i) = simIn(i).setBlockParameter([model '/Zo'], 'value', num2str(Zo_position));
simIn(i) = simIn(i).setBlockParameter([model '/WindScale_X'], 'value', num2str(Vwind_scaleX));
simIn(i) = simIn(i).setBlockParameter([model '/WindScale_Y'], 'value', num2str(Vwind_scaleY));
end

simOut = parsim(simIn,'ShowProgress', 'on') %run simulations and output to object

%% Setup and Load the Map
spaceportlat = 32.991;
spaceportlon =-106.975;
delta = 0.5;
latlim = [spaceportlat-delta spaceportlat+delta]; 
lonlim = [spaceportlon-delta spaceportlon+delta];

numberOfAttempts = 5;
attempt = 0;
info = [];
serverURL = 'http://basemap.nationalmap.gov/ArcGIS/services/USGSImageryOnly/MapServer/WMSServer?';
while(isempty(info))
    try
        info = wmsinfo(serverURL);
        orthoLayer = info.Layer(1);
    catch e 
        
        attempt = attempt + 1;
        if attempt > numberOfAttempts
            throw(e);
        else
            fprintf('Attempting to connect to server:\n"%s"\n', serverURL)
        end        
    end
end
imageLength = 2024;
ortho = wmsfind('/USGSImageryTopo/','SearchField','serverurl'); 

layers = wmsfind('data.worldwind', 'SearchField', 'serverurl');
us_ned = layers.refine('usgs ned 30');
imageHeight = 1075;
imageWidth = 1075;

[Z, R] = wmsread(us_ned, 'ImageFormat', 'image/bil', ...
    'Latlim', latlim, 'Lonlim', lonlim, ...
    'ImageHeight', imageHeight, 'ImageWidth', imageWidth);
A = wmsread(ortho, 'Latlim', latlim, 'Lonlim', lonlim, ...
   'ImageHeight', imageHeight, 'ImageWidth', imageWidth);
ortho = wmsfind('/USGSImageryTopo/','SearchField','serverurl'); 

figure()
subplot(3,3,[2 3 5 6 8 9])
usamap(latlim, lonlim)
geoshow(double(Z), R, 'DisplayType', 'surface', 'CData', A);
daspectm('m',2)
title({'Space Port America - USGS NED and Ortho Image - Height Scale x2'},'FontSize',12);
view(3)

%% Data Processing
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
    
%      if mod(i,6) == 0
%         Pos_Lat = 360*RLV_Ballisitc_X/(2*3.14*6371000) + spaceportlat;
%         Pos_Lon = 360*RLV_Ballisitc_Y/(2*3.14*6371000) + spaceportlon;
%         Altitude= RLV_Z+1400;
%         hold on
%         plot3m(Pos_Lat,Pos_Lon,Altitude, 'b','LineWidth',1.5)
%         
%     end
    numTrajPlots = 5;
    if mod(i,round(numSims/5)) == 0
        Pos_Lat = 360*RLV_X/(2*3.14*6371000) + spaceportlat;
        Pos_Lon = 360*RLV_Y/(2*3.14*6371000) + spaceportlon;
        Altitude= RLV_Z+1400;
        Altitude(1) = Zo_position;
        hold on
        plot3m(Pos_Lat,Pos_Lon,Altitude, 'k','LineWidth',1.5)
    end
end


%% Sim Data Plotting over map
grid_res = 40;
grid_lat = linspace(latlim(1),latlim(2),grid_res);
grid_lon = linspace(lonlim(1),lonlim(2),grid_res);
Pos_Lat = 360*RangeX/(2*3.14*6371000) + spaceportlat;
Pos_Lon = 360*RangeY/(2*3.14*6371000) + spaceportlon;
[scatplot, centers] = hist3([Pos_Lat(:), Pos_Lon(:)],{grid_lat grid_lon});
p = pcolorm(centers{:}, scatplot);
set(p, 'EdgeColor', 'none');
offset = 3000;
set(p, 'ZData', get(p, 'ZData') + offset);
set(p, 'AlphaData', get(p, 'Cdata'))
set(p, 'FaceAlpha', 'flat')
p.AlphaDataMapping = 'none';
caxis([1 max(get(p, 'Cdata'),[],'all')])
colormap(winter)
colorbar

plot3m(32.991,-106.975,offset+1, 'Marker', '+','MarkerSize',20,'Color', 'red')
plot3m(32.991,-106.975,Zo_position, 'Marker', 'x','MarkerSize',8,'Color', 'blue')


%% Side panel plots
subplot(3,3,1)
histogram(MaxAlt/1000)
xlabel('Altitude [km]')
title('Altitude Distribution')
subplot(3,3,4)
histogram(rad2deg(RanPitch))
xlabel('Launch Pitch [deg]')
title('Pitch Distribution')
subplot(3,3,7)
histogram(rad2deg(RanYaw))
xlabel('Launch Yaw [deg]')
title('Yaw Distribution')
