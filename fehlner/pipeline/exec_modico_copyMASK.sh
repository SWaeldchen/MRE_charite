#!/bin/bash

cd /store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/

OUTDIR=/store01_analysis/stefanh/MRDATA/MODICO_MASKS2/
mkdir $OUTDIR

find  * -type f -name "MNI_c*.nii" -exec cp --parents -t $OUTDIR {} +
find  * -type f -name "TPM00*.nii" -exec cp --parents -t $OUTDIR {} +
find  * -type f -name "wMAG*_mask.nii" -exec cp --parents -t $OUTDIR {} +

