movie = 1; %% switch to generate movie 0: no movie, 1: movie generated
cd pngmovie
k = 1;
plot3(x(:,k),y(:,k),h(:,k));
xlabel('x'); ylabel('y'); zlabel('h');
axis([-14 14 -14 14 -360 80])
grid on
for k = 1:nt
   plot3(x(:,k),y(:,k),h(:,k),'*-');
   axis([-14 14 -14 14 -360 80])
   xlabel('x'); ylabel('y'); zlabel('h');
   grid on
   drawnow();
if movie
   filename = ['movie',sprintf('%03i',k),'.png'];
   print(filename,'-dpng')
end%if
end%for

if movie
  c1 = 'mencoder mf://*.png -mf fps=5 -ovc lavc -lavcopts vcodec=mpeg4';
  c2 = ' -o Circle.avi';
  system([c1,c2]);
  system('rm -f *.png');
end%if
cd ..
