function y = dfdx(x)  % Jacobian
  y = [2*x(1), 8*x(2); 
       16*x(1)^3, 2*x(2)^2];
end%function
