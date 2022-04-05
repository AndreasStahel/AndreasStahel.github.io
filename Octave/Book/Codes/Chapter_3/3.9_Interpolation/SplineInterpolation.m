% Interpolate with a spline curve and finer spacing.
% the code in GetData.m must be run first
n = length(x);
t  = 1:n;                            % integers from 1 to n
ts = 1: .2: n;                       % from 1 to n, stepsize 0.2
xys = spline(t,[x;y],ts);            % do the spline interpolation
xs = xys(1,:);  ys = xys(2,:);       % extract the components

% plot the interpolated curve.
figure(1); plot(xs,ys,x,y,'*-');
           xlabel('x'); ylabel('y'); grid on

% plot the two components of the spline curve separately, show labels
figure(2); plot([1:length(xs)],xs,'g-',[1:length(ys)],ys,'b-') 
           legend('x values','y values')
           xlabel('numbering'); ylabel('values'); grid on
