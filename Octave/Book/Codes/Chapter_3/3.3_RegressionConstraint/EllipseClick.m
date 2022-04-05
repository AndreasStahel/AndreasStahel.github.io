figure(1); clf;
axislimits =[-2 2 -2 2]; axis(axislimits)
disp('Use the left mouse button to pick points.')
disp('Use the right mouse button to pick the last point.')
xi = []; yi = [];
button = 1;                       % to indicate the last point
while button == 1                 % while loop, picking up the points.
    [xii,yii,button] = ginput(1); % get coodinates of one point
    xi = [xi;xii]; yi = [yi;yii];
    plot(xi,yi,'ro')              % plot all points
    axis(axislimits);             % fix the axis
end

%% fit ellipse parallel to axis
F = [xi yi.^2 yi ones(size(xi))];
[p,yvar,r] = LinearRegression(F,-xi.^2);

x0 = -p(1)/2
y0 = -p(3)/(2*p(2))
a  = sqrt( x0^2 + p(2)*y0^2 - p(4))
b  = sqrt(a^2/p(2))
phi = (0:5:360)'*pi/180;
x   = x0+a*cos(phi);  y = y0+b*sin(phi);

%% fit general ellipse
F = [xi.*yi yi.^2  xi yi ones(size(xi))];
p = LinearRegression(F,-xi.^2);

m   = [2 p(1);p(1) 2*p(2)];
x0  = -m\[p(3);p(4)]
a11 = 1/(x0(1)^2+p(1)*x0(1)*x0(2)+p(2)*x0(2)^2-p(5));
[V,la] = eig(a11*m/2);

alpha = atan(V(2,1)/V(1,1))*180/pi
a = 1/sqrt(la(1,1)) 
b = 1/sqrt(la(2,2))

np  = 37;  phi = linspace(0,2*pi,np);
xx = V*([a*cos(phi); b*sin(phi)])+x0*ones(1,np);
xg = xx(1,:); yg = xx(2,:);

figure(1);
plot(xi,yi,'*r',x,y,'b',xg,yg,'r');
xlabel('x'); ylabel('y')
legend('data','horizontal ellipse','general ellipse') 
