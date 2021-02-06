function ALP_readinserial(read)  
% function ALP_readinserial(read)
% Function to read in data from serial device.  While read is true (1) the
% program will run, otherwise if it is false (0) the program will not run.
% Insert the port name in s0 = serial('port') for the port receiving 
% signals.
%
% While loop is set up to read last 300 lines of transmitted data to not
% overload the program.  This will equate to about the last five minutes of
% mission time.
%
% Finding port name for Mac OS:
% Connect USB to computer.  Go to terminal and type ls /dev/tty.usb* then hit 
% enter.  Enter the name associated with the USB port.  
% Exmample: /dev/tty.usbmodem14101
%
% Finding port name for Windows OS:
% Connect USB to computer.  In MATLAB Command Window type instrfindall and 
% use the COM## as the port name. Example: COM1


delete(instrfindall)
s0 = serial('/dev/tty.usbmodem14101');
fopen(s0);


while read
    raw_data = fscanf(s0,'%s',[1, 10]);
    dlmwrite('ALP.txt',raw_data,'-append','delimiter','')
   ALP_Data = zeros(300,23);
   for i = 1:299
       ALP_Data(i,:)= ALP_Data(i+1);
   end
   m = size(dlmread('ALP.txt'));
   a = m(1)-1;
   ALP_Data(end,:) = dlmread('ALP.txt',',',a,0);


ALP_Telemetry_Update(handles,ALP_Data)
end