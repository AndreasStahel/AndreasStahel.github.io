y = -1:0.2:1;  v = -1:0.2:1;  n = length(y); m = length(v);
Vx = zeros(n,m); Vy = Vx; % create zero vectors for the vector field

%function ydot = Spring(y)
%  ydot = zeros(size(y));
%  k = 1; al = 0.1;
%  ydot(1) = y(2);
%  ydot(2) = -k*y(1)-al*y(2);
%end%function

for i = 1:n
  for j = 1:m
    z = Spring([y(i),v(j)]);        % compute the vector
    Vx(i,j) = z(1); Vy(i,j) = z(2); % store the components
  end%for
end%for

t = linspace(0,25,100);
[t,XY] = ode45(@(t,y)Spring(y),t,[0;1]);

figure(1); plot(t,XY)
           xlabel('time'); legend('displacement','velocity')
           axis(); grid on

figure(2); plot(XY(:,1),XY(:,2),'g'); % plot solution, phase portrait
           axis([min(y),max(y),min(v),max(v)]);
           hold on
           quiver(y,v,Vx',Vy','b');
           xlabel('displacement'); ylabel('velocity');
           grid on; hold off
