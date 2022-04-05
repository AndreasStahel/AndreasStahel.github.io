ReadData  % read the data

f_exp_trig_lin = @(t,p)p(1)*exp(-p(2)*t).*cos(p(3)*t + p(4))+p(5)+p(6)*t;

p_in = zeros(6,1);  % guess for initial values for parameters
[fr,p] = leasqr(t,y,p_in,f_exp_trig_lin,1e-8);

y_fit1 = f_exp_trig_lin(t,p);
figure(1)
plot(t,y,t,y_fit1)
xlabel('t')
legend('y','y_fit')
grid on

p_in = [1,0,0.5,0,570,0]; % guess for initial values for parameters
[fr,p] = leasqr(t,y,p_in,f_exp_trig_lin,1e-8);
y_fit2 = f_exp_trig_lin(t,p);
figure(1)
plot(t,y,'+-',t,y_fit1,t,y_fit2)
xlabel('t')
legend('y','y_fit1','y_fit2')
grid on

%%% fitting a straight line
F = ones(length(t),2); F(:,2) = t;
pLin = LinearRegression(F,y)
yLin = F*pLin;

figure(2)
plot(t,y,'+-',t,yLin)
xlabel('t'); grid on
legend('y','yLin')

%%% nonlinear regression with leasqr
AEst = 50; alphaEst = log(16/12)/14; omegaEst = 0.5 ; phiEst = -15;

f_exp_trig = @(t,p)p(1)*exp(-p(2)*t).*cos(p(3)*t + p(4));

[fr,p,kvg,iter,corp,covp,covr,stdresid,Z,r2] =...
    leasqr(t,y-yLin,[AEst,alphaEst,omegaEst,phiEst],f_exp_trig,1e-4);
pVal = p'
pDev = sqrt(diag(covp))'

[fr,p,kvg,iter,corp,covp,covr,stdresid,Z,r2] =...
    leasqr(t,y-yLin,pVal,f_exp_trig,1e-8);
pVal = p
pDev = sqrt(diag(covp))'

yFit = f_exp_trig(t,p);

figure(3)
plot(t,y-yLin,'+-',t,yFit)
xlabel('t'); grid on
legend('y-yLin','yFit')
axis auto

%%% full nonlinear regression with leasqr
pNew = [p;pLin];

[fr,p2,kvg,iter,corp,covp,covr,stdresid,Z,r2] =...
    leasqr(t,y,pNew,f_exp_trig_lin,1e-8);
p2Val = p2
p2Dev = sqrt(diag(covp))'

yFit2 = f_exp_trig_lin(t,p2);

figure(3)
plot(t,y-yLin,'+-',t,yFit)
xlabel('t'); grid on
legend('y-yLin','yFit')
axis auto

figure(4)
plot(t,y,'+-',t,yFit2)
xlabel('t'); grid on
legend('y','yFit2')
