%filename1 = 'SC1007.TXT';
%filename2 = 'SC2007.TXT';
filename1 = 'SC1001.TXT';
filename2 = 'SC2001.TXT';

indata = dlmread(filename1,',',5,0); % read data, starting row 6
k = length(indata);
disp(sprintf('Number of datapoints is  %i',k))
timedataIn = indata(:,1);
ampdataIn  = indata(:,2);

TimeIn = timedataIn(k)-timedataIn(1)
FreqIn = 1/(timedataIn(2)-timedataIn(1))
figure(1); plot(timedataIn,ampdataIn)
           title('Amplitude of input'); grid on
           xlabel('Time'); ylabel('Amplitude')


dom = 1070:1170;  %  choose the good domain by zooming in
figure(3); plot(timedataIn(dom),ampdataIn(dom))
           title('Amplitude of input'); grid on
           xlabel('Time'); ylabel('Amplitude')

indata = dlmread(filename2,',',5,0); % read data, starting row 6
k = length(indata);
disp(sprintf('Number of datapoints is  %i',k))
timedataOut = indata(:,1);
ampdataOut  = indata(:,2);
clear indata

TimeOut = timedataOut(k)-timedataOut(1)
FreqOut = 1/(timedataOut(2)-timedataOut(1))
figure(2); plot(timedataOut,ampdataOut)
           title('Amplitude of response');
           xlabel('Time'); ylabel('Amplitude'); grid on
