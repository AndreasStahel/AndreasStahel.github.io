Tend = 30; u0 = [0;0];

function curr = Diode(u)  % for Matlab put this in a file Diode.m
  Rd = 10; us = 0.7;
  curr = (Rd*(u+us)).*(u<-us);
end%function

function y = Circuit(t,u) % for Matlab put this in a file Circuit.m
  C1 = 1; C2 = 1;
  y  = [-1/C1*(Diode(u(1)-10*sin(t))-Diode(u(2)-u(1)));
        10*cos(t)-1/C2*Diode(u(2)-u(1))];
end%function

tFix = linspace(0,Tend,100);
[tFix,uFix] = ode_RungeKutta(@Circuit,tFix,u0,1);       % Runge Kutta
opt = odeset('Stats','on')
[t45,u45]   = ode45(         @Circuit,[0,Tend],u0,opt); % ode45
figure(1); plot(tFix ,uFix,'+-')
           xlabel('time'); ylabel('voltages')
figure(2); plot(t45,u45,'+-')
           xlabel('time'); ylabel('voltages')
figure(3); hist(diff(t45))
           xlabel('step size'); ylabel('frequency')
