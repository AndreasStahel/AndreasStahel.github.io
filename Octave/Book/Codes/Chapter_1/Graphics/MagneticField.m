Lx = 2; Ly = +1.5 ;  % domain to be examined
cI1 = 1; cI2 = 1 ;  % the two currents     
D = 1;               % half the distance of the two conductors
Nx = 35; Ny = 25;    % number of grid points            
Dmin = 0.1;          % minimal distance from conductors to be examined

x = linspace(-Lx,Lx,Nx); y = linspace(-Ly,+Ly,Ny);  % generate the grid
[xx,yy] = meshgrid(x,y);

Dist1 = sqrt((xx-D).^2+ yy.^2);  % distance of (x,y) from the first conductor
remove1 = find(Dist1<Dmin);      % remove points too close to conductor
Dist1(remove1)= NaN;

Dist2 = sqrt((xx+D).^2+ yy.^2);   % distance of (x,y) from the second conductor
remove2 = find(Dist2<Dmin);       % remove points too close to conductor
Dist2(remove2)= NaN;

Vy = +cI1*(xx-D)./Dist1.^2 + cI2*(xx+D)./Dist2.^2; % compute the vector field
Vx = -cI1*(yy)./Dist1.^2   - cI2*(yy)./Dist2.^2; 

figure(1)
h = quiver(xx,yy,Vx,Vy,2);
xlabel('x'); ylabel('y'); axis([-Lx,Lx,-Ly,Ly]); axis equal

norms = sqrt(Vx.^2 + Vy.^2);
Vxn = Vx./norms; Vyn = Vy./norms; 
figure(2)
hq = quiver(xx,yy,Vxn,Vyn);
set (hq,'maxheadsize', 0)
xlabel('x'); ylabel('y'); axis([-Lx,Lx,-Ly,Ly]); axis equal


figure(1); hold on
if cI1*cI2<0
  Sx = 1.9*[-1:0.2:1]; Sy = 1.4*ones(size(Sx));
else
  Sy = 1.5*[-1:0.2:1]; Sx = 0.0*ones(size(Sy));
end%if
  hs  = streamline(xx,yy,Vx,Vy,Sx,Sy,[0.1,1000]);
set(hs,'color','r')
hold off
