%% code by Andreas Stahel, Bern University of Applied Sciences
%% loosely based on the code spectrum_analyser.m from playrec
%% see http://www.playrec.co.uk/

sf = 44100; % set the sampling frequency
T = 1/4;  % length of time interval for one data set
n0 = sf*T; % number of data points in one sample
freq = [0:n0-1]/T; % set of all frequencies
n = find(freq>2000,1); % display only frequencies smaller than 2.0 kHz

% to find the ID of sound device
%aa = audiodevinfo()
%aa.input.ID
% ID = 4  % on my old laptop
ID = 14;  % on my current Laptop
% ID = 7; % on my desktop
% ID = 2 % on laptop of Pierre-André with Windows
RecObj = audiorecorder(sf,16,1,ID); 

%%%%%%%%% set up the graphics
fftFigure = figure(1);   % initialize graphics window
clf
% set the axis for the graphics with all properties, e.g. scaling
fftAxes = axes('parent',fftFigure,'xlimmode','manual','ylimmode','manual',...
               'xscale','linear','yscale','linear',...
               'xlim',[0 (n-1)/T],'ylim',[-100 0]);
% initialize the data, at first with zero values
fftLine = line('XData',[0:(n-1)]/T,'YData',zeros(1,n));
xlabel('frequency [Hz]'); ylabel('amplitude [db]'); % label the axis
drawnow(); % draw the graphics window

keyDownListener = @(src,event) keyboard;  % to replace Octave's kbhit()
% set(fftFigure,'HitTest','on')
set(fftFigure,'KeyPressFcn',keyDownListener)

% loop with the measurements
for k = 1:20/T  % at most 20 sec, stop by hitting a key
   recordblocking(RecObj,T)  % record for T seconds
   s = getaudiodata(RecObj); % get the raw data out
   spec = abs(fft(s(:,1)))/(2*n0);    % compute the spectrum
   set(fftLine,'YData',20*log10(spec(1:n)));  % write the data to the window
   drawnow();                         % update the display
end%for
