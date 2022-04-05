function [x,iter] = fsolveNewton(f,x0,tolx,dfdx)

% [x,iter] = fsolveNewton(f,x0,tolx,dfdx)
%
% use Newtons method to solve a system of equations f(x)=0, 
% the number of equations and unknowns have to match
% the Jacobian matrix is either given by the function dfdx or
% determined with finite difference computations
%
% input parameters:
% f    string with the function name
%      function has to return a column vector
% x0   starting value
% tolx allowed tolerances, 
%      a vector with the maximal tolerance for each component 
%      if tolx is a scalar, use this value for each of the components
% dfdx string with function name to compute the Jacobian
%
% output parameters:
% x    vector with the approximate solution
% iter number of required iterations
%      if iter>20 then the algorithm did not converge

%% Copyright (C) 2010 Andreas Stahel   <Andreas.Stahel@bfh.ch>
%%
%% This program is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 2 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program; If not, see <http://www.gnu.org/licenses/>.

  if ((nargin < 3)|(nargin>=5))
    help fsolveNewton
    error('fsolveNewton');
  end%if
  maxit = 20;    % maximal number of iterations
  x = x0;
  iter = 0;
  if isscalar(tolx) tolx = tolx*ones(size(x0)); end%if
  dx = 100*abs(tolx);
  f0 = feval(f,x);
  m = length(f0);   n = length(x);
  if (n ~= m) error('number of equations not equal number of unknown') 
    end%if
  if (n ~= length(dx)) error('tolerance not correctly specified') 
    end%if
  jac = zeros(m,n); % reserve memory for the Jacobian
  done = false;     % Matlab has no 'do until'
  while ~done
    if nargin==4    % use the provided Jacobian
      jac = feval(dfdx,x);
    else            % use a finite difference approx for Jacobian
      dx = dx/100;
      for jj= 1:n
	xn = x; xn(jj) = xn(jj)+dx(jj);
	jac(:,jj) = ((feval(f,xn)-f0)/dx(jj));
      end%for
    end%if
    dx = jac\f0;
    x = x - dx;
    iter = iter+1;
    f0 = feval(f,x);
    if ((iter>=maxit)|(abs(dx)<tolx))
      done = true;
    end%if
  end%while
% endfunction

