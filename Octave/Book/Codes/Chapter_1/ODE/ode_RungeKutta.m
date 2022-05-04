function [tout, yout] = ode_RungeKutta(Fun, t, y0, steps)
% [Tout, Yout] = ode_RungeKutta(fun, t, y0, steps)
%
%	Integrate a system of ordinary differential equations using
%	4th order Runge-Kutta formula.
%
% INPUT:
% Fun   - String containing name of user-supplied problem description.
%         Call: yprime = Fun(t,y)
%         T      - Vector of times (scalar).
%         y      - Solution column-vector.
%         yprime - Returned derivative column-vector; yprime(i) = dy(i)/dt.
% T     - vector of output times
%         T(1), initial value of t.
% y0    - Initial value column-vector.
% steps - steps to take between given output times
%
% OUTPUT:
% Tout  - Returned integration time points (column-vector).
% Yout  - Returned solution, one solution column-vector per tout-value.
%
% The result can be displayed by: plot(tout, yout).

% Initialization
y = y0(:);  yout = y'; tout = t(:);

% The main loop
for i = 2:length(t)
   h = (t(i)-t(i-1))/steps;
   tau = t(i-1);
   for j = 1:steps
      % Compute the slopes
      s1 = feval(Fun, tau,     y);        s1 = s1(:);
      s2 = feval(Fun, tau+h/2, y+h*s1/2); s2 = s2(:);
      s3 = feval(Fun, tau+h/2, y+h*s2/2); s3 = s3(:);
      s4 = feval(Fun, tau+h,   y+h*s3);   s4 = s4(:);
      tau = tau + h;
      y = y + h*(s1 + 2*s2+ 2*s3 + s4)/6;
    end%for
    yout = [yout; y.'];
end%for
