nn = 5; zc = linspace(0,1,2^nn+1);
atantab = int16(round(atan(zc)*(2^(15))));     % 16-bit values tabulated
atantab = int32(int32(atantab)*(2^(16)));      % move to upper half of 32-bit
datantab = int32(round(diff(atan(zc))*2^(16+nn))); % 16-bit unsigned

z = 0:0.001:1-1e-10;

zint  = uint8(floor(z*2^nn));          % integer part
zfrac = int32(mod(z*2^15,2^(15-nn)));  % fractional part

res = zeros(size(z)); res2 = res;
for k = 1:length(z);
  ind = zint(k)+1;
  res(k) = int32(atantab(ind) + zfrac(k)*datantab(ind));
end%for

res = res/2^(31);

figure(1); plot(z,res-atan(z),'b')
           xlabel('z'); ylabel('error'); grid on

accuracybits = log2(max(abs(res-atan(z))*4/pi))
