%% approximation to atan using integer operations only
a0 = 0.283642707;     i0 = uint16(a0*2^8)
a1 = 1.073115615;     i1 = uint16(a1*2^15)
a2 = 0.003113205848;  i2 = uint16(a2*2^16)

myatan =@(z)-0.003113205848 + z.*( 1.073115615  - z*0.283642707);

z = 0:0.001:1;
zi = uint16(z*2^8);

r1 = uint16(zi.*i0);
limits1 = [min(r1) max(r1)]

r2 = uint16(i1-r1/2);
limits2 = [min(r2) max(r2)]

r3 = uint16(zi.*bitshift(r2,-7));
limits3 = [min(r3) max(r3)]

r4 = uint16(r3-i2);
limits4 = [min(r4) max(r4)]
res = single(r4)/2^16;


figure(1); plot(z,res,z,atan(z))
           xlabel('z'); ylabel('atan(z)'); 
           grid on

figure(2); plot(z,double(res)-atan(z),'r',z,myatan(z)-atan(z),'b')
           legend('int16','float'); legend('show')
           xlabel('z'); grid on
