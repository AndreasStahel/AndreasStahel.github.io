zc = linspace(0,1,256);
atantab = round(atan(zc)*255*4/pi);

z = 0:0.001:1;

res = zeros(size(z));
for k = 1:length(z)
  res(k) = atantab(floor(255*z(k)+0.5)+1)/255*pi/4;
end%for

figure(1); plot(z,res-atan(z),'r')
           xlabel('z'); ylabel('error'); grid on
range = 1:32;
figure(2); plot(z(range),res(range)-atan(z(range)),'-*r')
           xlabel('z'); ylabel('error'); grid on
