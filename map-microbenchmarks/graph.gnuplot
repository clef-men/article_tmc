set terminal svg \
  background rgb "white" \
  size 600,500 \
  font "Helvetica,14"

# # set those through the command-line with -e "source output ..."
# set output "data/map.svg"
# source="data/results.txt"

set title "Time elapsed (relative) – lower is better"

set logscale x 10
set xlabel "List size (no. of elements)"
set xrange [1:1000000]

set yrange [0:130]
set ylabel "Time relative to naive tail-recursive version (%)"

unset border
set tics scale 0

set key bottom horizontal
set key font ",13"

plot source using 1:2 with lines lc 1 lw 3 title "nontail", \
     source using 1:3 with lines lc 0 lw 3 title "tail", \
     source using 1:4 with lines lc 2 lw 3 title "base", \
     source using 1:5 with lines lc 3 lw 3 title "containers", \
     source using 1:6 with lines lc 4 lw 3 title "batteries", \
     source using 1:7 with lines lc 5 lw 3 title "tmc", \
     source using 1:8 with lines lc 6 lw 3 title "tmc-unrolled"
