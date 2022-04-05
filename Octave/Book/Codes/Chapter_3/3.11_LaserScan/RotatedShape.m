x0 = 10.508;
y0 =  5.897;

xn = +yR-y0+x0;
yn = -xR+x0+y0;

figure(4); mesh(xn,yn,zR)
           xlabel('x'); ylabel('y'); zlabel('z rotated');

zInt = griddata(xn,yn,zR,xlin,ylin,'nearest');
znew = (1-tip).*zlin + tip.*zInt;

figure(5); mesh(xlin,ylin,znew)
           xlabel('x'); ylabel('y'); zlabel('z combined');
           view(50,60)