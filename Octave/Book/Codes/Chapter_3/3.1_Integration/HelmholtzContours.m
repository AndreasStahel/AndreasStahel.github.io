dHz = @(al,R,x,z)R*(R-x.*cos(al))./sqrt(R^2-2*x.*R.*cos(al)+x.^2 +z.^2).^3;
dHx = @(phi,R,x,z)R*z.*cos(phi) ./sqrt(R^2-2*x.*R.*cos(phi)+x.^2 +z.^2).^3;

n = 51; x = linspace(-0.3,0.3,n); z = x;
h = 0.5; % optimal distance for Helmholtz configuration

[xx,zz] = meshgrid(x,z);
x = xx(:); z = zz(:);
Hx = zeros(size(x)); Hz = Hx;

for k = 1:length(x)
  fx = @(al)(dHx (al,1,x(k),z(k)-h) + dHx (al,1,x(k),z(k)+h) );
  Hx(k) = quad(fx,0,2*pi)/(4*pi);
  fz = @(al)(dHz(al,1,x(k),z(k)-h)+dHz(al,1,x(k),z(k)+h));
  Hz(k) = quad(fz,0,2*pi)/(4*pi);
end%for
figure(1)
HzM = reshape(Hz,n,n);
Hz0 = HzM(floor(n/2)+1,floor(n/2)+1)
relerror = abs(HzM-Hz0)/Hz0;
contour(xx,zz,relerror,[0.001,0.002,0.005,0.01])
axis('equal'); grid on
xlabel('x'); ylabel('z');

figure(2)
HxM = reshape(Hx,n,n);
Herror = sqrt(HxM.^2 + (HzM-Hz0).^2)/Hz0;
contour(xx,zz,Herror,[0.001,0.002,0.005,0.01])
axis('equal');grid on
xlabel('x'); ylabel('z');
