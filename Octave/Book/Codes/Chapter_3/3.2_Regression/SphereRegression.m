tt = dlmread ('SphereData.csv');
x = tt(:,1); y = tt(:,2); z = tt(:,3);

N = length(x); steps = 5;
xx = reshape(x,N/steps,steps);
yy = reshape(y,N/steps,steps);
zz = reshape(z,N/steps,steps);

figure(1); contour(xx,yy,zz,5);    %% create a contour plot
           axis('equal')

figure(2); mesh(xx,yy,zz);         %% create a surface plot
           xlabel('x');ylabel('y');zlabel('z');
           axis('normal');

%% regression of shpere
F = [ones(size(x)) x y x.^2+y.^2];
[p,y_var,r,p_var] = LinearRegression(F,z);

%% display the results 
Radius = -1/(2*p(4))
x0 = Radius*p(2)
y0 = Radius*p(3)

%% determine standard deviations
deltaRadius = 2*Radius^2*sqrt(p_var(4))
%% deltaX0 = Radius*sqrt(p_var(2)) +abs(p(2))*deltaRadius
deltaX0 = sqrt(Radius^2*p_var(2) + p(2)^2*deltaRadius^2)
deltaY0 = sqrt(Radius^2*p_var(3) + p(3)^2*deltaRadius^2)


%% run the analysis for two different radii
F2 =[ones(size(x)) x y x.^2 y.^2 x.*y];
[p,y_var,r,p_var] = LinearRegression(F2,z);
RadiusNew = -0.5./eig([p(4), p(6)/2;p(6)/2,p(5)])