days = 250;       % number of trading days to be simulated
runs = 1000;      % number of trial runs

rates  = randn(runs,days-1)*rstd + rmean;   % daily interest rates
finalvalues = exp(sum(rates,2));

MeanValue = mean(finalvalues)
StandardDeviation = std(finalvalues)
LogMeanValue = mean(log(finalvalues))
LogStandardDeviation = std(log(finalvalues))

dr = 0.1;  edges    = [-inf,0:dr:3,inf];
histdata = histc(finalvalues,edges)/runs;
nn = length(edges);
figure(1); bar(edges(2:nn-1)-dr/2,histdata(2:nn-1));
           title('Histogram of probability')
           xlabel('value of stock')
           axis([0 3 0 0.15]);  grid on

dr = 0.1;
edges    = [-inf,-1:dr:1,inf];
histdata = histc(log(finalvalues),edges)/runs;
nn = length(edges);

figure(2); bar(edges(2:nn-1)-dr/2,histdata(2:nn-1));
           title('Histogram of probability')
           xlabel('logarithm of value of stock');
           axis([-1 1 0 0.15]);  grid on
