function curr = Diode(u)  % for Matlab put this in a file Diode.m
  Rd = 10; us = 0.7;
  curr = (Rd*(u+us)).*(u<-us);
end%function
