% the array indata contains the value of the stock
k = length(indata);

% find the range of trading days for each year
y1 = 1:253;
y2 = 254:506;
y3 = 507:760;

% choose the length of the averaging period
avg = 20;

% create the data
avgdata = indata;
for ii = 1:k
    avgdata(ii) = mean(indata(max(1,ii-avg):ii));
end%for
% plot results for the third year
plot(y3,indata(y3),y3,avgdata(y3))
grid on
title('Value of IBM stock and its moving average in 1992')
xlabel('Trading day'); ylabel('Value')
text(510,15,'moving average over 20 days')
legend('data','moving average')
