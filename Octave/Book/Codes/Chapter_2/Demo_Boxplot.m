N = 10;              % number of data points
data1 = 20*rand(N,1);
Mean = mean(data1)
Median = median(data1)
StdDev = std(data1)  % uses a division by (N-1)
Variance = StdDev^2
Variance2 = mean((data1-mean(data1)).^2)  % uses a division by N
Variance3 = sum((data1-mean(data1)).^2)/(N-1)

figure(1); Quartile1 = boxplot(data1)'   
           set(gca,'XTickLabel',{' '})    % remove labels on x axis
           c_axis = axis(); axis([0.5 1.5 c_axis(3:4)])

figure(2); boxplot(data1,0,'+',0)  % Octave
           %boxplot(data1,'orientation','horizontal')  % Matlab
           set(gca,'YTickLabel',{' '}) % remove labels on y axis
           c_axis = axis(); axis([c_axis(1:2),0.5 1.5])

Quartile2  = quantile(data1,[0 0.25 0.5 0.75 1])
Quantile10 = quantile(data1,0:0.1:1)

data2 = randi(10,[100,1]);
ModalValue = mode(data2)  % determine the value occuring most often
