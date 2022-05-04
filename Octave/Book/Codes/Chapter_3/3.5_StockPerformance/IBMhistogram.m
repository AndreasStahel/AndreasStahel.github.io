n = length(indata);                     % number of trading days
rcomp = log(indata(n)/indata(1))/(n-1)  % interest rate

rates = log(indata(2:n)./indata(1:n-1));
rmean = mean(rates)
rstd  = std(rates)

dr = 0.005;
edges = [-inf,-0.1:dr:0.1,inf];
histdata = histc(rates,edges);
nn = length(edges);

figure(1); bar(edges(2:nn-1)-dr/2,histdata(2:nn-1));
           axis([-0.1,0.1,0,400]); grid on
           xlabel('rate'); ylabel('# of cases')

y = normpdf(edges(2:nn-1),rmean,rstd);
factor = sum(histdata(2:nn-1))*dr;
histnew = histdata(2:nn-1)/factor;
figure(2); plot(edges(2:nn-1),[y;histnew])
           axis([-0.1,0.1,0,max(histnew)]); grid on
           xlabel('rate'); ylabel('percentage')

y = normpdf((edges(2:nn-2)+edges(3:nn-1))/2,rmean,rstd);

correlation = histdata(2:nn-2)*y'/(norm(histdata(2:nn-2))*norm(y))
