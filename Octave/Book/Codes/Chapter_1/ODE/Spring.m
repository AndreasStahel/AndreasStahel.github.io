function ydot = Spring(y)
  ydot = zeros(size(y));
  k = 1; al = 0.1;
  ydot(1) = y(2);
  ydot(2) = -k*y(1)-al*y(2);
end%function
