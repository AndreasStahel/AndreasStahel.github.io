X = [ones(1,8);x(1:8,1)';y(1:8,1)']';
% nt=345;
par = zeros(3,nt);

for kk = 1:nt
  p = LinearRegression(X,h(1:8,kk));
  par(:,kk) = p;
end%for

figure(3); plot(t(1,:),par(1,:));
           grid on; axis([0 0.0036, -300, 50])
           xlabel('time'); ylabel('height'); grid on

figure(4); plot(t(1,:),par(2:3,:));
           grid on; axis([t(1,1), max(t(1,:)), -10, 10])
           xlabel('time'); ylabel('slopes');
           legend('x-slope','y-slope')
           axis([0, 0.0036 -10 10])
