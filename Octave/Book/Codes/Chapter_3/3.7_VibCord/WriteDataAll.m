function  WriteDataAll(basename,numbers,ext)

% function to analyze data for a series of Digi Sens sensor
%
% WriteDataAll(basename,numbers,ext)
%
% will analyze data given in files and then generate graphs
% and files AmpAll.png and QAll.png
% It will also display the estimated dependencies of amplitude
% and Q-factor on the temperature
%
% sample calls:
%   WriteDataAll('Elektro',[1:5],'.data')
%   WriteDataAll('Elektro',[1, 2, 4, 5],'.data')
%

if ((nargin ~=3))
  error('usage: give filenames in WriteDataAll(basename,numbers,ext)');
end

%calibrationFactor=11.2; % factor for amplitudes, ideal value is 1.0
calibrationFactor = 1.0; 

freqA = []; ampA = []; qualiA = []; tempA = [];
cmd1 = ['plot(']; cmd2 = cmd1; cmdLegend = 'legend(';
for sensor = 1:length(numbers)
  filename = [basename,num2str(numbers(sensor)),ext];
  infile   = fopen(filename,'rt');

  tline = fgetl(infile); % dump top line
  tline = fgetl(infile); % read number of measurements
  meas  = sscanf(tline,'%i');
  tline = fgetl(infile); % read number of repetitions
  rep   = sscanf(tline,'%i');

  freq = zeros(meas,1); freqS = freq; freqT = zeros(rep,1);
  curr = freq; currS = freq; currT = freqT;
  quali = freq; qualiS = freq; qualiT = freqT;
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
    end%for % rep
    amp(im)  = mean(ampT);  ampS(im)  = sqrt(var(ampT));
    freq(im) = mean(freqT); freqS(im) = sqrt(var(freqT));
    quali(im)= mean(qualiT);qualiS(im)= sqrt(var(qualiT));
    curr(im) = mean(currT); currS(im) = sqrt(var(currT));
    temp(im) = mean(tempT); tempS(im) = sqrt(var(tempT));
  end%for  % meas
  freqA  = [freqA;freq];   ampA  = [ampA;amp];
  qualiA = [qualiA;quali]; tempA = [tempA;temp];
  fclose(infile);

  key = num2str(numbers(sensor));
  freqn = ['freq',key,'=freq;']; eval(freqn);
  ampn  = ['amp',key,'=amp;'];   eval(ampn);
  qualin = ['quali',key,'=quali;'];eval(qualin);
  cmd1  = [cmd1,'freq',key,',amp',  key,','];
  cmd2  = [cmd2,'freq',key,',quali',key,','];
  cmdLegend = [cmdLegend,char(39),key,char(39),','];
end%for  % loop over all files

cmdLegend = [cmdLegend(1:end-1),')'];
cmd1 = [cmd1(1:end-1),');'];
cmd2 = [cmd2(1:end-1),');'];
figure(1);
clf;

eval(cmd1)
grid('on')
axis([14500 18000 4 7]);
xlabel('Frequency [Hz]'); ylabel('Amplitude')
eval(cmdLegend)
print('AmpAll.png','-dpng');

figure(2);
clf;
eval(cmd2);
grid('on')
axis([14500 18000 2000 3500]);
xlabel('Frequency [Hz]'); ylabel('Q-factor')
eval(cmdLegend)
print('QAll.png','-dpng');

NN = length(freqA);
F = ones(NN,3);
F(:,1) = freqA;F(:,2) = tempA;
[p,y_var,r,p_var] = LinearRegression(F,ampA);
fprintf('estimated temperature dependence of amplitude: %g um/C\n',p(2))
[p,y_var,r,p_var] = LinearRegression(F,qualiA);
fprintf('estimated temperature dependence of Q-factor: %g /C\n',p(2))

figure(3);
clf
axis();
plot3(freqA/1000,tempA,ampA,'+')
xlabel('frequency [kHz]'); ylabel('Temperature'); zlabel('Amplitude')
