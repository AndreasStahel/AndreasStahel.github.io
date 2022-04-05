function [tout, yout] = ode_Heun(FunFcn, t, y0, steps)
%       [Tout,Yout] = ode_Heun(FunFcn, t, y0, steps)
%
%	Integrate a system of ordinary differential equations using
%	Heun's formula.
%
% INPUT:
% F     - String containing name of user-supplied problem description.
%         Call: yprime = fun(t,y) where F = 'fun'.
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
   for j=1:steps
      % Compute the slopes
      s1 = feval(FunFcn, tau, y); s1 = s1(:);
      s2 = feval(FunFcn, tau+h, y+h*s1); s2 = s2(:);
      tau = tau + h;
      y = y + h*(s1+s2)/2;
    end%for
    yout = [yout; y.'];
end%for
