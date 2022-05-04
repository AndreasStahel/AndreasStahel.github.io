n   = sqrt(length(Hz));
HzM = reshape(Hz,n,n);
Hz0 = HzM(floor(n/2)+1,floor(n/2)+1)
reldev = abs(HzM-Hz0)/Hz0;
mesh(xx,zz,reldev)
xlabel('x'); ylabel('z')
