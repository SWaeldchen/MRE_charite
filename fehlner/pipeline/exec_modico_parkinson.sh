#!/bin/bash
DATE=`date +'%Y%m%d-%H%M%S'`
#cd "${0%/*}"; 
#screen -S fmre2D -dmS script -c 'matlab -nodesktop -r "exec_fMRE2D_short_03;quit"' /home/andi/fMRE2D-$DATE.log

#nohup matlab2015a -r "pipeline_modico_afsh_3T(1);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub1-$DATE.log 2>&1 &
#nohup matlab2015a -r "pipeline_modico_afsh_3T(2);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub2-$DATE.log 2>&1 &

nohup /opt/matlab/R2015a/bin/matlab -r "pipeline_modico_parkinson(1:46);quit" > /home/realtime/project_parkinson-$DATE.log 2>&1 &

