a0 =  0.14017184670506358;     i0 = int32(a0*2^15)
a1 = -0.34245381909783135;     i1 = int16(a1*2^15)
a2 = -0.015262708673125458;    i2 = int16(a2*2^15)
a3 =  1.0031357062620350346;   i3 = int16(a3*2^14)
a3 =  1.0032357062620350346;   i3 = int16(a3*2^14)%patched slope
a4 = -0.00007717176023065795;  i4 = int16(a4*2^15)

myatan = @(x)-0.00007717176023065795 + 1.0031357062620350346*x ...
       -  0.015262708673125458*x.^2 -  0.34245381909783135*x.^3 ...
       +  0.14017184670506358*x.^4;

z  = 0:0.001:1;   zi = int32(z*2^15);

r1 = int32(zi.*i0);      %% 15+16=30
limits1 = [min(r1) max(r1)]
r2 = int16(bitshift(r1,-15))+i1;  %% 30-15=15
limits2 = [min(r2) max(r2)]
r3 = int32(zi.*int32(r2));  %%15+15=30
limits3 = [min(r3) max(r3)]
r4 = int16(bitshift(r3,-15))+i2;     %% 30-15 =15
limits4 = [min(r4) max(r4)]
r5 = int32(zi.*int32(r4));    %% 15+15 =30
limits5 = [min(r5) max(r5)]
r6 = int16(bitshift(r5,-16))+i3; %% 30-16=14
limits6 = [min(r6) max(r6)]
r7 = int32(zi.*int32(r6));    %% 14+15 =29
limits5 = [min(r7) max(r7)]
r8 = int16(bitshift(r7,-14))+i4; %% 29-14=15
limits6 = [min(r8) max(r8)]
res = double(r8)*2^-15;

plot(z,res-atan(z),z,myatan(z)-atan(z))
legend('int32','float')
xlabel('z'); ylabel('errors')

max_error = max(abs(res-atan(z)))
bitaccuracy = log2(max_error/pi*4)
