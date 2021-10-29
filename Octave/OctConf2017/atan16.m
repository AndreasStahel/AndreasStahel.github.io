% approximatimation of atan((x+1)/2) with 16bit arithmetic

func_exact = @(x) atan((1+x)/2);
% other functions to play with
%func_exact = @(x) cos((1+x)*pi/4)
%func_exact = @(x) cos(x*pi/4)

p = ChebyshevApproximation(func_exact,2)

%%%%%%%% mo modifications required beyond this line
x = linspace(-1,1,100000);  
y = func_exact(x);
y_poly = polyval(p,x);

figure(2);
plot(x,y_poly-y)
xlabel('x'); ylabel('y')
grid on
title('Error of Chebyshev approximation')

figure(1);
plot(x,y,x,y_poly)
xlabel('x'); ylabel('y')
legend('off')
grid on
title('Function and Chebyshev approximation')

BitAccuracyCheby = -log2(max(abs(y_poly-y))/max(abs(y)))

coeff = int16(zeros(size(p))); shifts = zeros(size(p));
MaxVal = double(intmax('int16'));
x16 = int16(round(MaxVal*x/max(abs(x)))); xscale = MaxVal/max(abs(x));

yn = p(1)*ones(size(x)); 
y16 = int16(ones(size(x))*sign(p(1))*MaxVal);     coeff(1) = y16(1);
yscale = double(max(abs(double(y16)))/abs(p(1)));

for step = 2:length(p)
  [yn,y16,addI,sh,yscale] = HornerStep(x,yn,p(step),x16,y16,xscale,yscale);
  coeff(step) = addI; shifts(step) = sh;
  figure(99+step)
  plot(x,yn*yscale,x,y16,...
       x,MaxVal*ones(size(x)), 'g',x,-MaxVal*ones(size(x)),'g')
  xlabel('x'); ylabel('y scaled')
  legend('true','16bit')
  title(sprintf('Result of step %i',step-1))
%  figure(199+step)
%  plot(x,y16-yn*yscale)
%  xlabel('x'); ylabel('y scaled')
%  title(sprintf('Difference of result of step %i',step-1))
endfor
Scales  = [xscale,yscale]
Results = [coeff shifts]

figure(3)
plot(x,y,double(x16)/xscale,double(y16)/yscale)
xlabel('x'); ylabel('y')
legend('original','16bit')
title('Graph of original and 16bit approximation')
figure(4)
plot(x,double(y16)/yscale-y,x,y_poly-y)
xlabel('x'); ylabel('difference')
title('Difference to 16bit approximation')

BitAccuracyTotal = -log2(max(abs(double(y16)/yscale-y))/max(abs(y)))
BitAccuracyArith = -log2(max(abs(double(y16)/yscale-y_poly))/max(abs(y_poly)))
