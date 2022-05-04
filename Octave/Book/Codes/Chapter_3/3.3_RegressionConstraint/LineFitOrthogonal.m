LineData;
axis([-2 2 -2 2]); 
n = length(xi);

%% minimize orthogonal distance
F1 = [ones(n,1) xi yi];
[p1,yvar,residual1orthogonal] = RegressionConstraint(F1,2)

x = -2:0.1:2;
y = -(p1(1)+p1(2)*x)/p1(3);
figure(1);  plot(xi,yi,'*r',x,y,'g');


%% minimize vertical distance
F2 = [ones(n,1) xi];
[p2,yvar,residual2vertical] = LinearRegression(F2,yi)

x = -2:0.1:2;
y2 = p2(1)+p2(2)*x;
figure(2);  plot(xi,yi,'*r',x,y,'b',x,y2,'g');

%% compare the two solutions
y1new = -(p1(1)+p1(2)*xi)/p1(3);
residual1orthogonal
residual1vertical=sqrt(sum((yi-y1new).^2))

pp = [p2(1);p2(2);-1]/sqrt(1+p2(2)^2);
residual2vertical
residual2orthogonal=sqrt(sum((F1*pp).^2))
