function [p] = ChebyshevApproximation(func_exact,n)
%% ChebyshevApproximation, compute the Chebyshev approximation
%% of order n of the function func_exat on the interval [-1,+1]
accuracy = 1e-8;

%%%%%%%%%%%%%% no modifications beyond this line %%%%%%%%%%%%

intfun = @(x,k) func_exact(cos(x))*cos(k*x);

c = zeros(n+1,1);
k = 0;
c(1) = quad(@(x)intfun(x,k),0,pi,accuracy)*1/pi;
for k = 1:n
  c(k+1) = quad(@(x)intfun(x,k),0,pi,accuracy)*2/pi;
endfor

coeff = zeros(n+1,n+1);
for i = 1:n+1;
  coeff(i,n-i+2:n+1) = Chebyshev(i-1);
endfor

p = coeff'*c;
endfunction
