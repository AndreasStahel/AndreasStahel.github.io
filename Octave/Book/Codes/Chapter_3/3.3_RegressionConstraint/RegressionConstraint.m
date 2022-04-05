
function [p,y_var,r] = RegressionConstraint(F,nn,weight)

% [p,y_var,r] = RegressionConstraint(F,nn)
% [p,y_var,r] = RegressionConstraint(F,nn,weight)
% regression with a constraint
% 
% determine the parameters p_j  (j=1,2,...,m) such that the function
% f(x) = sum_(i=1,...,m) p_j*f_j(x) fits as good as possible to the 
% given values y_i = f(x_i), subject to the constraint that the norm 
% of the last nn components of p equals 1
% 
% parameters
% F  n*m matrix with values of the basis functions at support points 
%    in column j give the values of f_j at the points x_i  (i=1,2,...,n)
% nn number of components to use for constraint
% weight  n column vector of given weights
% 
% return values
% p     m vector with the estimated values of the parameters
% y_var estimated variance of the error
% r     residual  sqrt(sum_i (y_i- f(x_i))^2))

if ((nargin < 2)||(nargin>=4))
  help RegressionConstraint
  error('wrong number of arguments in RegressionConstraint()');
end%if
[n,m] = size(F);
if (nargin==2)  % set uniform weights if not provided
  weight = ones(n,1);
end%if


[Q,R] = qr(diag(weight)*F,0);
R11 = R(1:m-nn,1:m-nn);
R12 = R(1:m-nn,m-nn+1:m);
R22 = R(m-nn+1:m,m-nn+1:m);
[u,l,v] = svd(R22);
p = [-R11\(R12*v(:,nn));v(:,nn)];

residual = F*p;                      % compute the residual vector
r = norm(diag(weight)*residual);     % and its norm
      % variance of the weighted y-errors
y_var = sum((residual.^2).*(weight.^4))/(n-m+nn);  
