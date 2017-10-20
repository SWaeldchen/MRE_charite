#!/bin/bash

cd /media/afdata/project_modico/

OUTDIR=/media/afdata/MREtmp12/
mkdir $OUTDIR


#find  * -type f -name "ABSG*" -exec cp --parents -t /media/afdata1/MREtmp4/ {} +
#find  * -type f -name "PHI*" -exec cp --parents -t /media/afdata1/MREtmp4/ {} +
#find  * -type f -name "MAG*" -exec cp --parents -t /media/afdata1/MREtmp4/ {} +
#find  * -type f -name "AMP*" -exec cp --parents -t /media/afdata1/MREtmp4/ {} +

#find  * -type f -name "RLdicoma.nii" -exec cp --parents -t /media/afdata/MREtmp4/ {} +
#find  * -type f -name "fieldMAGRL.nii" -exec cp --parents -t /media/afdata/MREtmp4/ {} +
#find  * -type f -name "my_field.nii" -exec cp --parents -t /media/afdata/MREtmp4/ {} +
#find  * -type f -name "MPRAGE.nii" -exec cp --parents -t /media/afdata/MREtmp4/ {} +

#find  * -type f -name "ABSG_*.nii" -exec cp --parents -t /media/afdata/MREtmp5/ {} +
#find  * -type f -name "PHI_*.nii" -exec cp --parents -t /media/afdata/MREtmp5/ {} +
#find  * -type f -name "AMP_*.nii" -exec cp --parents -t /media/afdata/MREtmp5/ {} +



#find  * -type f -name "wc*MPRAGE.nii" -exec cp --parents -t $OUTDIR/ {} +
#find  * -type f -name "wMPRAGE.nii" -exec cp --parents -t $OUTDIR {} +

#find  * -type f -name "wABSG*.nii" -exec cp --parents -t $OUTDIR/ {} +
#find  * -type f -name "wPHI*.nii" -exec cp --parents -t $OUTDIR/ {} +
#find  * -type f -name "wMAG*.nii" -exec cp --parents -t $OUTDIR {} +
 
#find  * -type f -name "wiy_orig_warpEPI2mprage.nii" -exec cp --parents -t $OUTDIR {} +
#find  * -type f -name "wiy_dico_warpEPI2mprage.nii" -exec cp --parents -t $OUTDIR {} +

find  * -type f -name "wmy_field.nii" -exec cp --parents -t $OUTDIR {} +

# wABSG (4x), wPHI (4x), wmy_field (mit y_fieldMAGRL2MNI), 6 Magn, meanM (orig/moco 2 MNI mit y_RLdicoma2MNI, dico,modico mit y_fieldMAGRL2MNI)
