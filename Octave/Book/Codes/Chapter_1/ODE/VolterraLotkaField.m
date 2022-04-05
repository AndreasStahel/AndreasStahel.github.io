x = 0:0.2:2.6;  % define the x values to be examined
y = 0:0.2:2.0;  % define the y values to be examined

n  = length(x);  m  = length(y);
Vx = zeros(n,m); Vy = Vx; % create zero vectors for the vector field

for i = 1:n
  for j = 1:m
    v = VolterraLotka(0,[x(i),y(j)]); % compute the vector
    Vx(i,j) = v(1); Vy(i,j) = v(2);
  end%for
end%for

t  = linspace(0,15,100);
[t,XY] = ode45(@VolterraLotka,t,[2;1]);

figure(1); plot(t,XY)
           xlabel('time'); legend('prey','predator');
           axis([0,15,0,3]); grid on

figure(2);  quiver(x,y,Vx',Vy',2); hold on
            plot(XY(:,1),XY(:,2));
            axis([min(x),max(x),min(y),max(y)]);
            grid on; xlabel('prey'); ylabel('predator'); hold off
