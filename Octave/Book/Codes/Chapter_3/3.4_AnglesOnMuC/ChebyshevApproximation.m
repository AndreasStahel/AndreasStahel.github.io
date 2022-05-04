%% compute the Chebyshev approximation of order n of the function fun
n = 2;
accuracy = 1e-8;     % accuracy for the numerical integration
A = 0;               % left endpoint
B = 1;              % right endpoint
fun = @(x)atan(x);  % function to be approximated

% redefine function on standard interval [-1,1]
newFun = @(x,A,B)fun(A+0.5*(x+1)*(B-A)); 

% function to be integrated
intFun = @(p,A,B,k)newFun(cos(p),A,B).*cos(k*p);

c = zeros(n+1,1);
c(1)  = quad(@(p)intFun(p,A,B,0),0,pi,accuracy)*1/pi;
for k = 1:n
  c(k+1) = quad(@(p)intFun(p,A,B,k),0,pi,accuracy)*2/pi;
end%for

coeff = zeros(n+1,n+1);
for i = 1:n+1;
  coeff(i,n-i+2:n+1) = Chebyshev(i-1);
end%for

newPol = coeff'*c
y = polyval(newPol,linspace(-1,1,n+1))';
F = vander(linspace(A,B,n+1)');
p = F\y

x  = linspace(A,B,101);
y1 = fun(x);  y2 = polyval(p,x);
figure(1); plot(x,y2-y1)
           xlabel('x'); ylabel('difference');
           
figure(2); plot(x,y1,x,y2)
           xlabel('x'); ylabel('values');