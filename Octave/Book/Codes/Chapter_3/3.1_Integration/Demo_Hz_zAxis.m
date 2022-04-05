R = 1;
HzAxis = @(z)R^2/2*(R^2+z.^2).^(-3/2);
z = linspace(-2,3,101);

dz = 0.0;
figure(1); plot(z,HzAxis(z-dz)+HzAxis(z+dz))
           axis([-2,3,0,1])
           grid on; xlabel('height z'); ylabel('Field Fz');
dz = 1;
figure(2); plot(z,HzAxis(z-dz)+HzAxis(z+dz))
           axis([-2,3,0,1])
           grid on; xlabel('height z'); ylabel('Field Fz');
dz = 1/2;
figure(3); plot(z,HzAxis(z-dz)+HzAxis(z+dz))
           axis([-1,1.5,0,1])
           grid on; xlabel('height z'); ylabel('Field Fz');
