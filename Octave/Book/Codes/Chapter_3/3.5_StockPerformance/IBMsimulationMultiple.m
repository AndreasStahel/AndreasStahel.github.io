days = 250;       % number of trading days to be simulated
runs = 20;

rates = randn(runs,days-1)*rstd + rmean;    % daily interest rates
values = [ones(runs,1) exp(cumsum(rates,2))];
figure(2); plot(1:days,values)
           xlabel('trading day'); ylabel('relative values')
