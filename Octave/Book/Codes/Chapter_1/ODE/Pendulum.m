%% demo file to solve a pendulum equation
Tend = 30;
%% on Matlab put the definition of the function in a file pend.m
function y = pend(t,x)
  k = 1;
  y = [x(2);-k*sin(x(1))];
end%function

y0 = [0.1;0];       % small angle
% y0=[pi/2;0];      % large angle
% y0 = [pi-0.01;0]; % very large angle

t = linspace(0,Tend,100);
[t,y] = ode_RungeKutta('pend',t,y0,10); % Runge-Kutta
% [t,y] = ode_Euler('pend',t,y0,10);    % Euler
% [t,y] = ode_Heun('pend',t,y0,10);     % Heun

plot(t,180/pi*y(:,1))
xlabel('time'); ylabel('angle [Deg]')
