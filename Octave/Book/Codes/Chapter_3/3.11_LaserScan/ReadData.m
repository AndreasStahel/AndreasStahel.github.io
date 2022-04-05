% read each of the three data files
x = load('Xmatnew1.txt'); y = load('Ymatnew1.txt');
z = load('Zmatnew1.txt');
[nstep,npix] = size(x);

figure(1); mesh(x,y,z);
           view(50,30); xlabel('x'); ylabel('y'); zlabel('z');

% read the rotated data
xR = load('Xmatnew2.txt'); yR = load('Ymatnew2.txt');
zR = load('Zmatnew2.txt');
