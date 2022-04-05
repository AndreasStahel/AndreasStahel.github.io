figure(1);                     % write to the first graphic window
clf
axislimits = [0 2 0 1];        % x values from 0 to 2 and y values from 0 to 1
axis(axislimits)               % fixed axis for the graphs
x = []; y = [];                % initialise the empty matrix of values

% show messages for the user
disp('Use the left mouse button to pick points.')
disp('Use the right mouse button to pick the last point.')
button = 1;                       % boolean variable to indicate the last point
while button == 1                 % while loop, picking up the points.
    [xi,yi,button] = ginput(1);   % get coodinates of one point
    x = [x,xi]; y = [y,yi];
    plot(x,y,'ro')             % plot all points
    axis(axislimits);          % fix the axis
end
plot(x,y,'ro-')
xlabel('x'); ylabel('y')