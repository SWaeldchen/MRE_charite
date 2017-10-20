function pipeline_modico_cor3T(subjectlist)

myCluster = parcluster('local');
myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
saveProfile(myCluster);

if ~exist('subjectlist','var')
    subjectlist = 1:6;
end

%% Set Paths, Directories, Functions, Subjects and Fixed Parameters
% paths for spm, modico, infun and rician

addpath(genpath('/home/realtime/spm12/'));
addpath(genpath('/home/realtime/project_modico/pipeline'));
PROJ_DIR = '/store01_analysis/realtime/cor3T/';

PIC_DIR = fullfile(PROJ_DIR,'PICS');
if ~exist(PIC_DIR,'dir'), mkdir(PIC_DIR); end

disp(path);
modicomod = 2;
list_process = {'orig','moco','dico','modico'};

pixel_spacing = [1.9 1.9]/1000;
freqs = [60 30 50 40 45 35 55];

% PROBID,MPRAGE,RLmag,LRmag,dynseriesmag,freqseries,slices

Asubject_cell={
    %%{'MRE-SAI-032_20150513-113445',2,5,7,3,freqs,16,30,2015}
    {'MRE-IGT-061_20150121-120005',2,5,7,3,freqs,16,30,2015}
    {'MRE-IGT-063_20150527-130230',3,6,8,4,freqs,16,30,2015}
     {'MRE-IGT-075_20150526-140312',2,5,7,3,freqs,16,30,2015}
%     {'MRE-MAD012_20150311-125205',0,4,6,2,freqs,16,30,2015} % k  Mprage
%     {'MRE-MAD-016_20150128-121210',0,25,27,23,freqs,16,30,2015} % k Mprage
%     {'MRE-MAD-019_20150318-123702',0,4,6,2,freqs,16,30,2015}
%     {'MRE-MAD-022_20150506-135028',0,4,6,2,freqs,16,30,2015}
%     {'MRE-MAD-023_20150527-123100',0,4,6,2,freqs,16,30,2015}
%     {'MRE-MAD-025_20151007-124911',0,7,9,5,freqs,16,30,2015}
%     {'MRE-MAD-901_20150828-103644',0,4,6,2,freqs,16,30,2015}
%     {'MRE-MAD-902_20150828-103644',0,4,6,2,freqs,16,30,2015}
%     {'MRE-MAD-902_20150812-124050',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-014_20150326-185125',0,6,8,4,freqs,16,30,2015}
%     {'MRE-SAI-017_20150401-134211',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-018_20150526-150944',0,4,6,2,freqs,16,30,2015}
%     {'SAI-019_20150807-105448',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-028_20150807-095458',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-029_20150828-092526',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-030_20150504-123954',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-031_20150603-113843',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-033_20150604-094413',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-034_20150527-144413',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-035_20150617-133946',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-036_20150617-113841',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-037_20150624-143820',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-038_20150729-123552',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-039_20150629-113748',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-040_20150716-094210',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-041_20151014-115410',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-042_20150708-110927',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-044_20150831-143240',0,4,6,2,freqs,16,30,2015}
%     {'SAI-047_20150928-150426',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-051_20150814-112248',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-054_20150812-133717',0,4,6,2,freqs,16,30,2015}
%     {'MRE-SAI-055_20150821-115315',0,4,6,2,freqs,16,30,2015}
     {'MRE-LOC-A-011_20150527-132949',2,5,7,3,freqs,16,30,2015}
     {'MRE-LOC-A-010_20150603-131312',2,5,7,3,freqs,16,30,2015}
     {'MRE-LOC-A-022_20150603-121124',2,5,7,3,freqs,16,30,2015}
%     {'MRE-LOC-A-042_20150918-154246',0,4,6,2,freqs,16,30,2015}
%     {'MRE-LOC-A-045_20150504-154132',0,4,6,2,freqs,16,30,2015}
%     {'MRE-LOC-A-053_20150826-123733',0,4,6,2,freqs,16,30,2015}
%     {'MRE-LOC-A-054_20150504-164136',0,4,6,2,freqs,16,30,2015}
%     {'MRE-LOC-A-046_20150731-093945',0,4,6,2,freqs,16,30,2015}
%     {'MRE-LOC-A-056_20150814-095708',0,5,6,3,freqs,16,30,2015}
 %%   {'NAP-M-010_20150209-153611',13,18,20,16,freqs,16,30,2015}
    };

rowHeadings={'name','mprage','refRL','refLR','dynma','dynfreqs','nslices','tesla','year'};

for ksub = 1:size(Asubject_cell,1)
    TMP_c2s = cell2struct(Asubject_cell{ksub}',rowHeadings,1);
    Asubject1(ksub) = TMP_c2s;
    Asubject2(ksub).dynph = Asubject1(ksub).dynma + 1;
end
Asubject = catstruct(Asubject1,Asubject2);

subjectlist = 1:6;

%wrapper_processmodico(PROJ_DIR,Asubject,subjectlist,freqs,pixel_spacing,modicomod,[1.9 1.9 1.9]);

class_analysemodico.plotoverview_EPI(PROJ_DIR,Asubject_cell);
class_analysemodico.plotoverview_MNI(PROJ_DIR,Asubject_cell);

%class_processmodico.clean_data(PROJ_DIR,Asubject,subjectlist);


end
