function [freq,freqS,amp,ampS,quali,qualiS,curr,currS,temp,tempS]...
   = WriteData(filename)

% function to write data for the DigiSens sensor
%
% WriteData(filename)
% [freq,freqS,amp,ampS,quali,qualiS,curr,currS,temp,tempS] = WriteData(filename)
%
% when used without return arguments  WriteData(filename) will analyze data 
% in filename and then write to the new file 'gnu.dat'. Then a system call 
% 'gnuplot AmpQ.gnu' is made to generate graphs in the files
% AmpQ.png AmpQ2.png and Temp.png
%
% when used with return arguments the consolidated data will be returned
% and may be used to generate graphs, e.g.
% [freq,freqS,amp] = WriteData('test1.dat');
% plot(freq,amp)
%

if ((nargin ~=1))
  error('useage: give filename in WriteData(filename)');
end

calibrationFactor = 11.2; % factor for amplitudes, ideal value is 1.0
calibrationFactor = 1.0;

infile = fopen(filename,'rt');

tline = fgetl(infile); % dump top line
tline = fgetl(infile); % read number of measurements
meas  = sscanf(tline,'%i');
tline = fgetl(infile); % read number of repetitions
rep   = sscanf(tline,'%i');

freq = zeros(meas,1); freqS=freq; freqT=zeros(rep,1);
curr = freq; currS = freq; currT = freqT;
quali = freq; qualiS=freq; qualiT = freqT;
amp = freq; ampS = freq; ampT = freqT; temp = freq;

for k = 1:8;   % read the headerlines
  tline = fgetl(infile);
end%for

for im = 1:meas;
  for ir = 1:rep
    tline = fgetl(infile);
    t = sscanf(tline,'%g %g %g %g %g');
    ampT(ir) = calibrationFactor*t(1);
    freqT(ir)  = t(2);
    qualiT(ir) = t(3);
    currT(ir)  = t(4);
    tempT(ir)  = t(5);
  end%for
  amp(im)   = mean(ampT);   ampS(im)   = sqrt(var(ampT));
  freq(im)  = mean(freqT);  freqS(im)  = sqrt(var(freqT));
  quali(im) = mean(qualiT); qualiS(im) = sqrt(var(qualiT));
  curr(im)  = mean(currT);  currS(im)  = sqrt(var(currT));
  temp(im)  = mean(tempT);  tempS(im)  = sqrt(var(tempT));
end%for
fclose(infile);

fprintf('mean STDEV frequency %3e, maximal STDEV frequency %3e\n',mean(freqS),max(freqS))
fprintf('mean STDEV amplitude %3e, maximal STDEV amplitude %3e\n',mean(ampS),max(ampS))
fprintf('mean STDEV Q-factor %3g, maximal STDEV Q-factor %3g\n',mean(qualiS),max(qualiS))
fprintf('mimimal temperature %3g, maximal temperature %3g\n',min(temp),max(temp))

outfile = fopen('gnu.dat','wt');
fprintf(outfile,'# Freq Amp amp-STDEV amp+STDEV Q Q-STDEV Q+STDEV temp\n'); 
for im = 1:meas;
  fprintf(outfile,'%g %g %g %g %g %g %g %g\n',...
	freq(im),amp(im),amp(im)-ampS(im),amp(im)+ampS(im),...
	   quali(im),quali(im)-qualiS(im),quali(im)+qualiS(im),temp(im));
end%for
fclose(outfile);

system('gnuplot AmpQ.gnu');
end%function
