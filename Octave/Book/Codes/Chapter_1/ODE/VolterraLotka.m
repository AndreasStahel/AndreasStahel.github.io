function res = VolterraLotka(t,x)
  c1 = 1; c2 = 2; c3 = 1; c4 = 1;
  res = [(c1-c2*x(2))*x(1);...
         (c3*x(1)-c4)*x(2)];
end%function
