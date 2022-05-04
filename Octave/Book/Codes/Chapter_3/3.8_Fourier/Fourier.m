N2 = 12;      % analyze 2^N2 points
Ndisp = 200;  % display the first Ndisp frequency contributions

tdata    = timedataIn(1:2^N2);
adata    = ampdataIn(1:2^N2);
PeriodIn = timedataIn(2^N2)-timedataIn(1)
frequencies = linspace(1,Ndisp,Ndisp)/PeriodIn;

fftIn = fft(adata);
figure(1); plot(frequencies,abs(fftIn(2:Ndisp+1)))
           title('Spectrum of input signal')
           xlabel('Frequency [Hz]'); ylabel('Amplitude')

tdata = timedataOut(1:2^N2);
adata = ampdataOut(1:2^N2);
PeriodOut = timedataOut(2^N2)-timedataOut(1)
fftOut = fft(adata);
figure(2); plot(frequencies,abs(fftOut(2:Ndisp+1)))
           title('Spectrum of output signal')
           xlabel('Frequency [Hz]'); ylabel('Amplitude')

figure(3); plot(frequencies,abs(fftOut(2:Ndisp+1))./abs(fftIn(2:Ndisp+1)))
           title('Transfer function')
           xlabel('Frequency [Hz]'); ylabel('Output/Input'); grid on  

nn = sum(frequencies <2500);          
figure(4); plot(frequencies(1:nn),abs(fftOut(2:nn+1))./abs(fftIn(2:nn+1)))
           title('Transfer function')  
           xlabel('Frequency [Hz]'); ylabel('Output/Input');
