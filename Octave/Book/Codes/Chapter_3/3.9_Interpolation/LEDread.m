more off
% show messages for the user
disp('Left mouse button picks points.')
disp('Right mouse button to quit.')
pause(2);  % give the user some time to get the graph in the foreground
[xi,yi] = xinput([0 90 0 1])        % read the points
figure(1); plot(xi,yi);
           grid on; axis('normal');
           xlabel('angle'); ylabel('intensity');