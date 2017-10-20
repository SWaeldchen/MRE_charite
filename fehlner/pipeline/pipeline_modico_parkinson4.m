function pipeline_modico_parkinson4(subjectlist)

% myCluster = parcluster('local');
% myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
% saveProfile(myCluster);

if ~exist('subjectlist','var')
    subjectlist = 1:45;
end

%% Set Paths, Directories, Functions, Subjects and Fixed Parameters
% paths for spm, modico, infun and rician

% addpath(genpath('/home/realtime/spm12/'));
% addpath(genpath('/home/realtime/project_modico/pipeline'));
% PROJ_DIR = '/store01_analysis/realtime/IN/';

addpath(genpath('/home/andi/af_domhome/work/mretools/project_parkinson_3Dnew/'));

PROJ_DIR = '/media/afdata/parkinson_data/';

PIC_DIR = fullfile(PROJ_DIR,'PICS_2016_06_15');
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
 {'MMRE_PSP_fh_2014_01_30',2,0,0,[5 7 9 11 13 15],freqs,16,30,2015,1,'PSP','fh'}
 {'MMRE_PSP_bf_2014_01_30',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,1,'PSP','bf'}
 {'MMRE_PSP_mh_2014_01_28',2,0,0,[5 7 9 11 13 15],freqs,15,15,2015,1,'PSP','mh'}
 {'MMRE_PSP_gg_2014_01_28',2,0,0,[5 7 9 13 15 17],freqs,15,15,2015,1,'PSP','gg'}
 {'MMRE_PSP_dw_2014_01_28',2,0,0,[3	5 7	9 11 15],freqs,15,15,2015,1,'PSP','dw'}
 {'MMRE_PSP_kg_2014_02_13',2,0,0,[3 5 7 11 13 15],freqs,15,15,2015,1,'PSP','kg'}
 %{'MMRE_PSP_kg_2014_02_28',2,0,0,[3 5 7 11 13 15],freqs,15,15,2015,1} % -> 2_28 ? -> 2_13
 {'MMRE_PSP_mg_2014_02_10',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','mg'}
 {'MMRE_PSP_ro_2014_02_06',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','ro'}
 {'MMRE_PSP_ir_2014_02_21',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','ir'}
 {'MMRE_PSP_vm_2014_02_21',2,0,0,[3	7 9 11 13 15],freqs,15,15,2015,1,'PSP','vm'}
 {'MMRE-PSP-bm-2014-03-18_20140318-134826',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','bm'}
 {'MMRE-PSP-sb-2014-03-18_20140318-150051',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','sb'}
 {'MMRE-PSP-kj-2014-03-18_20140318-104245',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','kj'}
{'MMRE-PSP-ak-2014-03-26_20140326-182208',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','ak'}
 %{'MMRE_PSP_eg_2014_05_09',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,1}
 {'MMRE-PSP-hb-2014-06-20_20140620-160851',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','hb'}
 {'MMRE-PSP-oe-2014-07-08_20140708-131939',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','oe'}
 {'MMRE-PSP-mw-2014-07-25_20140725-110819',2,0,0,[3	5 7	9 11 15],freqs,15,15,2015,1,'PSP','mw'}
 {'MMRE-PSP-gg-2014-07-25_20140725-120954',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','gg'}
 {'MMRE-PSP-kw-2014-07-25_20140725-142354',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','kw'}
 {'MMRE-PSP-br-2014-07-25_20140725-152753',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,1,'PSP','br'} 
 {'MMRE_IPS_rs_2014_02_19',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','rs'}
{'MMRE_IPS_me_2014_02_19',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','me'}
{'MMRE-ips-eg-2014-05-09_20140509-154422',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','eg'}
{'MMRE-IPS-m-2014-05-09_20140509-162330',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','m'}
{'MMRE-IPS-rf-2014-07-08_20140708-115436',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','rf'}
{'MMRE-IP-sk-2014-11-06_20141106-171148',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','sk'}
{'MMRE-IP-eg-2014-11-06_20141106-175712',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','eg'}
{'MMRE-IPS-FW-2014-12-11_20141211-184807',2,0,0,[3 5 7 9 11 15],freqs,15,15,2015,2,'IPS','fw'} 
{'MMRE-IPS-AO-2015-02-17_20150217-180155',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,2,'IPS','ao'} 
{'MMRE-IPS-hj-2015-02-26_20150226-180106',2,0,0,[3	5 7	9 13 15],freqs,15,15,2015,2,'IPS','hj'} 
{'MMRE-IPS-hd-2015-06-10_20150610-175828',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','hd'} 
{'MMRE-ips-ke-2015-06-10_20150610-183201',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','ke'} 
{'MMRE-IPS-bt-2015-06-24_20150624-123048',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','bt'} 
{'MMRE-IPS-sd-2015-06-24_20150624-135352',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','sd'} 
{'MMRE-IPS-lj-2015-06-24_20150624-144413',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','lj'} 
{'MMRE-IPS-ea-2015-06-24_20150624-152324',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','ea'} 
{'MMRE-IPS-sa-2015-06-24_20150624-163401',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,2,'IPS','sa'} 
{'MMRE_HC_an_2014_01_28',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','an'} 
{'MMRE_af_2014_01_20',2,0,0,[3	5 7	9 11 13],freqs,15,15,2015,0,'control','af'} 
{'MMRE_HC_rg_2014_02_06',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','rg'} 
{'MMRE_HC_gh_2014_01_30',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','gh'} 
{'MMRE-HC-sj-2014-03-18_20140318-111826',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','sj'} 
{'MMRE-HC-rm-2014-03-18_20140318-142101',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','rm'} 
{'MMRE-HC-kn-2014-03-18_20140318-172230',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','kn'} 
{'MMRE-HC-rp-2014-03-18_20140318-163010',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','rp'} 
{'MMRE-HC-uv-2014-03-18_20140318-165640',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','uv'} 
{'MMRE-HC-sf-2014-07-08_20140708-122615',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','sf'} 
{'MMRE-HC-po-2014-07-08_20140708-135040',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','po'} 
{'MMRE-HC-fg-2014-07-25_20140725-124813',2,0,0,[3 5 7 9 11 13],freqs,15,15,2015,0,'control','fg'}};

rowHeadings={'name','mprage','refRL','refLR','dynma','dynfreqs','nslices','tesla','year','groupname','groupdic','nameid'};

for ksub = 1:size(Asubject_cell,1)
    TMP_c2s = cell2struct(Asubject_cell{ksub}',rowHeadings,1);
    Asubject1(ksub) = TMP_c2s;
    Asubject2(ksub).dynph = Asubject1(ksub).dynma + 1;
end
Asubject = catstruct(Asubject1,Asubject2);

subjectlist = 1:length(Asubject);

MatlabPath = getenv('LD_LIBRARY_PATH');
setenv('LD_LIBRARY_PATH',getenv('PATH'))

%freqs = [30	50	40	45	35	25];
list_HC = '';
list_PSP = '';
list_IPS = '';

% group
% HC = 0
% PSP = 1
% IPS = 2


Apos_HC = find(cell2mat({Asubject.groupname}') == 0);
Apos_PSP = find(cell2mat({Asubject.groupname}') == 1);
Apos_IPS = find(cell2mat({Asubject.groupname}') == 2);


for ksub = subjectlist
    disp(['Subnum: ' int2str(ksub)]);
    
    if ~exist(fullfile(PROJ_DIR,Asubject(ksub).groupdic,Asubject(ksub).nameid,'Res.mat'),'file')
        
        load(fullfile(PROJ_DIR,Asubject(ksub).groupdic,Asubject(ksub).nameid,'W_wrap_RL.mat'));
        
        W_wrap_low  = W_wrap(:,:,:,:,:,[6 1 5]);
        W_wrap_high = W_wrap(:,:,:,:,:,[3 4 2]);
        W_wrap_all  = W_wrap(:,:,:,:,:,[6 1 5 3 4 2]);
        
        [reslow.ABSG,reslow.PHI,reslow.ABSG_o,reslow.PHI_o,reslow.AMP_o] = evalmmref(W_wrap_low,[25 30 35],pixel_spacing);
        [reshigh.ABSG,reshigh.PHI,reshigh.ABSG_o,reshigh.PHI_o,reshigh.AMP_o] = evalmmref(W_wrap_high,[40 45 50],pixel_spacing);
        [resall.ABSG,resall.PHI,resall.ABSG_o,resall.PHI_o,resall.AMP_o] = evalmmref(W_wrap_all,[25 30 35 40 45 50],pixel_spacing);
        
        save(fullfile(PROJ_DIR,Asubject(ksub).groupdic,Asubject(ksub).nameid,'Res.mat'),'reslow','reshigh','resall');
        
    end
    
    if exist(fullfile(PROJ_DIR,Asubject(ksub).groupdic,Asubject(ksub).nameid,'Res.mat'),'file')
       tmpdata = load(fullfile(PROJ_DIR,Asubject(ksub).groupdic,Asubject(ksub).nameid,'Res.mat'));
             
       cd(fullfile(PROJ_DIR,Asubject(ksub).groupdic,Asubject(ksub).nameid));
       
       
       tmpBW_C = load('caudatus_3Droi.mat');
       tmpBW_F = load('frontal_3Droi.mat');
       tmpBW_M = load('mesencephalon_3Droi.mat');
       tmpBW_S = load('striatum_3Droi.mat');

       tmpBW_C = logical(tmpBW_C.BW);
       tmpBW_F = logical(tmpBW_F.BW);
       tmpBW_M = logical(tmpBW_M.BW);
       tmpBW_S = logical(tmpBW_S.BW);
       
       result_ABSG(ksub,1,1) = median(tmpdata.reslow.ABSG(tmpBW_C));
       result_ABSG(ksub,1,2) = median(tmpdata.reslow.ABSG(tmpBW_F));
       result_ABSG(ksub,1,3) = median(tmpdata.reslow.ABSG(tmpBW_M));
       result_ABSG(ksub,1,4) = median(tmpdata.reslow.ABSG(tmpBW_S));       
       result_ABSG(ksub,2,1) = median(tmpdata.reshigh.ABSG(tmpBW_C));
       result_ABSG(ksub,2,2) = median(tmpdata.reshigh.ABSG(tmpBW_F));
       result_ABSG(ksub,2,3) = median(tmpdata.reshigh.ABSG(tmpBW_M));
       result_ABSG(ksub,2,4) = median(tmpdata.reshigh.ABSG(tmpBW_S));       
       result_ABSG(ksub,3,1) = median(tmpdata.resall.ABSG(tmpBW_C));
       result_ABSG(ksub,3,2) = median(tmpdata.resall.ABSG(tmpBW_F));
       result_ABSG(ksub,3,3) = median(tmpdata.resall.ABSG(tmpBW_M));
       result_ABSG(ksub,3,4) = median(tmpdata.resall.ABSG(tmpBW_S));
              
       result_PHI(ksub,1,1) = median(tmpdata.reslow.PHI(tmpBW_C));
       result_PHI(ksub,1,2) = median(tmpdata.reslow.PHI(tmpBW_F));
       result_PHI(ksub,1,3) = median(tmpdata.reslow.PHI(tmpBW_M));
       result_PHI(ksub,1,4) = median(tmpdata.reslow.PHI(tmpBW_S));
       result_PHI(ksub,2,1) = median(tmpdata.reshigh.PHI(tmpBW_C));
       result_PHI(ksub,2,2) = median(tmpdata.reshigh.PHI(tmpBW_F));
       result_PHI(ksub,2,3) = median(tmpdata.reshigh.PHI(tmpBW_M));
       result_PHI(ksub,2,4) = median(tmpdata.reshigh.PHI(tmpBW_S));
       result_PHI(ksub,3,1) = median(tmpdata.resall.PHI(tmpBW_C));
       result_PHI(ksub,3,2) = median(tmpdata.resall.PHI(tmpBW_F));
       result_PHI(ksub,3,3) = median(tmpdata.resall.PHI(tmpBW_M));
       result_PHI(ksub,3,4) = median(tmpdata.resall.PHI(tmpBW_S));
       
       result_AMP(ksub,1,1) = median(tmpdata.reslow.AMP_o(tmpBW_C));
       result_AMP(ksub,1,2) = median(tmpdata.reslow.AMP_o(tmpBW_F));
       result_AMP(ksub,1,3) = median(tmpdata.reslow.AMP_o(tmpBW_M));
       result_AMP(ksub,1,4) = median(tmpdata.reslow.AMP_o(tmpBW_S));
       result_AMP(ksub,2,1) = median(tmpdata.reshigh.AMP_o(tmpBW_C));
       result_AMP(ksub,2,2) = median(tmpdata.reshigh.AMP_o(tmpBW_F));
       result_AMP(ksub,2,3) = median(tmpdata.reshigh.AMP_o(tmpBW_M));
       result_AMP(ksub,2,4) = median(tmpdata.reshigh.AMP_o(tmpBW_S));
       result_AMP(ksub,3,1) = median(tmpdata.resall.AMP_o(tmpBW_C));
       result_AMP(ksub,3,2) = median(tmpdata.resall.AMP_o(tmpBW_F));
       result_AMP(ksub,3,3) = median(tmpdata.resall.AMP_o(tmpBW_M));
       result_AMP(ksub,3,4) = median(tmpdata.resall.AMP_o(tmpBW_S));
       
              
    end
    
        
    
    %      if ( Asubject(ksub).groupname == 0)
    %          list_HC = [list_HC ksub];
    %      end
    %
    %      if ( Asubject(ksub).groupname == 1)
    %          list_PSP = [list_PSP ksub];
    %      end
    %
    %      if ( Asubject(ksub).groupname == 2)
    %          list_IPS = [list_IPS ksub];
    %      end
    
end


save(fullfile(PROJ_DIR,'result_ABSGPHI.mat'),'result_ABSG','result_PHI');

setenv('LD_LIBRARY_PATH',MatlabPath)

tval={'caudatus','frontal','mesencephalon','striatum'};
klowhighalltxt = {'low','high','all'};


res_stat_ABSG = make_boxplotsgroup(PIC_DIR,result_ABSG,Apos_HC,Apos_PSP,Apos_IPS,'ABSG',1000,1500);
res_stat_PHI = make_boxplotsgroup(PIC_DIR,result_PHI,Apos_HC,Apos_PSP,Apos_IPS,'PHI',1,1);
res_stat_AMP = make_boxplotsgroup(PIC_DIR,result_AMP,Apos_HC,Apos_PSP,Apos_IPS,'AMP',40,40);

save(fullfile(PROJ_DIR,'result_stat_ABSGPHIAMP.mat'),'res_stat_ABSG','res_stat_PHI','res_stat_AMP');

plot2dwaves(cat(3,res_stat_ABSG.h12,res_stat_ABSG.h13,res_stat_ABSG.h23));
plot2dwaves(cat(3,res_stat_ABSG.p12,res_stat_ABSG.p13,res_stat_ABSG.p23));

plot2dwaves(cat(3,res_stat_PHI.h12,res_stat_PHI.h13,res_stat_PHI.h23));
plot2dwaves(cat(3,res_stat_PHI.p12,res_stat_PHI.p13,res_stat_PHI.p23));


struct2table(res_stat_ABSG)



end


function res = make_boxplotsgroup(PIC_DIR,result_ABSG,Apos_HC,Apos_PSP,Apos_IPS,txtpara,thres1,thres2)

tval={'caudatus','frontal','mesencephalon','striatum'};
klowhighalltxt = {'low','high','all'};

for klowhighall = 1 : 3
    figure(klowhighall);
    for kregion=1:4
        subplot(2,2,kregion);
        
        TMP_HC = result_ABSG(Apos_HC,klowhighall,kregion);
        TMP_PSP = result_ABSG(Apos_PSP,klowhighall,kregion);
        TMP_IPS = result_ABSG(Apos_IPS,klowhighall,kregion);
        
        singlebox(TMP_HC);
        singlebox(TMP_PSP);
        singlebox(TMP_IPS);
        
        [res.h12(klowhighall,kregion),res.p12(klowhighall,kregion)] = ttest2(TMP_HC,TMP_PSP);
        [res.h13(klowhighall,kregion),res.p13(klowhighall,kregion)] = ttest2(TMP_HC,TMP_IPS);
        [res.h23(klowhighall,kregion),res.p23(klowhighall,kregion)] = ttest2(TMP_PSP,TMP_IPS);
        sigstar({[1,2],[1,3],[2,3]},[res.p12(klowhighall,kregion),res.p13(klowhighall,kregion),res.p23(klowhighall,kregion)]);
        if (klowhighall == 1)
            ylim([0 thres1]);
        else
            ylim([0 thres2]);
        end
        set(gca,'Xtick',1:3,'XTickLabel',{'HC','PSP','IPS'});
        xlabel(tval(kregion));
    end
    [ax4,h3] = suplabel([txtpara ' ' klowhighalltxt{klowhighall}],'t');
    set(h3,'FontSize',20);
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    saveas(gcf,fullfile(PIC_DIR,['PIC_' txtpara '_' klowhighalltxt{klowhighall} '.png']));
    close all
end
end

