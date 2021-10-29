function [ynew,y16new,addI,sh,yscaleNew] = HornerStep(x,y,add,x16,y16,xscale,yscale)
% apply one Horner Step for a 16bit arithmetic
% compute ynew = x*y+add using 16bit representations x16, y16 
%
% x16 ist the 16bit representation of x  
% y16 ist the 16bit representation of y  
% xscale  is the scale factor for the argument x, i.e. x16/x
% yscale  is the scale factor for the argument y, i.e. y16/y
%
% ynew   is the result
% y16new the 16bit representation of ynew  
% addI   is the 16bit integer to be added
% sh     is the shift to be applied to the result
% yscaleNew is the scale factor for ynew

  ynew = x.*y + add;
  yscaleNew = xscale*yscale/2^16; % use high byte only
  prod = bitshift(int32(x16).*int32(y16),-16);
  addI = int32(round(add*yscaleNew));
  sh   = max([floor(log2(max(abs(prod+addI))))-14,0]);
  yscaleNew = yscaleNew*2^-sh;
  addI = int32(round(add*yscaleNew));
  y16new = int16(bitshift(prod,-sh)) + int16(addI);
endfunction
