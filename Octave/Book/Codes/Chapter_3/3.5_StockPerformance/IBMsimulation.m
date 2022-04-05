days = 250;       % number of trading days to be simulated
rates = randn(1,days-1)*rstd + rmean;    % daily interest rates

%% solution with a loop, slow
% values = ones(1,days);                 % value of stock
% for k = 2:days
%   values(k) = values(k-1)*exp(rates(k-1));
% end

%% solution without a loop, fast
values = [1,exp(cumsum(rates))];

plot(values)
grid on
xlabel('trading day'); ylabel('relative value')
