more off
% show messages for the user
disp('Left mouse button picks points.')
disp('Right mouse button to quit.')
disp('first click on the corner r=1 at angle 90')
disp('then click on the corner r=1 at angle 0')
pause(2);  % give the user some time to get the graph in the foreground
[xi,yi] = xinput([0 1 0 1]);        % read the points
xi = 1-xi;
figure(1); plot(xi,yi);

al = pi/2-atan2(yi,xi);
Intensity = sqrt(xi.^2 + yi.^2);
figure(2); plot(al*180/pi,Intensity),
           axis('normal'); grid on