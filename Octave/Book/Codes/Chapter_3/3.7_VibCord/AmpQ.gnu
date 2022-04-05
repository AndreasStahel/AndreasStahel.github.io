set terminal png large size 800,600 
set output 'AmpQ2.png'
set y2tics border 
set xlabel "Frequency (Hz)"
set ylabel "Amplitude" 
set y2label "Q-factor"
set grid
set xrange [14500:18000]
set yrange [4:7]
set y2range [2000:3500]
plot 'gnu.dat' using 1:2 with points lt 1 title 'Amplitude' axes x1y1,\
     'gnu.dat' using 1:3 with lines lt 1 notitle axes x1y1,\
     'gnu.dat' using 1:4 with lines lt 1 notitle axes x1y1,\
     'gnu.dat' using 1:5 with points lt 2 title 'Q-factor' axes x1y2,\
     'gnu.dat' using 1:6 with lines lt 2 notitle axes x1y2,\
     'gnu.dat' using 1:7 with lines lt 2 notitle axes x1y2

set terminal png large size 800,600 
set output 'AmpQ.png'
set y2tics border
set xlabel "Frequency [Hz]" 
set ylabel "Amplitude" 
set y2label "Q-factor"
set grid
set xrange [14500:18000]
set yrange [4:7]
set y2range [2000:3500]
plot 'gnu.dat' using 1:2 with lines title 'Amplitude' axes x1y1,\
     'gnu.dat' using 1:5 with lines title 'Q-factor' axes x1y2

set terminal png large size 600,480 
set output 'Temp.png'
set xlabel "Frequency [Hz]" 
set ylabel "Temperature [C]"
set noy2label
set noy2tics  
set grid
set xrange [14500:18000]
set yrange [*:*]
plot 'gnu.dat' using 1:8 with linespoints notitle
