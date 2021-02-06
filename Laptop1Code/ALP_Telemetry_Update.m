function ALP_Telemetry_Update(handles,ALP_Data)
% function ALP_Telemetry_Update(handles,ALP_Data)
% Function to update telemetry values in the GUI.

hold(handles.Plot_Altitude, 'off')
hold(handles.Plot_Pressure, 'off')
hold(handles.Plot_Temperature, 'off')
hold(handles.Plot_Acceleration, 'off')
hold(handles.Plot_GPS, 'off')
hold(handles.Plot_Tilt_Position, 'off')

% Plotting data
plot(handles.Plot_Altitude, ALP_Data(:,1), ALP_Data(:,3), 'Color', 'Black')
xlabel(handles.Plot_Altitude, 'seconds'), ylabel(handles.Plot_Altitude, 'meters')
grid on

plot(handles.Plot_Pressure, ALP_Data(:,1), ALP_Data(:,4), 'Color', 'Black')
xlabel(handles.Plot_Pressure, 'seconds'), ylabel(handles.Plot_Pressure, 'Pa')
grid on

plot(handles.Plot_Temperature, ALP_Data(:,1), ALP_Data(:,5), 'Color', 'Black')
xlabel(handles.Plot_Temperature, 'seconds'), ylabel(handles.Plot_Temperature, 'Celcius')
grid on

[X,Y,Z]=ALP_plot_tilt_formula(ALP_Data(end,14),ALP_Data(end,15),ALP_Data(end,16))
quiver3(handles.Plot_Tilt_Position,0,0,0,X,Y,Z)
xlabel(handles.Plot_Tilt_Position, ' yaw'), ylabel(handles.Plot_Tilt_Position, ' pitch')
grid on

quiver3(handles.Plot_Acceleration,0,0,0,ALP_Data(end,18),ALP_Data(end,19),ALP_Data(end,20))
xlabel(handles.Plot_Acceleration,'Acceleration m/s^2'),...
    ylabel(handles.Plot_Acceleration,'Acceleration m/s^2')
grid on

% GPS Location is plotted with Spaceport of America at origin.  Yellow 
% dashed line is the cautionary zone where vehicle is close to limits of
% losing radio contact or near controlled airspace limits.  The cos/sin
% amplitude is based on horizontal distance that 1°?111km
% Variables:
%   lat = latitude position with respect to Spaceport of America
%   long = longitude position with respect to Spaceport of America
theta=0:0.0001:2*pi;
lat = 32.9904-ALP_Data(end,11);
long = 106.9750-ALP_Data(end,12);
% lim1 = insert radial limitation distance after converting to degrees
% lim2 = insert radial limitation distance after converting to degrees
plot(handles.Plot_GPS,...
    lim1*cos(theta),lim1*sin(theta),'y-',...
    lim2*cos(theta),lim2*sin(theta),'r',...
    lat, long, 'k*')
xlabel(handles.Plot_GPS, 'Latitude °'),ylabel(handles.Plot_GPS, 'Longitude °')
legend('CAUTION','WARNING','Vehicle','Location','best')
xlim(handles.Plot_GPS,[0 0.1])
ylim(handles.Plot_GPS,[0 0.1]),grid on

% Updating display values
set(handles.Mission_Time,'String',ALP_Data(end,1));
set(handles.Packet_Count,'String',ALP_Data(end,2));
set(handles.Disp_Alt,'String',ALP_Data(end,3));
set(handles.Disp_Press,'String',ALP_Data(end,4));
set(handles.Battery_Temp,'String',ALP_Data(end,5));
set(handles.Motor_Temp,'String',ALP_Data(end,6));
set(handles.Board_Temp,'String',ALP_Data(end,7));
set(handles.Voltage,'String',ALP_Data(end,8));
set(handles.Current,'String',ALP_Data(end,9));
set(handles.GPS_Time,'String',ALP_Data(end,10));

gps_lat_long = [ALP_Data(end,11),ALP_Data(end,12)];
set(handles.Disp_GPS,'String',gps_lat_long);

set(handles.GPS_Sat,'String',ALP_Data(end,13));

position_tilt = [ALP_Data(end,14),ALP_Data(end,15),ALP_Data(end,16)];
set(handles.Disp_Position,'String',position_tilt);

set(handles.Software_State,'String',ALP_Data(end,17));

acceleration_vector = [ALP_Data(end,18),ALP_Data(end,19),ALP_Data(end,20)];
set(handles.Disp_Accel,'String',acceleration_vector);

mag_vector = [ALP_Data(end,21),ALP_Data(end,22),ALP_Data(end,23)];
set(handles.Magnetic,'String',mag_vector);

% updating confirmation of transmission received by vehicle.
confirmation = ALP_Data(end,24);
if confirmation == 'launch'
    set(handles.Launch_Confirmed,'Color','Green')
elseif confirmation == 'chutes'
    set(handles.Chutes_Deployed_Confirmed,'Color','Green')
elseif confirmation == 'abort'
    set(handles.Abort_Confirmed,'Color','Green')
else
    set(handles.Launch_Confirmed,'Color','Black'),...
        set(handles.Chutes_Deployed_Confirmed,'Color','Black'),...
        set(handles.Abort_Confirmed,'Color','Black')
end

drawnow
end