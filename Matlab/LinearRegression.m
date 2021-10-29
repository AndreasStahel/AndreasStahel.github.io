function [p, e_var, r, p_var, fit_var] = LinearRegression (F, y, weight)
% Function File LinearRegression (F, y, w)
% [p, e_var, r, p_var, fit_var] = LinearRegression (...)
%
% general linear regression
%
% determine the parameters p_j  (j=1,2,...,m) such that the function
% f(x) = sum_(j=1,...,m) p_j*f_j(x) is the best fit to the given values
% y_i by f(x_i) for i=1,...,n, i.e. minimize
% sum_(i=1,...,n)(y_i-sum_(j=1,...,m) p_j*f_j(x_i))^2 with respect to p_j
%
% parameters:  
% F is an n*m matrix with the values of the basis functions at
%   the support points. In column j give the values of f_j at the points
%   x_i  (i=1,2,...,n)
% y is a column vector of length n with the given values
% w is an optional column vector of length n with the weights of
%   the data points. 1/w_i is expected to be proportional to the
%   estimated uncertainty in the y values. Then the weighted expression
%   sum_(i=1,...,n)(w_i^2*(y_i-f(x_i))^2) is minimized.
%
% return values:
% p     is the vector of length m with the estimated values of the parameters
% e_var is the vector of estimated variances of the residuals, i.e. the
%       difference between the provided y values and the fitted function.
%       If weights are provided, then the product e_var_i * w^2_i is assumed to
%       be constant.
% r     is the weighted norm of the residual
% p_var is the vector of estimated variances of the parameters p_j
% fit_var is the vector of the estimated variances of the fitted function values f(x_i)
%
% To estimate the variance of the difference between future y values
% and fitted y values use the sum of e_var and fit_var
%
% Caution: do NOT request @var{fit_var} for large data sets, as a n by n matrix is generated
%
% see also: ols,gls,regress,leasqr,nonlin_curvefit,polyfit,wpolyfit,expfit
%
% Copyright (C) 2007-2018 Andreas Stahel <Andreas.Stahel@bfh.ch>

%% This program is free software; you can redistribute it and/or modify it under
%% the terms of the GNU General Public License as published by the Free Software
%% Foundation; either version 3 of the License, or (at your option) any later
%% version.
%%
%% This program is distributed in the hope that it will be useful, but WITHOUT
%% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
%% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
%% details.
%%
%% You should have received a copy of the GNU General Public License along with
%% this program; if not, see <http://www.gnu.org/licenses/>.

  if (nargin < 2 || nargin >= 4)
    print_usage ();
  end%if

  [rF, cF] = size (F);
  [ry, cy] = size (y);
  
  if (rF ~= ry || cy > 1)
    error ('LinearRegression: incorrect matrix dimensions');
  end%if

  if (nargin == 2)  % set uniform weights if not provided
    weight = ones (size (y));
  else
    weight = weight(:);
  end%if

  wF = diag (weight) * F;    % this efficent with the diagonal matrix

  [Q, R] = qr (wF, 0);       % estimate the values of the parameters
  p = R \ (Q' * (weight .* y));

  %% Compute the residual vector and its weighted norm
  residual = F * p - y;
  r = norm (weight .* residual);

  weight2 = weight.^2;
  %% If the variance of data y is sigma^2 * weight.^2, var is an
  %% unbiased estimator of sigma^2
  var = residual.^2' * weight2 / (rF - cF);
  %% Estimated variance of residuals
  e_var = var ./ weight2;

  %% Compute variance of parameters, only if requested
  if (nargout > 3)

    M = R \ (Q' * diag (weight));

    %% compute variance of the fitted values, only if requested
    if (nargout > 4)
      %% WARNING the nonsparse matrix M2 is of size rF by rF, rF =
      %% number of data points
      M2 = (F * M).^2;
      fit_var =  M2 * e_var;  % variance of the function values
    end%if
    
    p_var = M.^2 * e_var;  % variance of the parameters
    
  end%if

end%function

