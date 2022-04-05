I0 = 1e-4;  S0 = 1 - I0;  R0 = 0; % the initial values
b = 1/3; k = 1/10;                % the model parameters
%% b = 1/8;                       % use a smaller infection rate

%% for MATLAB comment out this function and put it a file SIR.m
%function res = SIR(t,I,R,b,k) %%x = IR
%res = [(+b-k-b*I-b*R).*I;  k*I];
%end%function

[t,IR] = ode45(@(t,x)SIR(t,x(1),x(2),b,k),linspace(0,600,601),[I0,R0]);

figure(1); plot(t,IR)
           xlabel('time [days]');
           ylabel('fraction of Infected and Recovered')
           ylim([-0.05 1.05])
           legend('infected','recovered', 'location','east')
           
[I,R] = meshgrid(linspace(0.01,1,15),linspace(0,0.99,15)); 
I = I(:); R = R(:);
VV = SIR(0,I',R',b,k)';
VI = VV(:,1); VR = VV(:,2);


figure(2)
quiver(I,R,VI,VR)
xlabel('Infected'); ylabel('Recovered')
axis([0 1,0 1])
hold on
plot(IR(:,1),IR(:,2),'r')
hold off

NormV = sqrt(VI.^2+VR.^2);
figure(3)
quiver(I,R,VI./NormV,VR./NormV)
xlabel('Infected'); ylabel('Recovered')
axis([0 1,0 1])
hold on
plot(IR(:,1),IR(:,2),'r')
hold off


