function res = IntersectSpheres(M1,r1,M2,r2,M3,r3)
% find the intersection points of three spheres
% Mi is a row vector with the three components of the center
% ri is the radius of the i-th sphere

% create the matrix and vector for the linear system
A = 2*[M2-M1;M3-M2];
b = [r1^2-norm(M1)^2-r2^2+norm(M2)^2;r2^2-norm(M2)^2-r3^2+norm(M3)^2];

% determine a particular solution xp and the homogeneous solution v
xp = A\b;
v  = null(A);

% determine coefficients of the quadratic equation
a = v'*v;
b = 2*v'*(xp-M1');
c = norm(xp-M1')^2-r1^2;

% solve the quadratic equation
D = b^2-4*a*c;  % discriminant
if (D<0)
  sprintf('no intersection points')
  res = [];
else
  % compute the two solutions
  t1  = (-b+sqrt(D))/(2*a);
  t2  = (-b-sqrt(D))/(2*a);
  res = [xp + t1*v,xp + t2*v];
end
