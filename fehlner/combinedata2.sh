OUTDRIVE=/home/realtime/
OUTDIR=INOUT/
IND=/store01_analysis/realtime/IN/
mkdir $OUTDRIVE/$OUTDIR
find  $IND -type f -name "W_wrap_RL.mat" -exec cp --parents -t $OUTDRIVE/$OUTDIR/ {} +
