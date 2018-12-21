#!/bin/bash

#give logg as a parameter:
LOGG=$1
GSURFACE=$(echo "e($LOGG*l(10))" | bc -l)


# Physical Parameters
#LOGTEFF=6.0 #5.9 #6.0 #6.30102999566 #6.5   # Log Target effective temperature, K
LOGTEFFS=(5.5 5.6 5.7 5.8 5.9 6.0 6.1 6.2 6.3 6.4 6.5 6.6) 
RUNN=${#LOGTEFFS[@]} #12
echo "Run McPhac for this many Teffs:"
echo $RUNN

#GSURFACE=2.43e14 #2.432204009e14 #2.43e14   # Surface gravitational acceleration, cm s-2
#loggs of [13.7,13.8,...14.5,14,6] correspond:
#GSURFACEs [5.01187e13, ...] 
#echo "l(5.01187*10^13)/l(10)" | bc -l
#exit
#LOGGS=(13.7 13.8 13.9 14.0 14.1 14.2 14.3 14.4 14.5 14.6) 
#GSURFACES=(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0)  
#for ((i=0;i<=${#LOGGS[@]};i++));do
#	LOGG=${LOGGS[$i]}
#	echo $LOGG
#	GSURFACES[$i]=$(echo "e($LOGG*l(10))" | bc -l)
#	echo ${GSURFACES[$i]}
#done
##echo ${GSURFACES[0]}
##exit

# Computational parameters
MINCOL=-9.0 # Min. log(y) considered for Teff<10^6.5K
#MAXCOL=2.0 # Initial max. log(y), increased if necessary to meet MAXTAUTAU criterion
#MINCOL=-5.0 # Min. log(y) considered for Teff=10^6.5K
MAXCOL=3.0 #4.0 #2.0 # Initial max. log(y), increased if necessary to meet MAXTAUTAU criterion
#MINCOL=-8.0 # Min. log(y) considered in Z96 for Teff=10^5.3K
#MAXCOL=-0.6 # Max. log(y) considered in Z96 for Teff=10^5.3K (set MAXCOLTAU=0.01 to keep unchanged)
#MINCOL=-7.7 # Min. log(y) considered in Z96 for Teff=10^5.6K
#MAXCOL=0.2 # Max. log(y) considered in Z96 for Teff=10^5.6K (set MAXCOLTAU=0.01 to keep unchanged)
#MINCOL=-7.4 # Min. log(y) considered in Z96 for Teff=10^5.9K
#MAXCOL=0.9 # Max. log(y) considered in Z96 for Teff=10^5.9K (set MAXCOLTAU=0.01 to keep unchanged)
#MINCOL=-7.0 # Min. log(y) considered in Z96 for Teff=10^6.2K (not shown, so taken to be average of 5.9 and 6.5)
#MAXCOL=1.4 # Max. log(y) considered in Z96 for Teff=10^6.2K (set MAXCOLTAU=0.01 to keep unchanged)
#MINCOL=-6.6 # Min. log(y) considered in Z96 for Teff=10^6.5K
#MAXCOL=1.9 # Max. log(y) considered in Z96 for Teff=10^6.5K (set MAXCOLTAU=0.01 to keep unchanged)

MAXCOLTAU=1000.0 #10000.0 #80.0  # Consider log(y) large enough to have at least MAXCOLTAU optical depths at the largest freq.
#MAXCOLTAU=0.01  # Set this value of MAXCOLTAU to keep the largest y considered unchanged

TGUESSBDYCOND=0.264837817  # Ratio of T to Teff at the surface to use for initial temperature profile

NDEPTHS=500 #200   # Initial number of depths points in the temperature correction
MAXFACTOR=1   # Maximum factor to multiply NDEPTHS by (NDEPTHS doubled until and including this factor)
NDEPTHSNU=500 #200 # Initial number of depths points in the radiative transfer
MAXFACTORNU=1 # Maximum factor to multiply NDEPTHSNU by (NDEPTHSNU doubled until and including this factor)
NMU=10        # Number of mu points over range [0,1]
NFREQ=360 #1000 #100     # Number of photon frequency bins

MAXFRACTEMPCHANGE=0.000001 #0.0001  # Continue iteration until max. fractional temp. change < MAXFRACTEMPCHANGE
MAXITER=20 # Maximum number of iterations allowed

ANIST=1 #0  # Whether or not to treat Thomson scattering anisotropically (should only be set if FEAUTRIER is)

for ((i=0;i<=RUNN;i++));do
	echo ${GSURFACES[9]}
	LOGTEFF=${LOGTEFFS[${i}]} #Log Target effective temperature, K
	# Run McPHAC
	cmnd="./McPHAC $LOGTEFF $GSURFACE $MINCOL $MAXCOL $NDEPTHS $MAXFACTOR $NDEPTHSNU $MAXFACTOR $NMU $NFREQ $MAXFRACTEMPCHANGE $MAXITER $ANIST $MAXCOLTAU $TGUESSBDYCOND"
	#drive parallel with different logg:
	#cmnd="./McPHAC $LOGTEFF $GSURFACES[0] $MINCOL $MAXCOL $NDEPTHS $MAXFACTOR $NDEPTHSNU $MAXFACTOR $NMU $NFREQ $MAXFRACTEMPCHANGE $MAXITER $ANIST $MAXCOLTAU $TGUESSBDYCOND" #&
	#P1=$!
	#cmnd="./McPHAC $LOGTEFF $GSURFACES[1] $MINCOL $MAXCOL $NDEPTHS $MAXFACTOR $NDEPTHSNU $MAXFACTOR $NMU $NFREQ $MAXFRACTEMPCHANGE $MAXITER $ANIST $MAXCOLTAU $TGUESSBDYCOND" &
	#P2=$!
	#cmnd="./McPHAC $LOGTEFF $GSURFACES[2] $MINCOL $MAXCOL $NDEPTHS $MAXFACTOR $NDEPTHSNU $MAXFACTOR $NMU $NFREQ $MAXFRACTEMPCHANGE $MAXITER $ANIST $MAXCOLTAU $TGUESSBDYCOND" &
	#P3=$!
	#wait $P1 $P2 #$P3 #$P4 $P5
	echo $cmnd
	$cmnd
done
