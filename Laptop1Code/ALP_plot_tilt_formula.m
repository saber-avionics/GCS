function [x,y,z] = ALP_plot_tilt_formula(alpha,beta,gamma)
% Function to calculate points to plot tilt position
% [x,y,z] = plot_tilt_formula(alpha,beta,gamma)
% Inputs:
%   alpha = angle tilt from the x-axis, representing yaw movement.
%   beta = angle tilt from the y-axis, representing pitch movement.
%   gamma = angle tilt from the z-axis, representing angle from verticle
    ...allignment.
% Outputs:
%   x = x-axis coordinate 
%   y = y-axis coordinate
%   z = z-axis coordinate
%
% Currently this is set up for angle to be read in degrees.  If angle is to
% be read in radians then the cos function needs to be editted to cos(x).
% 3.048 is the height of ALP in meters.  This is to display exact image
% height in 3D plot.

x = 3.048*cosd(alpha);
y = 3.048*cosd(beta);
z = 3.048*cosd(gamma);
