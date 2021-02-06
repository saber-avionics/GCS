spaceportlat = 32.991;
spaceportlon =-106.975;
delta =0.2;
latlim = [spaceportlat-delta spaceportlat+delta]; 
lonlim = [spaceportlon-delta spaceportlon+delta];
% numberOfAttempts = 5;
% attempt = 0;
% info = [];
% serverURL = 'http://basemap.nationalmap.gov/ArcGIS/services/USGSImageryOnly/MapServer/WMSServer?';
% while(isempty(info))
%     try
%         info = wmsinfo(serverURL);
%         orthoLayer = info.Layer(1);
%     catch e 
%         
%         attempt = attempt + 1;
%         if attempt > numberOfAttempts
%             throw(e);
%         else
%             fprintf('Attempting to connect to server:\n"%s"\n', serverURL)
%         end        
%     end
% end
% imageLength = 1024;
% ortho = wmsfind('/USGSImageryTopo/','SearchField','serverurl'); 
% [A,R] = wmsread(orthoLayer,'Latlim',latlim,'Lonlim',lonlim,'ImageHeight',imageLength,'ImageWidth',imageLength);
% Z = wmsread(ortho, 'Latlim', latlim, 'Lonlim', lonlim,'ImageHeight', imageLength, 'ImageWidth', imageLength);
% axesm('utm','Zone',utmzone(latlim, lonlim),'MapLatlimit',latlim,'MapLonlimit', lonlim,'Geoid', wgs84Ellipsoid)
% geoshow(A,R)
% 
% % axis off
% title({'San Francisco','Northern Section of Golden Gate Bridge'})
% geoshow(32.991,-106.975,'DisplayType', 'Point', 'Marker', '+', 'Color', 'red')


%% Example 2 Test

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
geoshow(32.991,-106.975,'DisplayType', 'Point', 'Marker', '+', 'Color', 'red')
daspectm('m',2)
title({'Space Port America', 'USGS NED and Ortho Image', 'Height Scale x2'},'FontSize',8);
% axis vis3d
view(3)


x_lat = linspace(spaceportlat,spaceportlat+0.01,1000);
y_lon = linspace(spaceportlon,spaceportlon+0.01,1000);
aa = linspace(0,100,500);
zz=[linspace(0,10000,500) linspace(10000,0,500)];
% hold on
plot3m(x_lat,y_lon,zz+1400, 'o', 'MarkerSize', 3,...
              'MarkerFaceColor','r')

