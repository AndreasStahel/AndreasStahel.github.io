clf;
axis([-2 2 -2 2],'equal');
EllipseData1;
plot(xi,yi,'*r');

F=[xi.*yi yi.^2  xi yi ones(size(xi))];
p=LinearRegression(F,-xi.^2);

m=[2 p(1);p(1) 2*p(2)];
x0=-m\[p(3);p(4)]
a11=1/(x0(1)^2+p(1)*x0(1)*x0(2)+p(2)*x0(2)^2-p(5));

[V,la]=eig(a11*m/2);
alpha=atan(V(2,1)/V(1,1))*180/pi
a=1/sqrt(la(1,1)) 
b=1/sqrt(la(2,2))

np=37; phi=linspace(0,2*pi,np);

xx=V*([a*cos(phi); b*sin(phi)])+x0*ones(1,np);
x=xx(1,:);y=xx(2,:);

plot(xi,yi,'*r',x,y,'b');
