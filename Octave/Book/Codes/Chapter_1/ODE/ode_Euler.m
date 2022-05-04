function [tout, yout] = ode_Euler(FunFcn, t, y0, steps)
%       [Tout,Yout] = ode_Euler(FunFcn, t, y0, steps)
%
%	Integrate a system of ordinary differential equations using
%	the Euler formula.
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
% Initialization
y = y0(:);  yout = y'; tout = t(:);

% The main loop
for i = 2:length(t)
   h = (t(i)-t(i-1))/steps;
   tau = t(i-1);
   for j=1:steps
      % Compute the slopes
      s1 = feval(FunFcn, tau, y); s1 = s1(:);
      tau = tau + h;
      y = y + h*s1;
    end%for
    yout = [yout; y.'];
end%for
