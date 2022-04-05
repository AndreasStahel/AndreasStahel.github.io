function [p,y_var,r,p_var] = LinearRegression1(F,y)

% [p,y_var,r,p_var] = LinearRegression(F,y)
% linear regression
% 
% determine the parameters p_j  (j=1,2,...,m) such that the function
% f(x) = sum_(i=1,...,m) p_j*f_j(x) fits as good as possible to the 
% given values y_i = f(x_i)
% 
% parameters
% F  n*m matrix with the values of the basis functions at the support points 
%    in column j give the values of f_j at the points x_i  (i=1,2,...,n)
% y  n column vector of given values
% 
% return values
% p     m vector with the estimated values of the parameters
% y_var estimated variance of the error
% r     residual  sqrt(sum_i (y_i- f(x_i))^2))
% p_var estimated variance of the parameters p_j

if (nargin ~= 2)
  usage('wrong number of arguments in [p,y_var,r,p_var] = LinearRegression1(F,y)');
end

[rF, cF] = size(F);  [ry, cy] =size(y);
if ( (rF ~= ry)||(cy>1))
  error ('LinearRegression : incorrect matrix dimensions');
end

p = (F'*F)\(F'*y);      % estimate the values of the parameters

residual = F*p-y;       % compute the residual vector
r = norm(residual);     % and its norm
y_var = sum(residual.^2)/(rF-cF);  % variance of the y-errors

if nargout>3              % compute variance of parameters only if needed
%  M = inv(F'*F)*F';
  M = (F'*F)\F';
  M = M.*M;               % square each entry in the matrix M
  p_var = sum(M,2)*y_var; % variance of the parameters
end
