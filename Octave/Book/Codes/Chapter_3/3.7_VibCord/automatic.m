function [amplitude,factor] = automatic(filename)

dt  = 1/48000;
Nmax = 50000; %% create arrays large enough to contain all data 
x = zeros (Nmax, 1 ) ; y=x;
if (exist([filename,'.mat'],'file')==2)
  eval(['load ',filename,'.mat'])
else
  inFile = fopen(filename ,'rt' ) ; %% read the information from the file 
  for k = 1:5
    inLine= fgetl(inFile);
  end%for
  k=1; 
  for j = 1:Nmax
    inLine  = fgetl(inFile);
    counter = find(inLine=='E');
    y(j) = sscanf(inLine(counter-9:length(inLine)) ,'%f');       
  end%for
  fclose(inFile) ;
  eval(['save -v4 ',filename,'.mat y'])
end%if 

figure(1); plot(y)  %% plot the raw data

y2 = abs(y-mean(y));
FilterLength = 100+1;
Filter = ones(FilterLength,1)/FilterLength;
y3 = conv(Filter,y2(1:end-FilterLength+1))';
y3 = y3(FilterLength:end);
N  = length(y3);
t  = linspace(0,(N-1)*dt,N)';
figure(2); plot(t,log(y3));

amplitude = mean(y3(1:200));
topcut = 0.8; lowcut = 0.4;
Nlow  = find(y3<topcut*amplitude,1);
Nhigh = find(y3<lowcut*amplitude,1);

y4 = log(y3(Nlow:Nhigh));
N  = length(y4);
t  = linspace(0,(N-1)*dt,N)';

F = ones(N,2); F(:,2)  =t;
[p,y_var,r,p_var] = LinearRegression(F,y4(:));
yFit = F*p;

figure(3); plot(t,y4,t,yFit)  %% display the real data and the regression line

fprintf('Slope: %g, Variance of slope: %g, relative error:%g\n', p(2), sqrt(p_var(2)), -sqrt(p_var(2))/p(2));

factor = 1/p(2);
end%function
