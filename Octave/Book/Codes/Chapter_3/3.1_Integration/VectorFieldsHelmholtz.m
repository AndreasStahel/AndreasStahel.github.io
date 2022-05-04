dHz = @(al,R,x,z)R*(R-x.*cos(al))./sqrt(R^2-2*x.*R.*cos(al)+x.^2 +z.^2).^3;
dHx = @(phi,R,x,z)R*z.*cos(phi) ./sqrt(R^2-2*x.*R.*cos(phi)+x.^2 +z.^2).^3;

clf
x = -0.3:0.05:0.3; z = x;
h = 0.5; % optimal distance for Helmholtz configuration

[xx,zz] = meshgrid(x,z);
x = xx(:); z = zz(:);
Hx = zeros(size(x)); Hz=Hx;

for k = 1:length(x)
  fx    = @(al)(dHx(al,1,x(k),z(k)-h)+dHx(al,1,x(k),z(k)+h));
  Hx(k) = quad(fx,0,2*pi)/(4*pi);
  fz    = @(al)(dHz(al,1,x(k),z(k)-h)+dHz(al,1,x(k),z(k)+h));
  Hz(k) = quad(fz,0,2*pi)/(4*pi);
end%for

quiver(x,z,Hx,Hz,0.6)
grid on
xlabel('x');ylabel('z')
axis([-0.3 0.3 -0.3 0.3])
