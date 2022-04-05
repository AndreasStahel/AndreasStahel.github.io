PfennigerData;  % load the data

diam1 = diam(:);
long1 = long(:);force1=force(:);
F = [long1 long1.*(diam1.^2)];
[coef,f_var,r,coef_var] = LinearRegression(F,force1,1./sqrt(force1))

[L,DIA] = meshgrid(2:30,2:0.5:8);
forceB = L.*(coef(1)+coef(2)*DIA.^2);

figure(3);
mesh(DIA,L,forceB)
xlabel('diameter of coil'); ylabel('length of coil'); zlabel('force');
view(-10,30);

forceB2  = long.*(coef(1)+coef(2)*diam.^2);
maxerror = max(max(abs(forceB2-force)))
maxrelerror = max(max(abs(forceB2-force)./force))

figure(4)
contour(DIA,L,forceB,[0.5:0.5:8])
xlabel('diameter of coil'); ylabel('length of coil');