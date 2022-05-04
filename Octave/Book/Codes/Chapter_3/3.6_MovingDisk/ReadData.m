%%script to read the data of the deformation of a watch caliber 2842
%% 3D version of February 19, 2003

%% Definition of variables

%% nt number of points to be read
nt = 345;
%% skip number of frames to be ignored before the next image is created
skip = 5;
%% lineskip number of lines to be ignored for the header
lineskip = 1; 
%% nt*skip < number of points to be measured
%% Npts number of measurement points on caliber
Npts = 8;

%% define the matrices for the coordinate data of points
x = zeros(Npts+1,nt);
y = zeros(Npts+1,nt);
t = zeros(Npts+1,nt);
h = zeros(Npts+1,nt);

x(1,:) = -12.0; %% first line of x
x(2,:) = -8.4;
x(3,:) = 0;
x(4,:) = 8.4;
x(5,:) = 12;
x(6,:) = 8.4;
x(7,:) = 0;
x(8,:) = -8.4;
x(9,:) = -12.0; %% copy of the first line

y(1,:) = 0;   %% first line of y
y(2,:) = -8.4;
y(3,:) = -12;
y(4,:) = -8.4;
y(5,:) = 0;
y(6,:) = 8.4;
y(7,:) = 12;
y(8,:) = 8.4;
y(9,:) = 0; %% copy of the first line

%% read the data and generate plots

row = 1;
fid = fopen('cg1a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

row = 2;
fid = fopen('cg10a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

row = 3;
fid = fopen('cg8a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

row = 4;
fid = fopen('cg13a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

row = 5;
fid = fopen('cg6a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

row = 6;
fid = fopen('cg12a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

row = 7;
fid = fopen('cg9a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

row = 8;
fid = fopen('cg11a.txt','r');
for ii = 1:lineskip
  tline = fgets(fid);
end
for ii = 1:nt
  for s = 1:skip tline = fgets(fid);end
  res = sscanf(tline,'%e %e');
  t(row,ii) = res(1);
  h(row,ii) = res(2);
end
fclose(fid);

% copy first point to last point
t(9,:) = t(1,:);
h(9,:) = h(1,:);

k = 20;
plot3(x(:,k),y(:,k),h(:,k));
xlabel('x'); ylabel('y'); zlabel('z');
grid on
