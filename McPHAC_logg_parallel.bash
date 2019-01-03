trap 'kill %1; kill %2; kill %3; kill %4' SIGINT
./McPHAC_loop.bash 14.2 & ./McPHAC_loop.bash 14.3 & ./McPHAC_loop.bash 14.4 & ./McPHAC_loop.bash 14.5 & ./McPHAC_loop.bash 14.6 &
#./McPHAC_loop.bash 14.2 #&
#wait $P1 $P2 #$P3 #$P4 $P5
