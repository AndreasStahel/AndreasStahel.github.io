force = load('ForceData.dat'); % read the data
dist  = load('DistanceData.dat');

% select the useful domain
xMin = 2; xMax = 13;
ind = find ((dist>=xMin).*(dist<=xMax));
dist = dist(ind); force = force(ind);

% choose a horizontal position for the break point
x_c = 5;

M = ones(length(dist),3);
M(:,2) = dist(:);
M(:,3) = max(0,dist(:)-x_c);
[p,y_var,r,p_var] = LinearRegression(M,force);
[p sqrt(p_var)]
force_fit = M*p;

force_off = 10 + 2*dist + 3*max(0,dist-x_c);  

figure(1); plot(dist, force,'b', dist,force_off,'m', dist,force_fit,'r')
           legend('raw data','force shape','fitted data','location','northwest')
           xlabel('position'); ylabel('force')

%function  sigma = EvaluateBreak(x_c,dist,force)
%  M = ones(length(dist),3);
%  M(:,2) = dist(:);
%  M(:,3) = max(0,dist(:)-x_c);
%  [p,sigma] = LinearRegression(M,force(:));
%  sigma = mean(sigma);
%end%function

x_list = 2:0.5:12;
sigma_list = zeros(size(x_list));

for k = 1:length(x_list)
  sigma_list(k) = EvaluateBreak(x_list(k),dist,force);
end%for

figure(2); plot(x_list,sigma_list)
           xlabel('position of break'); ylabel('sigma')
[x_opt,sigma_opt,Info] = fminunc (@(x_c)EvaluateBreak(x_c,dist,force),5)

M = ones(length(dist),3);
M(:,2) = dist(:); M(:,3) = max(0,dist(:)-x_opt);
[p,y_var,r,p_var] = LinearRegression(M,force);
param = [p sqrt(p_var)]
force_fit = M*p;

figure(3); plot(dist, force, 'b', dist, force_fit,'r')
           legend('raw data','best fit','location','northwest')
           xlabel('position'); ylabel('force')