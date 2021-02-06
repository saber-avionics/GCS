spaceportlat = 32.991;
spaceportlon =-106.975;
delta =0.5;
latlim = [spaceportlat-delta spaceportlat+delta]; 
lonlim = [spaceportlon-delta spaceportlon+delta];

% Example 2 Test
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

figure
usamap(latlim, lonlim)
% framem off; mlabel off; plabel off; gridm off
geoshow(double(Z), R, 'DisplayType', 'surface', 'CData', A);
plot3m(32.991,-106.975,1401, 'Marker', '+','MarkerSize',20,'Color', 'red')
daspectm('m',2)
title({'Space Port America', 'USGS NED and Ortho Image', 'Height Scale x2'},'FontSize',8);
% axis vis3d
view(3)

%% Run Parallel Simulations 
model = 'BalloonDrift';
load_system(model);
TimeRanges = [5, 15, 30];
TimeRanges_sec = TimeRanges*60;

numSims = 400;
SimTime = max(TimeRanges_sec); %s
simIn(1:numSims) = Simulink.SimulationInput(model);
% Set varabiles for each sim that is run
set_param(model, 'StopTime', num2str(SimTime));
save_system;

balloon_float = 15000;
Xo_position = 100; %m
Yo_position = 200; %m
Zo_position = 0; %m
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
        Balloon_RangeX(i,j) = 360*ALP_X(t)/(2*3.14*6371000) + spaceportlat;
        Balloon_RangeY(i,j) = 360*ALP_Y(t)/(2*3.14*6371000) + spaceportlon;
        Balloon_RangeZ(i,j) = ALP_Z(t)+1400;
    end
    if mod(i,40) == 0
        Pos_Lat = 360*ALP_X/(2*3.14*6371000) + spaceportlat;
        Pos_Lon = 360*ALP_Y/(2*3.14*6371000) + spaceportlon;
        Altitude= ALP_Z+1400;
        hold on
        plot3m(Pos_Lat,Pos_Lon,Altitude, 'k','LineWidth',1.5)
    end
end


for i=1:length(time)
    if ALP_Z > balloon_float
        Time_to_Apogee = time(i)
    end
end


%% Plotting

s = length(TimeRanges);
if max(Balloon_RangeX,[],'all') > max(Balloon_RangeY,[],'all')
    grid_max = max(Balloon_RangeX,[],'all');
else
    grid_max = max(Balloon_RangeY,[],'all');
end

grid_res = 80;
grid_lat = linspace(latlim(1),latlim(2),grid_res);
grid_lon = linspace(lonlim(1),lonlim(2),grid_res);
for i = 1:length(TimeRanges)
[scatplot, centers] = hist3([Balloon_RangeX(:,i), Balloon_RangeY(:,i)],{grid_lat grid_lon});
p = pcolorm(centers{:}, scatplot);
set(p, 'EdgeColor', 'none');
offset = 3000;
set(p, 'ZData', get(p, 'ZData') + offset);
set(p, 'AlphaData', get(p, 'Cdata'))
set(p, 'FaceAlpha', 'flat')
p.AlphaDataMapping = 'none'
end
caxis([1 max(get(p, 'Cdata'),[],'all')])
colormap(winter)
colorbar
% scatter(0,0,'x','LineWidth', 3,'MarkerEdgeColor','k');

% for i=1:length(TimeRanges)
%         radius(:,i) = (Balloon_RangeX(:,i).^2+Balloon_RangeY(:,i).^2).^0.5;
%         radius_mean = mean(radius(:,i));
%         viscircles([0 0],radius_mean,'LineWidth',0.75,'LineStyle','--');
% end
% xlim([-100 max(Balloon_RangeX,[],'all')]);
% ylim([-100 max(Balloon_RangeX,[],'all')]);
% xlabel('X displacement [m]');
% ylabel('Y displacement [m]');
% title('RLV Scatter Plot') ;
% 
% for j=1:s
%     subplot(s,s,(s-1)*s+j)
%     histogram(radius(:,j)./1000)
%     str = strcat('Radius [km] + ', num2str(TimeRanges(j)), ' Minutes');
%     xlabel(str)
% end


