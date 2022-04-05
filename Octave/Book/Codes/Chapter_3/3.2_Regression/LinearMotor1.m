LinearMotorData;  % load the data
figure(1);
plot(long(:,1),force(:,1),long(:,2),force(:,2),long(:,3),force(:,3),...
     long(:,4),force(:,4),long(:,5),force(:,5));
xlabel('length of coil'); ylabel('force');

figure(2);
mesh(diam,long,force)
xlabel('diameter of coil'); ylabel('length of coil'); zlabel('force');
view(-10,30);

diam1 = diam(:);
long1 = long(:);force1=force(:);

F = [ones(size(long1)) long1 long1.*diam1 long1.*(diam1.^2)];
[coef,f_var,r,coef_var] = LinearRegression(F,force1)
%% [coef,f_var,r,coef_var] = LinearRegression(F,force1,1./sqrt(force1))


[L,DIA] = meshgrid(2:30,2:0.5:8);
forceA = coef(1)+L.*(coef(2)+coef(3)*DIA+coef(4)*DIA.^2);


figure(3);
mesh(DIA,L,forceA)
xlabel('diameter of coil'); ylabel('length of coil'); zlabel('force');
view(-10,30);

forceA2  = coef(1)+long.*(coef(2)+coef(3)*diam+coef(4)*diam.^2);
maxerror = max(max(abs(forceA2-force)))
maxrelerror = max(max((forceA2-force)./force))

figure(4)
contour(DIA,L,forceA,[0.5:0.5:8])
xlabel('diameter of coil'); ylabel('length of coil');