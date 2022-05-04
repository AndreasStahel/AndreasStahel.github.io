dHz = @(al,R,x,z)R*(R-x.*cos(al))./(R^2-2*R*x.*cos(al)+x.^2+z.^2).^1.5;
x  = -0.5:0.05:0.8;   Fz = zeros(size(x));
for k = 1:length(x)
  fz = @(al)dHz(al,1,x(k),0);     % define the anonymous function
  Fz(k) = quad(fz,0,2*pi)/(4*pi); % integrate
end%for

figure(1);  plot(x,Fz,'b')
            grid on;  axis([-0.5 0.8 0 1.2]);
            xlabel('position x'); ylabel('Field F_z');

x2 = 1.2:0.05:3;      Fz2 = zeros(size(x2));
for k = 1:length(x2)
  fz = @(al)dHz(al,1,x2(k),0);     % define the anonymous function
  Fz2(k) = quad(fz,0,2*pi)/(4*pi); % integrate
end%for

figure(2); plot(x,Fz,'b',x2,Fz2,'b')
           grid on;   axis([-0.5 3 -0.6 1.2]);
           xlabel('position x'); ylabel('Field F_z');
