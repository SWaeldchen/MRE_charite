#!/bin/bash
DATE=`date +'%Y%m%d-%H%M%S'`
#cd "${0%/*}"; 
#screen -S fmre2D -dmS script -c 'matlab -nodesktop -r "exec_fMRE2D_short_03;quit"' /home/andi/fMRE2D-$DATE.log

#nohup matlab2015a -r "pipeline_modico_afsh_3T(1);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub1-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(2);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub2-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(3);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub3-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(4);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub4-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(5);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub5-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(6);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub6-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(7);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub7-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(8);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub8-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(9);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub9-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(10);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub10-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(11);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub11-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(12);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub12-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(13);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub13-$DATE.log 2>&1 &
nohup matlab2015a -r "pipeline_modico_afsh_3T(14);quit" > /home/stefanh/HETZER/mrdata/MODICO/DATA/project_modico_3T_sub14-$DATE.log 2>&1 &



