N2 = 11;     % analyze 2^N2 points
Ndisp = 50;  % display the first Ndisp contributions

%levels = 1:250:5000;
levels = 1:200:8000;

spectrum = zeros(length(levels),Ndisp);
PeriodIn = timedataIn(2^N2)-timedataIn(1);
frequencies = linspace(1,Ndisp,Ndisp)/PeriodIn;

for kl = 1:length(levels)
  adata  = ampdataOut(levels(kl):levels(kl)+2^N2-1);
  fftOut = fft(adata);
  spectrum(kl,:) = abs(fftOut(2:Ndisp+1));
end%for

figure(3); mesh(frequencies,levels/FreqIn*1000,spectrum)
           xlabel('frequency [Hz]'); ylabel('time [ms]'); zlabel('amplitude')
           title('spectrum as function of starting time');
           view(35,25)

