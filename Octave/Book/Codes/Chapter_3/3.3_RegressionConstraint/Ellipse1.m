clf;
axis([-2 2 -2 2],'equal');
EllipseData1;
plot(xi,yi,'*r');

F=[xi yi.^2 yi ones(size(xi))];
[p,yvar,r]=LinearRegression(F,-xi.^2);

x0=-p(1)/2
y0=-p(3)/(2*p(2))
a=sqrt( x0^2 + p(2)*y0^2 - p(4))
b=sqrt(a^2/p(2))

phi=(0:5:360)'*pi/180;
x=x0+a*cos(phi);  y=y0+b*sin(phi);
plot(xi,yi,'*r',x,y,'b');
