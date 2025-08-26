set terminal svg size 2000,1000 background '#eeeeee' enhanced font 'Verdana,18'
set datafile separator ';'
set title "Nutzung der Einzelnen CGI Skripte"
set xlabel "Zeit"
set ylabel "Anzahl an Aufrufen"
set xdata time
set timefmt "%Y-%m-%d %H:%M"
set xrange [system("date -u -d '2 days ago' +'%F 00:00'"):system("date -u +'%F 24:00'")]
set format x "%Y-%m-%d %H:%M"
set yrange [0:100]
set tics textcolor "black"
set xtics rotate by 90 right
set out "/var/www/html/monitoring/graphics/cgi.svg"
plot "/data/cgi.csv" using 1:2 with lines lw 5 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 5 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 5 lc rgb "#0000ff" title "style"
