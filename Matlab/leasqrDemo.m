% generate the data, then plot
% start with Exa = 1
Exa = 3;

switch Exa
case 1     % generate the data
  nn = 100 ; % number of data points
  Ae = 1.5; ale = 0.1; omegae = 0.9 ; phie = 1.5;
  noise = 0.1;
  t = linspace(0,10,nn)'; n = noise*randn(size(t));

%  function y = f(t,p)
%    y = p(1)*exp(-p(2)*t).*cos(p(3)*t+p(4));
%  endfunction
  f = @(t,p)p(1)*exp(-p(2)*t).*cos(p(3)*t+p(4));
  y =  f(t,[Ae,ale,omegae,phie])+n;
  plot(t,y,'+'); legend('data')
  A0 = 2; al0 = 0; omega0 = 1; phi0 = pi/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 2
  [fr,p] = leasqr(t,y,[A0,al0,omega0,phi0],f,1e-10);
  Parameters = p'

  yFit = f(t,p);
  plot(t,y, '+',t,yFit)
  legend('data','fit')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 3
  [fr,p,kvg,iter,corp,covp,covr,stdresid,Z,r2] =...
      leasqr(t,y,[A0,al0,omega0,phi0],f,1e-10);
  ParametersAndDeviations = [p(:), sqrt(diag(covp))]
  yFit = f(t,p);
  plot(t,y,'+', t,yFit)
  legend('data','fit')
end%switch
