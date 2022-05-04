function y = Circuit(t,u)
  C1 = 1; C2 = 1;
  y  = [-1/C1*(Diode(u(1)-10*sin(t))-Diode(u(2)-u(1)));
        10*cos(t)-1/C2*Diode(u(2)-u(1))];
end%function
