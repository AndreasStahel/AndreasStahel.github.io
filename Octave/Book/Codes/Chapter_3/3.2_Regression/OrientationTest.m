OrientationData; %% read the values of alpha, x and y
gx = cos(al); gy = sin(al);
F = [gx gy ones(size(al))];
[px,xvar,r,pvar] = LinearRegression(F,x);
[py,xvar,r,pvar] = LinearRegression(F,y);
mx = px(1:2); cx = px(3); my = py(1:2); cy = py(3);

m = [mx my]
c = [cx cy]
xn = F*px;  yn = F*py;
plot(x,y,'*r',xn,yn,'b')
axis('equal')