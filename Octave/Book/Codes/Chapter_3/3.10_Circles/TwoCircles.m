x1m = 2; y1m = 3;   r1 = 1.5;  % data of the first circle

%======= create the graph =========
t = linspace(0,2*pi,51);  % values of all angles, 51 steps

x1 = x1m + r1*cos(t);         % x coordinates of all points
y1 = y1m + r1*sin(t);         % y coordinates of all points

x2m = 4; y2m = 2; r2 = 2; % data of the second circle
x2  = x2m+r2*cos(t);         % x coordinates of all points
y2  = y2m+r2*sin(t);         % y coordinates of all points

plot(x1,y1,x2,y2);         % create the plot with both circles


% find the parameters for the straight line

xp = [0; (-r1^2+r2^2+x1m^2-x2m^2+y1m^2-y2m^2)/(2*(y1m-y2m))];
v  = [y1m-y2m;-x1m+x2m];

% determine coefficients of the quadratic equation
a = v'*v;
b = 2*v'*(xp-[x1m;y1m]);
c = norm(xp-[x1m;y1m])^2-r1^2;
D = b^2-4*a*c;  % discriminant

% compute the two solutions
t1 = (-b+sqrt(D))/(2*a);
t2 = (-b-sqrt(D))/(2*a);

p1 = xp + t1*v
p2 = xp + t2*v
