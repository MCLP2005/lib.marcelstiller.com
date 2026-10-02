set terminal svg size 2000,1000 background '#eeeeee' enhanced font 'Verdana,18'
set datafile separator ';'
set title "CGI Requests hitting this Node"
set xlabel "Time"
set ylabel "Number of processed requests per minute"
set xdata time
set timefmt "%Y-%m-%d %H:%M"
set format x "%Y-%m-%d %H:%M"
set yrange [0:]
set logscale y 10
set tics textcolor "black"
set xtics rotate by 90 right

set out "/var/www/html/monitoring/graphics/local_all.svg"
set xrange [:]
plot "/data/cgi.csv" using 1:2 with lines lw 3 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 3 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 3 lc rgb "#0000ff" title "style"

set out "/var/www/html/monitoring/graphics/local.svg"
set xrange [system("date -u -d '6 days ago' +'%F 00:00'"):system("date -u +'%F 24:00'")]
plot "/data/cgi.csv" using 1:2 with lines lw 3 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 3 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 3 lc rgb "#0000ff" title "style"

set out "/var/www/html/monitoring/graphics/local_3d.svg"
set xrange [system("date -u -d '2 days ago' +'%F 00:00'"):system("date -u +'%F 24:00'")]
plot "/data/cgi.csv" using 1:2 with lines lw 3 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 3 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 3 lc rgb "#0000ff" title "style"

set out "/var/www/html/monitoring/graphics/local_14d.svg"
set xrange [system("date -u -d '13 days ago' +'%F 00:00'"):system("date -u +'%F 24:00'")]
plot "/data/cgi.csv" using 1:2 with lines lw 3 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 3 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 3 lc rgb "#0000ff" title "style"

set out "/var/www/html/monitoring/graphics/local_21d.svg"
set xrange [system("date -u -d '20 days ago' +'%F 00:00'"):system("date -u +'%F 24:00'")]
plot "/data/cgi.csv" using 1:2 with lines lw 3 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 3 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 3 lc rgb "#0000ff" title "style"

set out "/var/www/html/monitoring/graphics/local_30d.svg"
set xrange [system("date -u -d '29 days ago' +'%F 00:00'"):system("date -u +'%F 24:00'")]
plot "/data/cgi.csv" using 1:2 with lines lw 3 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 3 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 3 lc rgb "#0000ff" title "style"

set out "/var/www/html/monitoring/graphics/local_90d.svg"
set xrange [system("date -u -d '89 days ago' +'%F 00:00'"):system("date -u +'%F 24:00'")]
plot "/data/cgi.csv" using 1:2 with lines lw 3 lc rgb "#008080" title "Easteregg", \
        "/data/cgi.csv" using 1:3 with lines lw 3 lc rgb "#00ff00" title "deathscreen", \
        "/data/cgi.csv" using 1:4 with lines lw 3 lc rgb "#0000ff" title "style"
