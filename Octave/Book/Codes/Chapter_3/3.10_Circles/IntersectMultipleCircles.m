% a set of 3 circles
centers = [0,0; 3,3; 0 3];
radii   = [2.3; 2.2; 1.7];

%% a set of four circles
%centers = [0,0;8,0;4,0;3,3];
%radii   = [5;5;3;1];
%% add a fifth circle
%c5 = [4,3] + 0.7*[cos(pi/6),sin(pi/6)];
%centers = [centers;c5]; radii = [radii;0.6];

% generate the plots
angle = linspace(0,2*pi,200); xr = cos(angle); yr = sin(angle);
figure(1); clf
hold on
for ii = 1:length(radii)
  plot(centers(ii,1)+radii(ii)*xr,centers(ii,2)+radii(ii)*yr)
end%for
hold off

% construct the overdetermined linear system
N = length(radii);
M = zeros(N-1,2); b = zeros(N-1,1);

for ii = 1:N-1
  M(ii,:) = 2*(centers(ii,:)-centers(ii+1,:));
  b(ii) = radii(ii+1)^2-radii(ii)^2-sum(centers(ii+1,:).^2)+sum(centers(ii,:).^2);
end%for
xy = M\b
residum = norm(M*xy-b)

hold on
plot(xy(1),xy(2),'or') % mark the point of intersection in red
hold off
axis equal; axis([-3 6 -3 6])
xlabel('x'); ylabel('y')
