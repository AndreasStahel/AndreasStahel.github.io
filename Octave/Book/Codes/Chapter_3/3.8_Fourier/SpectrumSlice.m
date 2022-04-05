level = 1; %  level = 3000
% set level before calling this script

N2 = 11;     % analyze 2^N2 points
Ndisp = 50;  % display the first Ndisp contributions

PeriodIn = timedataIn(2^N2)-timedataIn(1);
frequencies = linspace(1,Ndisp,Ndisp)/PeriodIn;

adata  = ampdataOut(level:level+2^N2-1);
fftOut = fft(adata);
spectrum = abs(fftOut(2:Ndisp+1));
figure(1); plot(frequencies,spectrum)
           xlabel('frequency');  ylabel('amplitude')

