rmean = 6.0481e-4     % mean of the daily interest rate
rstd = 0.0194         % standard deviation of the daily interest rate
N = 250               % number of trading days in a year
C = 1.05              % strike price

NN = 100;

zval = linspace(log(0.2),log(3),NN);
Prob = normpdf(zval,N*rmean,rstd*sqrt(N));
figure(1); plot(exp(zval),Prob)
           title('probability function of value S'); grid on

zval  = linspace(log(1),log(6),NN);
Prob  = normpdf(zval,N*rmean,rstd*sqrt(N));
prob1 = trapz(zval,Prob)

zval  = linspace(log(2),log(6),NN);
Prob  = normpdf(zval,N*rmean,rstd*sqrt(N));
prob2 = trapz(zval,Prob)

maxVal = 5*C;
zval = linspace(log(C),log(maxVal),NN);
Prob = normpdf(zval,N*rmean,rstd*sqrt(N));
payoffProb = (exp(zval)-C).*Prob;

figure(2); plot(zval,payoffProb)
           title('probability * payoff as function of ln(S)'); grid on

figure(3); plot(exp(zval),payoffProb)
           title('probability * payoff as function of value S'); grid on

OptionValue = trapz(zval,payoffProb)  % use builtin trapezoidal rule
NN    = 100;
cval  = linspace(0.2,3,100);
price = zeros(size(cval));

for k = 1:length(cval)
  zval = linspace(log(cval(k)),log(6),NN);
  Prob = normpdf(zval,N*rmean,rstd*sqrt(N));
  payoffProb = (exp(zval)-cval(k)).*Prob;
  price(k) = trapz(zval,payoffProb);
end%for

figure(4); plot(cval,price)
           title('Price of option as function of strike'); grid on
