function ALP_sendcommands(deploy_chutes,abort_plan)
% function ALP_sendcommands(deploy_chutes,abort_plan)
% ALP_sendcommands: Setts up link to radio to send a string to perform an
% action on the ALP to deploy chutes, or abort.
%
% Inputs:
%   deploy_chutes = logic value 1/0 input from GUI to deploy chutes via
%                   push button.
%   abort_plan = logic value 0/1 input from GUI to abort via push 
%                button.
%
% Insert the port name in s0 = serial('port') for the port sending signals 
% to vehicle. 
%
% Finding port name for Mac OS:
% Go to terminal and type ls /dev/tty.usb* then hit enter.  Enter the name
% associated with the USB port.  Exmample: /dev/tty.usbmodem14101
%
% Finding port name for Windows OS:
% Windows can SUCK IT!!!

s1 = serial('port');
fopen(s1);

if deploy_chutes == 1
    dlmwrite('ALP_commands.txt','chutes')
end
if abort_plan == 1
    dlmwrite('ALP_commands.txt','abort')
end

while deploy_chutes
    fprintf(s1,'ALP_commands.txt');
end
while abort
    fprintf(s1,'ALP_commands.txt');
end