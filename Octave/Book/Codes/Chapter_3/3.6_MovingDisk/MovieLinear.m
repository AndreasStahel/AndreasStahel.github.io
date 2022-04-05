hlinear = X*par; hlinear(9,:) = hlinear(1,:); 
horiginal = h;   hdeform = h-hlinear; hdisp = hlinear;

movie = 0; %% switch to generate movie
cd pngmovie
k = 1;
figure(5); plot3(x(:,k),y(:,k),hdisp(:,k));
           xlabel('x'); ylabel('y'); zlabel('h');
           axis([-14 14 -14 14 -360 80]); grid on
for k = 1:nt
   plot3(x(:,k),y(:,k),hdisp(:,k));
   xlabel('x'); ylabel('y'); zlabel('h');
   axis([-14 14 -14 14 -360 80])
   grid on
   drawnow()
if movie 
   filename = ['movie',sprintf('%03i',k),'.png'];
   print(filename,'-dpng')
end%if
end%for

if movie
  c1 = 'mencoder mf://*.png -mf fps=25 -ovc lavc -lavcopts vcodec=mpeg4';
  c2 = ' -o movieLinear.avi';
  system([c1,c2]);
  system('rm -f *.png');
end%if
cd ..
