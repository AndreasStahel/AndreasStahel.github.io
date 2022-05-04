filename = "Line1.bmp";
aa = imread(filename,'bmp');
aa = rgb2gray(aa);
colormap(gray);
figure(1); imagesc(aa);

a = 255-aa(:);   a = a-min(min(a));

pos = find(a>(0.4*max(a))); % select the points to be considered
a = double(a(pos));
numberOfPoints = length(a)    % number of points to be considered

[xx,yy] = meshgrid(1:256,1:256);
x = xx(:); x = x(pos);  y = yy(:); y = y(pos);
figure(2); plot3(x,y,a)

p = RegressionConstraint([ones(size(x)) x y],2,a)

beta = pi/2 - atan2(p(3),p(2));
rotation = [cos(beta) -sin(beta);sin(beta) cos(beta)];
newcoord = rotation*[x';y'];
xn = newcoord(1,:)';  yn = newcoord(2,:)';
[p2,d_var,r,p2_var] = LinearRegression([ones(size(x)) xn],yn,a);
parameters = p2'
paramaterVariance = sqrt(p2_var')
