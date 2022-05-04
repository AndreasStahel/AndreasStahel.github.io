a0 = -0.06211012633; i0 = int32(a0*2^16)
a1 = -0.1904775175;  i1 = int16(a1*2^16)
a2 = +1.038178669 ;  i2 = int32(a2*2^14)
a3 = -0.0011722644;  i3 = int16(a3*2^14)

myatan = @(z)-0.0011722644 +z.*(1.038178669 + z.*(-0.1904775175-z*0.06211012633));

z  = 0:0.001:1;
zi = int32(z*2^15);

r1 = int32(zi.*i0);      %% 15+16
limits1 = [min(r1) max(r1)]

r2 = i1+int16(bitshift(r1,-15));  %% 16
limits2 = [min(r2) max(r2)]

r3 = int32(zi.*int32(bitshift(r2,-2)));  %%16-2+15=29
limits3 = [min(r3) max(r3)]

r4 = bitshift(r3,-15)+i2;        %% 29-15 =14
limits4 = [min(r4) max(r4)]

r5 = int32(zi.*int32(r4));       %% 14+15 =29
limits5=[min(r5) max(r5)]

r6 = int16(bitshift(r5,-15))+i3; %% 29-15
limits6 = [min(r4) max(r4)]

res = single(r6)*2^-14;

figure(1); plot(z,res-atan(z),'r',z,myatan(z)-atan(z),'b')
           xlabel('z'); ylabel('difference');
           legend('int32','float'); grid on
