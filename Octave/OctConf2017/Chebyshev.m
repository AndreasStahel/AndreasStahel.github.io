function pn = Chebyshev(n)
% compute coefficients of the n'th order Chebyshev polynomial of the first kind
pA = [1];  pB = [1 0];

if n == 0 
  pn = [1];
elseif n == 1;
  pn = [1,0];
else
  for i = 2:n
    pn = (2*[pB,0] - [0,0,pA]);
    pA = pB;    pB = pn;
  endfor
endif
