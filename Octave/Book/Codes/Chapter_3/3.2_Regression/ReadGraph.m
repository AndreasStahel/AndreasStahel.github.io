%  read the graph in the document NSHU550ALEDwide.pdf, page 9

				
pause(2); % wait 2 seconds
[xi,yi] = xinput([0 90 0 1]);

figure(1);
plot(xi,yi);

round(xi);
intensity = round(1000*abs(yi))/1000;


save -ascii 'LEDdata.txt' angle intensity
