% Interpolate with a piecewise linear curve
% GetData must be run first
nx   = 201;                          % number of grid points
xlin = linspace(min(x),max(x),nx);   % uniformly distributed points
% sort x and y values, based on the order of the x values
xysort = sortrows([x;y]',1);

% compute the values of y at the given points xlin
ylin = interp1(xysort(:,1),xysort(:,2),xlin); 

% Plot the interpolated curve.
% compute the derivatives at the midpoints
dy = diff(ylin)./diff(xlin);
% compute the midpoints of the intervals
xmid = xlin(2:length(xlin))-diff(xlin)/2;
figure(3); plot(x,y,'*', xlin,ylin,xmid,dy);
           legend('given points','interpolation','derivative'); grid on

