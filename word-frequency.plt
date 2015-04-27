# gnuplot bar plot word frequency by gender

reset

set terminal pngcairo size 800,600 enhanced font "Verdana, 10"
set output "heise-open-writers.png"

set title  "Heise Open Redakteure" font "Verdana, 14"
set ylabel "Prozent am Gesamttext" font "Verdana, 12"
set xlabel "Wortart" font "Verdana, 12"

set style line 1 lt 1 lc rgb "#ab003c"
set style line 2 lt 1 lc rgb "#006b55"
set style line 3 lt 1 lc rgb "#7f7f5f"

set style data histogram
set style histogram cluster gap 1

set boxwidth 0.7
set style fill solid border rgb "black"

set grid ytics linestyle 3

set auto x
set yrange [0:*]

plot 'heise-writers.dat' using 2:xtic(1) title col, \
     'heise-writers.dat' using 3:xtic(1) title col

