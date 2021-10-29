function Phasor(N,func,plotpoints)
% Phasor(N,func,plotpoints)
%   generate a phasor animation with N contributions for the function 'func'
%   the constant contribution of the Fourier approximation is not used
% 
%   possible values for func: 'rectangle', 'sawtooth', 'triangle', 'halfwave'
%
%   func can also be a vector of complex Fourier coefficients
%     2*real(sum_{k=1}^N c(k)*exp(i*k*t))
%
%   plotpoints: optional argument for the number of plot points to be used
%
%   Example 1:  
%      Phasor(3,'rectangle')
%
%   Example 2:
%      N=1024; c = fft(linspace(0,2*pi,N)<1)/N;
%      Phasor(20,c(2:N),501)

%% Copyright (C) 2018  Andreas Stahel   <Andreas.Stahel@bfh.ch>
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

if nargin<2
  help Phasor
  error('invalid call of Phasor')
end%if

if nargin<=2
  t = linspace(0,4*pi,201);
else
  t = linspace(0,4*pi,plotpoints);
end%if

xt = []; yt = xt; xpt =  xt; ypt = xt;

if isnumeric(func)
   N = min(N,length(func));
   c = func(1:N);
   else
   switch lower(func)
   case{'rectangle' ,'rect'}
      c = -i/2 * (4/pi./[1:N]).*mod([1:N],2);
   case{'sawtooth' ,'saw'}
      c = i*(-1).^[1:N]./[1:N];
   case{'triangle' ,'tria'}
      cc = mod([1:N],2);
      c = 4/pi^ 2*([1:N].^(-2)).*mod([1:N],2);
   case{'halfwave','half'}
      nn = 1024; c = fft(max(sin(linspace(0,2*pi,nn)),0))/nn;
      c = c(2:end);
   otherwise
      error('invalid value for function name, use rectangle, sawtooth, triangle, halfwave')
   end%switch
end%if
omega = 1:length(c);

%% determine the range to be displayed
dom = 2.1*max(abs(sum(diag(c(1:N))*exp(i*omega(1:N)'*t))));

fig = get(gcf);
if exist('OCTAVE_VERSION')
  set(gcf,'position',[fig.position(1),fig.position(2) 1000,400])
  else
  set(gcf,'position',[fig.Position(1),fig.Position(2) 1000,400])
end%if
for ii = 1:length(t)
  xt = [xt,t(ii)];
  yt = [yt,2*real(sum(c(1:N).*exp(i*omega(1:N)*t(ii))))];
  subplot(1,2,2)
  plot(xt,yt,'b');
  axis([0,4*pi,-dom,dom])
  xlabel('time t'); ylabel('real(f_N(t))')
  drawnow()
  subplot(1,2,1)
  wheel = 0;
  for nn = 1:N
    wheel = [wheel;2*sum(c(1:nn).*exp(i*omega(1:nn)*t(ii)))];
  end%for
  xpt = [xpt,imag(-wheel(end))];
  ypt = [ypt,real(wheel(end))];  
  plot(xpt,ypt,'b',imag(-wheel),real(wheel),'g',imag(-wheel(end)),real(wheel(end)),'or')
  axis(dom*[-1 1 -1 1])
  xlabel('-imag(f_N(t))'); ylabel('real(f_N(t))')
  axis square
end%for 

