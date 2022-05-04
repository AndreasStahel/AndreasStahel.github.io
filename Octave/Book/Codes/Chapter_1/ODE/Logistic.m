t_max = 5; p_max = 3;
[t,p] = meshgrid(linspace(0, t_max,20),linspace(0,p_max,20));
v1 = ones(size(t)); v2 = p.*(2-p);
figure(1);  quiver(t,p,v1,v2)
            xlabel('time t'); ylabel('population p')
            axis([0 t_max, 0 p_max])

[t1,p1] = ode45(@(t,p)p.*(2-p),linspace(0,t_max,50),0.4);
[t2,p2] = ode45(@(t,p)p.*(2-p),linspace(0,t_max,50),3.0);
[t3,p3] = ode45(@(t,p)p.*(2-p),linspace(0,t_max,50),0.01);
hold on
plot(t1,p1,'r',t2,p2,'r', t3,p3,'r')
hold off
