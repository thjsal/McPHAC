#!/bin/bash
./McPHAC_loop.bash 13.7 &
P1=$!
./McPHAC_loop.bash 13.8 &
P2=$!
#./McPHAC_loop.bash 13.9 &
#P3=$!
wait $P1 $P2 #$P3 #$P4 $P5
