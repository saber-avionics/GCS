function [seconds,minutes,hours,clockSeconds,clockMinutes,clockHours] = ALP_Clock(runClock)
% function ALP_Clock(clock)
% function that outputs mission time and UTC time
            
            seconds = 0;
            minutes = 0;
            hours = 0;
            
            format shortg
            c = clock;
            clockSeconds = ceil(c(1,6));
            clockMinutes = c(1,5);
            clockHours = c(1,4);
        
            while runClock == 1
                
                
%                 app.EditField_6.Value = num2str(seconds,'%02.f');
%                 app.EditField_7.Value = num2str(minutes,'%02.f');
%                 app.EditField_8.Value = num2str(hours,'%02.f');
%                 
%                 app.EditField_11.Value = num2str(clockSeconds,'%02.f');
%                 app.EditField_12.Value = num2str(clockMinutes,'%02.f');
%                 app.EditField_13.Value = num2str(clockHours,'%02.f');
                
                seconds = seconds + 1;
                
                if seconds == 60
                    minutes = minutes + 1;
                    seconds = seconds - 60;
                end
                
                if minutes == 60
                    minutes = minutes - 60;
                    hours = hours + 1;
                end
                
                clockSeconds = clockSeconds + 1;
                
                if clockSeconds == 60
                    clockMinutes = clockMinutes + 1;
                    clockSeconds = clockSeconds - 60;
                end
                
                if clockMinutes == 60
                    clockMinutes = clockMinutes - 60;
                    clockHours = clockHours + 1;
                end
                
                
            end  