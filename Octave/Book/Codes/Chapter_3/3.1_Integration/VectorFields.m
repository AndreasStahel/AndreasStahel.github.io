dHz = @(al,R,x,z)R*(R-x.*cos(al))./sqrt(R^2-2*x.*R.*cos(al)+x.^2 +z.^2).^3;
dHx = @(phi,R,x,z)R*z.*cos(phi) ./sqrt(R^2-2*x.*R.*cos(phi)+x.^2 +z.^2).^3;

clf
z = -1:0.2:2; x = -0.4:0.1:0.7;
[xx,zz] = meshgrid(x,z);
x = xx(:); z = zz(:);
Hx = zeros(size(x)); Hz = Hx;

for k = 1:length(x)
  fx    = @(al)dHx(al,1,x(k),z(k));
  Hx(k) = quad(fx,0,2*pi)/(4*pi);
  fz    = @(al)dHz(al,1,x(k),z(k));
  Hz(k) = quad(fz,0,2*pi)/(4*pi);
end%for

subplot(1,2,1)
quiver(x,z,Hx,Hz,1.5)
grid on
axis([-0.4 0.8 -1 2])

scal = 1./sqrt(Hx(:).^2+Hz(:).^2);
Hx = scal.*Hx; Hz = scal.*Hz;

subplot(1,2,2)
quiver(x,z,Hx,Hz,0.6)
grid on
axis([-0.4 0.8 -1 2])
