%% give the parameters
ain = 1.2; bin = 0.8; alphain = 15*pi/180;  x0in = 0.1 ; y0in = -0.2; np = 15; 
sigma = 0.05;  %% standard deviation of the errors

phi = linspace(0,2*pi,np)';
xi  = x0in+ain*cos(phi)+sigma*randn(size(phi)); 
yi  = y0in+bin*sin(phi)+sigma*randn(size(phi));

xynew = [cos(alphain) -sin(alphain); sin(alphain) cos(alphain)]*[xi,yi]';
xi = xynew(1,:)'; yi = xynew(2,:)';


%% fit ellipse parallel to axis
F = [xi yi.^2 yi ones(size(xi))];
[p,yvar,r] = LinearRegression(F,-xi.^2);

x0 = -p(1)/2
y0 = -p(3)/(2*p(2))
a  = sqrt( x0^2 + p(2)*y0^2 - p(4))
b  = sqrt(a^2/p(2))

phi = (0:5:360)'*pi/180;
x = x0+a*cos(phi);  y = y0+b*sin(phi);
figure(1);
plot(xi,yi,'*r',x,y,'b');

%% fit general ellipse
F = [xi.*yi yi.^2  xi yi ones(size(xi))];
p = LinearRegression(F,-xi.^2);

m   = [2 p(1);p(1) 2*p(2)];
x0  = -m\[p(3);p(4)]
a11 =1/(x0(1)^2+p(1)*x0(1)*x0(2)+p(2)*x0(2)^2-p(5));
[V,la] = eig(a11*m/2);

alpha = atan(V(2,1)/V(1,1))*180/pi
a = 1/sqrt(la(1,1)) 
b = 1/sqrt(la(2,2))

np = 37;
phi = linspace(0,2*pi,np);
xx = V*([a*cos(phi); b*sin(phi)])+x0*ones(1,np);

xg = xx(1,:); yg = xx(2,:);

figure(2);
plot(xi,yi,'*r',x,y,'b',xg,yg,'r');
xlabel('x'); ylabel('y')
legend('data','horizontal ellipse','general ellipse') 
