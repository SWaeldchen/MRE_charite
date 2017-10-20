function pipeline_modico_parkinson(subjectlist)

myCluster = parcluster('local');
myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
saveProfile(myCluster);

if ~exist('subjectlist','var')
    subjectlist = 1:45;
end

%% Set Paths, Directories, Functions, Subjects and Fixed Parameters
% paths for spm, modico, infun and rician

addpath(genpath('/home/realtime/spm12/'));
addpath(genpath('/home/realtime/project_modico/pipeline'));
PROJ_DIR = '/store01_analysis/realtime/IN/';

PIC_DIR = fullfile(PROJ_DIR,'PICS');
if ~exist(PIC_DIR,'dir'), mkdir(PIC_DIR); end

disp(path);
modicomod = 0;
list_process = {'orig','moco'}; %,'dico','modico'};

pixel_spacing = [1.9 1.9]/1000;
freqs = [30	50	40	45	35	25];

% PROBID,MPRAGE,RLmag,LRmag,dynseriesmag,freqseries,slices

% group 
% HC = 0
% PSP = 1
% IPS = 2

Asubject_cell={
 {'MMRE_PSP_fh_2014_01_30',2,0,0,[5 7 9 11 13 15],freqs,16,30,2015,1}
 {'MMRE_PSP_bf_2014_01_30',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,1}
 {'MMRE_PSP_mh_2014_01_28',2,0,0,[5 7 9 11 13 15],freqs,15,15,2015,1}
 {'MMRE_PSP_gg_2014_01_28',2,0,0,[5 7 9 13 15 17],freqs,15,15,2015,1}
 {'MMRE_PSP_dw_2014_01_28',2,0,0,[3	5 7	9 11 15],freqs,15,15,2015,1}
 {'MMRE_PSP_kg_2014_02_13',2,0,0,[3 5 7 11 13 15],freqs,15,15,2015,1}
 %{'MMRE_PSP_kg_2014_02_28',2,0,0,[3 5 7 11 13 15],freqs,15,15,2015,1} % -> 2_28 ? -> 2_13
 {'MMRE_PSP_mg_2014_02_10',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE_PSP_ro_2014_02_06',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE_PSP_ir_2014_02_21',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE_PSP_vm_2014_02_21',2,0,0,[3	7 9 11 13 15],freqs,15,15,2015,1}
 {'MMRE-PSP-bm-2014-03-18_20140318-134826',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-sb-2014-03-18_20140318-150051',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-kj-2014-03-18_20140318-104245',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-ak-2014-03-26_20140326-182208',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 %{'MMRE_PSP_eg_2014_05_09',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-hb-2014-06-20_20140620-160851',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-oe-2014-07-08_20140708-131939',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-mw-2014-07-25_20140725-110819',2,0,0,[3	5 7	9 11 15],freqs,15,15,2015,1}
 {'MMRE-PSP-gg-2014-07-25_20140725-120954',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-kw-2014-07-25_20140725-142354',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-br-2014-07-25_20140725-152753',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1} 
 {'MMRE_IPS_rs_2014_02_19',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE_IPS_me_2014_02_19',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-ips-eg-2014-05-09_20140509-154422',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-m-2014-05-09_20140509-162330',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-rf-2014-07-08_20140708-115436',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IP-sk-2014-11-06_20141106-171148',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IP-eg-2014-11-06_20141106-175712',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-FW-2014-12-11_20141211-184807',2,0,0,[3 5 7 9 11 15],freqs,15,15,2015,2} 
{'MMRE-IPS-AO-2015-02-17_20150217-180155',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-hj-2015-02-26_20150226-180106',2,0,0,[3	5 7	9 13 15],freqs,15,15,2015,2}
{'MMRE-IPS-hd-2015-06-10_20150610-175828',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-ips-ke-2015-06-10_20150610-183201',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-bt-2015-06-24_20150624-123048',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-sd-2015-06-24_20150624-135352',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-lj-2015-06-24_20150624-144413',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-ea-2015-06-24_20150624-152324',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE-IPS-sa-2015-06-24_20150624-163401',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2}
{'MMRE_HC_an_2014_01_28',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE_af_2014_01_20',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,0}
{'MMRE_HC_rg_2014_02_06',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE_HC_gh_2014_01_30',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-sj-2014-03-18_20140318-111826',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-rm-2014-03-18_20140318-142101',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-kn-2014-03-18_20140318-172230',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-rp-2014-03-18_20140318-163010',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-uv-2014-03-18_20140318-165640',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-sf-2014-07-08_20140708-122615',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-po-2014-07-08_20140708-135040',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}
{'MMRE-HC-fg-2014-07-25_20140725-124813',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0}};

rowHeadings={'name','mprage','refRL','refLR','dynma','dynfreqs','nslices','tesla','year','groupname'};

for ksub = 1:size(Asubject_cell,1)
    TMP_c2s = cell2struct(Asubject_cell{ksub}',rowHeadings,1);
    Asubject1(ksub) = TMP_c2s;
    Asubject2(ksub).dynph = Asubject1(ksub).dynma + 1;
end
Asubject = catstruct(Asubject1,Asubject2);

subjectlist = 1:length(Asubject);
%subjectlist = 17;
%subjectlist = 20:40;

% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'))

wrapper_processmodico(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing,modicomod,[1.9 1.9 1.9]);

% Reassign old library paths
setenv('LD_LIBRARY_PATH',MatlabPath)

%class_analysemodico.plotoverview_EPI(PROJ_DIR,Asubject_cell);
%class_analysemodico.plotoverview_MNI(PROJ_DIR,Asubject_cell);
%class_processmodico.clean_data(PROJ_DIR,Asubject,subjectlist);


end
