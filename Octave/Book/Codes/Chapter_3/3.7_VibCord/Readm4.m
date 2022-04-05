%% script file to read one data set
filename = 'm4';
dt   = 1/48000; %% set the sampling frequency
Nmax = 50000;   %% create arrays large enough to contain all data 
x = zeros (Nmax, 1 ) ; y = x;
%% read the binary file, if it exists
%% otherwise read the original file and write binary file
if (exist([filename,'.mat'],'file')==2)
  eval(['load ',filename,'.mat'])
else
  inFile = fopen(filename ,'rt' ) ; %% read the information from the file 
  for k = 1:5
    inLine = fgetl(inFile);
  end%for
  k = 1; 
  for j = 1:Nmax
    inLine = fgetl(inFile);
    counter = find(inLine=='E');
    y(j) = sscanf(inLine(counter-9:length(inLine)) ,'%f');       
  end%for
  fclose(inFile) ;
  eval(['save -mat ',filename,'.mat y'])
end%if

figure(1); plot(y)  %% plot the raw data
           xlabel('dada point'); ylabel('signal'); grid on
