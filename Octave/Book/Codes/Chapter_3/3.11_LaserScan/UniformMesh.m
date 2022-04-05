nx   = 200;      % number of grid points in x direction
xmin = 0.5;      % minimal and maximal value of x
xmax = 16;
xlin = linspace(xmin,xmax,nx);
zlin = zeros(nx,npix);

for k = 1:npix
  xt = x(:,k)';                 % values of x and z in this row
  zt = z(:,k)';
  aa = sortrows([xt;zt]',1);    % sort with the x values as criterion
  xt = aa(:,1);
  xt = xt+(1:length(xt))'*1e-8; % tag on a minimal slope to prevent identical values 
  zt = aa(:,2);
  t = interp1(xt,zt,xlin);      % perform a linear interpolation
  zlin(:,k) = t';               % store the result in the matrix
end%for

xlin = xlin'*ones(1,npix);      % create the uniformly spaced x and y values
ylin = ones(1,nx)'*y(1,:);

% plot the interpolated data
figure(2); mesh(xlin,ylin,zlin)
           xlabel('x'); ylabel('y'); zlabel('z'); 


dx = xlin(2,1)-xlin(1,1);
dz = diff(zlin);

tip = abs(dz./dx-0.5)<0.1;       % mark the shadowed area
tip(nx,1:npix) = zeros(1,npix);  % no shadows on last row
figure(3); mesh(xlin,ylin,1.0*tip)
           xlabel('x'); ylabel('y'); zlabel('shadow');