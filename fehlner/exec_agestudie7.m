close all
clear all

MODEimportflynnfft='yes';
MODEspringpot='no';
MODEmasks='no';
MODEinversion='no';
MODEantswarpvis = 'no';
MODEcompareplotdiff = 'no';
MODEcreatepng='no';
MODEAmplitude='no';
MODEAmplitudeABSG='yes';
MODEAHIplot='no';
MODEplot3Slices='no';
MODEcombineresult_ROIS='no';
MODEplot3Slices_ROIS='no';
MODEplot3Slices_ROISsingle='no';

selectnumberfreq = 7;
kfilt = 100;
uh_filt = kfilt;

BASEDIR = '/home/andi/work/';

addpath([BASEDIR '/mretools/scripts/']);
addpath([BASEDIR '/mretools/extern/'])
addpath([BASEDIR '/mretools/script_HC/']);
addpath('/opt/matlab/toolbox/spm8/');

path = '/home/andi/work/mretools/script_HC/';

addpath '/home/andi/work/mretools/extern/plotSensitivity/';

OUTDIR = '/media/back_drive/data_tmp/';
OUTDIR_RAW = '/media/andi/mnt_datenbackup/MMRE_ImportUnwrap/';
OUTDIR_HC = [OUTDIR '/project_AGE/HC/'];
OUTDIR_RAW_HC = [OUTDIR_RAW '/HC/'];
DIRPROJ_AGE =[OUTDIR '/project_AGE/'];
ANTSDIR_HC = [DIRPROJ_AGE '/ANTSHC/'];
PICDIR = [OUTDIR '/project_AGE/PICS/'];

mkdir('/media/back_drive/data_tmp/project_AGE/ANTSHC/');
mkdir(PICDIR); cd(PICDIR);

disp([BASEDIR '/mretools/script_HC/']);

Nslice = 15;
Ntime = 8;
Ncomp = 3;
Nfreq = 7;

% Phase s1 s2 s3 Datumdatenoutput MPRAGE Alter Geschlecht
Asubject_HC = {
    {'MMRE_PB_cr_2013_02_07',6,5,7,9,2013,2,23,'w'}
    {'MMRE_HC_hs_2013_02_14',6,8,10,11,2013,0,55,'w'}
    {'MMRE_HC_ak_2013_07_02',6,1,3,4,2013,4,52,'w'}
    {'MMRE_HC_mk_2013_07_05',4,1,2,4,2013,2,31,'w'}
    {'MMRE_HC_reza_2013_07_03',4,1,2,3,2013,2,32,'m'}
    {'MMRE_HC_js_2013_07_17',4,3,5,7,2013,2,27,'w'}
    {'MMRE_HC_sf_2013_07_17',4,3,4,6,2013,2,26,'w'}
    {'MMRE_HC_eb_2013_11_14',4,1,3,4,2013,2,52,'w'}
    {'MMRE_HC_ht_2013_12_10',3,1,2,3,2013,0,29,'m'}
    {'MMRE_HC_fd_2013_12_11',3,1,2,3,2013,0,24,'m'}
    {'MMRE_HC_af_2014_01_06',3,7,9,12,2014,0,28,'m'}
    {'MMRE_HC_jb_2014_01_06',3,1,3,5,2014,0,53,'m'}
    {'MMRE_HC_sm_2014_01_07',4,2,4,7,2014,2,29,'m'}
    {'MMRE_HC_ah_2014_01_07',4,4,6,8,2014,2,50,'w'}
    {'MMRE_HC_yk_2014_01_07',4,4,6,9,2014,2,31,'w'}
    {'MMRE_HC_sp_2014_01_08',5,4,6,7,2014,3,41,'m'}
    {'MMRE_HC_ch_2014_01_08',4,2,4,5,2014,2,18,'m'}
    {'MMRE_HC_si_2014_01_08',4,1,3,5,2014,2,28,'w'}
    {'MMRE_HC_js_2014_01_08',4,2,4,6,2014,2,31,'m'}
    {'MMRE_HC_cw_2014_01_08',4,1,2,4,2014,2,39,'m'}
    {'MMRE_HC_jg_2014_01_08',4,2,5,7,2014,2,30,'w'}
    {'MMRE_HC_af1_2014_01_08',3,3,5,7,2014,0,28,'m'}
    {'MMRE_HC_af2_2014_01_08',4,3,5,7,2014,2,28,'m'}
    {'MMRE_HC_uw_2014_01_09',4,3,5,7,2014,2,65,'w'}
    {'MMRE_HC_kw_2014_01_10',4,2,5,7,2014,2,20,'w'}
    {'MMRE_HC_ts_2014_01_10',5,3,4,6,2014,3,25,'m'}
    {'MMRE_HC_sh_2014_01_10',4,3,5,7,2014,2,36,'m'}
    {'MMRE_HC_ur_2014_01_10',4,4,6,8,2014,2,56,'w'}
    {'MMRE_HC_es_2014_01_10',5,3,5,7,2014,2,48,'w'}
    {'MMRE_HC_sh_2014_01_14',6,3,5,7,2014,2,30,'m'}
    {'MMRE_HC_is_2014_01_14',4,2,4,6,2014,2,44,'m'}
    {'MMRE_HC_dk_2014_01_14',4,3,4,6,2014,2,41,'w'}
    {'MMRE_HC_ck_2014_01_15',4,4,5,6,2014,2,29,'w'}
    {'MMRE_HC_sk_2014_01_15',4,3,5,6,2014,2,44,'w'}
    {'MMRE_HC_rh_2014_01_15',4,3,5,6,2014,2,31,'m'}
    {'MMRE_HC_ch_2014_01_15',5,4,5,6,2014,2,52,'w'}
    {'MMRE_HC_kv_2014_01_15',4,3,5,6,2014,2,50,'m'}
    {'MMRE_HC_ss_2014_01_20',4,2,3,5,2014,2,61,'w'}
    {'MMRE_HC_nb_2014_01_22',5,2,4,6,2014,3,34,'w'}
    {'MMRE_HC_la_2014_01_27',4,4,6,8,2014,3,25,'m'}
    %    {'MMRE_HC_ss_2014_02_05',6,4,6,8,2014,3,25,'m'} fehlerhafte Sequenz
    %    {'MMRE_HC_ss_2014_02_10',4,4,6,8,2014,3,50,'m'} fehlerhafte Sequenz
    %    {'MMRE_HC_wz_2014_02_10',4,3,4,5,2014,3,49,'m'} fehlerhafte Sequenz
    {'MMRE_HC_jz_2014_02_10',4,2,4,6,2014,2,28,'w'} % Change s3
    {'MMRE_HC_cl_2014_02_11',4,4,6,7,2014,2,24,'w'}
    {'MMRE_HC_kk_2014_02_13',4,3,5,6,2014,2,26,'w'}
    {'MMRE_HC_af_2014_02_13',8,3,5,6,2014,2,28,'m'}
    {'MMRE_HC_lo_2014_02_26',4,3,5,6,2014,2,20,'m'}
    {'MMRE_HC_fp_2014_02_26',4,3,5,6,2014,2,28,'w'}
    {'MMRE_HC_wz_2014_03_01',4,2,4,6,2014,2,49,'m'}
    {'MMRE_HC_er_2014_03_01',4,2,3,4,2014,2,65,'m'}
    {'MMRE_HC_ir_2014_03_01',4,6,8,9,2014,2,62,'w'}
    {'MMRE_HC_tk_2014_03_06',6,3,6,7,2014,2,27,'w'}
    {'MMRE-HC-te-2014-03-18_20140318-184824',4,3,5,7,2014,2,28,'m'}
    {'MMRE-HC-ms-2014-03-18_20140318-191117',6,3,5,8,2014,2,28,'m'}
    {'MMRE-HC-cu-2014-03-18_20140318-193701',4,4,6,8,2014,2,25,'w'}
    {'MMRE-HC-sr-2014-03-28_20140328-093631',4,2,3,4,2014,2,55,'m'}
    {'MMRE-HC-mb-2014-03-28_20140328-102006',4,3,5,7,2014,2,51,'m'}
    {'MMRE-HC-fd-2014-04-02_20140402-124052',4,5,7,9,2014,2,24,'m'}
    {'MMRE-HC-ht-2014-04-02_20140402-122156',4,4,7,9,2014,2,29,'m'}
{'MMRE-HC-lg-2014-11-03-2_20141103-120247',4,0,0,0,2014,2,30,'m'}
    %{'MMRE-HC-si-2014-03-28_20140328-145955',4,0,0,0,2014,2,28,'w'}
    {'MMRE-HC-kp-2014-04-25_20140425-092750',4,0,0,0,2014,2,36,'w'}
    {'MMRE-HC-ir-2014-04-25_20140425-094752',4,0,0,0,2014,2,22,'w'}
    {'MMRE-HC-jh-2014-06-17_20140617-183459',4,0,0,0,2014,2,25,'m'}
    };

Asubject_HC_mo = {
    {'MMRE_HC_jb_2014_01_06'}
    {'MMRE_HC_sp_2014_01_08'}
    {'MMRE_HC_is_2014_01_14'}
    {'MMRE_HC_kv_2014_01_15'}
    {'MMRE_HC_wz_2014_03_01'}
    {'MMRE_HC_er_2014_03_01'}
    {'MMRE-HC-sr-2014-03-28_20140328-093631'}
    {'MMRE-HC-mb-2014-03-28_20140328-102006'}
    };

Asubject_HC_my = {
    {'MMRE_HC_reza_2013_07_03'}
    %{'MMRE_HC_ht_2013_12_10'}
    {'MMRE_HC_af1_2014_01_08'}
    {'MMRE_HC_ch_2014_01_08'}
    {'MMRE_HC_ts_2014_01_10'}
    {'MMRE_HC_la_2014_01_27'}
    {'MMRE_HC_sh_2014_01_14'}
    {'MMRE_HC_rh_2014_01_15'}
    {'MMRE_HC_js_2014_01_08'}
    {'MMRE_HC_lo_2014_02_26'}
    %{'MMRE-HC-te-2014-03-18_20140318-184824'}
    {'MMRE-HC-ms-2014-03-18_20140318-191117'}
    {'MMRE-HC-fd-2014-04-02_20140402-124052'}
    {'MMRE-HC-ht-2014-04-02_20140402-122156'}
    {'MMRE-HC-jh-2014-06-17_20140617-183459'}
    };

Asubject_HC_wy = {
    {'MMRE_PB_cr_2013_02_07'}
    {'MMRE_HC_mk_2013_07_05'}
    {'MMRE_HC_js_2013_07_17'}
    {'MMRE_HC_sf_2013_07_17'}
    {'MMRE_HC_yk_2014_01_07'}
    {'MMRE_HC_jg_2014_01_08'}
    {'MMRE_HC_kw_2014_01_10'}
    {'MMRE_HC_ck_2014_01_15'}
    {'MMRE_HC_nb_2014_01_22'}
    {'MMRE_HC_fp_2014_02_26'}
    {'MMRE_HC_kk_2014_02_13'}
    {'MMRE_HC_cl_2014_02_11'}
    {'MMRE_HC_jz_2014_02_10'}
    {'MMRE_HC_tk_2014_03_06'}
    {'MMRE-HC-cu-2014-03-18_20140318-193701'}
    };

Asubject_HC_wo = {
    {'MMRE_HC_hs_2013_02_14'}
    {'MMRE_HC_ak_2013_07_02'}
    {'MMRE_HC_eb_2013_11_14'}
    {'MMRE_HC_ah_2014_01_07'}
    {'MMRE_HC_uw_2014_01_09'}
    {'MMRE_HC_ur_2014_01_10'}
    {'MMRE_HC_es_2014_01_10'}
    {'MMRE_HC_ch_2014_01_15'}
    {'MMRE_HC_sk_2014_01_15'}
    {'MMRE_HC_ss_2014_01_20'}
    {'MMRE_HC_dk_2014_01_14'}
    {'MMRE_HC_ir_2014_03_01'}
    };


Asubject_CIS = {
    {'MMRE_uf_2012_10_31',3,4,6,8,2012}
    %{'MMRE_MS_ac_2012_12_17',8,5,8,10,2012}
    {'MMRE_MS_hh_2012_12_18',3,2,3,5,2012}
    {'MMRE_MS_ak_2013_02_20',4,3,5,7,2013}
    %{'MMRE_CIS0085',3,2,5,7,2013} %kein B2
    %{'MMRE_MMRE_MS_dr_2013_07_25',3,5,7,9,2013}
    {'MMRE_CIS_0089B3',3,4,8,9,2013}
    {'MMRE_CIS_0090',3,4,5,9,2013}
    %{'MMRE_CIS_0018B6_8',3,4,5,8,2013}
    {'MMRE_CIS_0093B3',3,5,8,9,2013}
    {'MMRE_CIS_0088B2_4_1',3,5,8,10,2014}
    {'MMRE_CIS_0092B2_3_1',3,3,5,7,2014}
    {'MMRE_CIS_0094B3_4_1',3,6,8,10,2014}
    {'MMRE_CIS_0100',3,5,7,10,2014}
    };


Asubject_HC_young = {Asubject_HC_wy{:},Asubject_HC_my{:}};
Asubject_HC_old = {Asubject_HC_wo{:},Asubject_HC_mo{:}};

for k = 1:length(Asubject_HC)
    Name{k}=cell2str(Asubject_HC{k}(1));
    alter(k)=cell2mat(Asubject_HC{k}(8));
    geschlecht(k)=cell2str(Asubject_HC{k}(9));
end;

for k=1:length(Asubject_HC_wy) index_wy(k) = find(strcmp(Name,Asubject_HC_wy{k})); end
for k=1:length(Asubject_HC_wo) index_wo(k) = find(strcmp(Name,Asubject_HC_wo{k})); end
for k=1:length(Asubject_HC_my) index_my(k) = find(strcmp(Name,Asubject_HC_my{k})); end
for k=1:length(Asubject_HC_mo) index_mo(k) = find(strcmp(Name,Asubject_HC_mo{k})); end

index_old = [index_mo index_wo];
index_young = [index_my index_wy];

G1 = Asubject_HC(index_wy);
G2 = Asubject_HC(index_wo);
G3 = Asubject_HC(index_my);
G4 = Asubject_HC(index_mo);
G5 = Asubject_HC(index_old);
G6 = Asubject_HC(index_young);

disp([length(G1) length(G2) length(G3) length(G4) length(G5) length(G6)]);
disp([mean(alter(index_wy)) mean(alter(index_wo)) mean(alter(index_my)) mean(alter(index_mo)) mean(alter([index_mo index_wo])) mean(alter([index_my index_wy]))]);
disp([std(alter(index_wy)) std(alter(index_wo)) std(alter(index_my)) std(alter(index_mo)) std([index_mo index_wo]) std([index_my index_wy])  ]);


%af_realign('/media/back_drive/data/FMMRE_sp_2013_10_23__1/','/media/back_drive/data_tmp/realigntest',7,8,'sp1');

TMP_DIR='/media/back_drive/data_tmp/realigntest/';
OUT_DIR='/media/back_drive/data_tmp/realigntest_pic/';
mkdir(OUT_DIR);

% for ksub=1:length(Asubject_HC)    
%     class_evaluation_age.realign(TMP_DIR,Asubject_HC,ksub,OUT_DIR)
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Masken

%class_evaluation_age.comb_mask_manuell(DIRPROJ_AGE,G1,G2,G3,G4,G5,G6);

if(strcmp(MODEimportflynnfft,'yes'))
    %script_prozess_allg('findSlice',Asubject_HC,1:length(Asubject_HC),Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC)
     script_prozess_allg4('import',Asubject_HC,1:length(Asubject_HC),Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC);
%     script_prozess_allg4('magnitude2BW',Asubject_HC,14:length(Asubject_HC),Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC);
%     script_prozess_allg4('unwrapflynn',Asubject_HC,1:length(Asubject_HC),Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC);
%     script_prozess_allg4('flynnfft',Asubject_HC,1:length(Asubject_HC),Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC);
    for ksub=1:length(Asubject_HC)
    %class_evaluation_age.import(OUTDIR_RAW_HC,Asubject_HC,ksub,Nslice,Ntime,Ncomp,Nfreq);
    %class_evaluation_age.unwrapflynn(OUTDIR_RAW_HC,Asubject_HC,ksub);
    %class_evaluation_age.flynnfft(OUTDIR_RAW_HC,Asubject_HC,ksub);
    fprintf([' ' int2str(ksub)]);
    class_evaluation_age.SNR_OSS_flynn(OUTDIR_RAW_HC,Asubject_HC,ksub,uh_filt);
    
    end    
    
end

%script_prozess_allg2('calc_erg',Asubject_HC,1:length(Asubject_HC),Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(MODEinversion,'yes'))
    for usenumberfreq = selectnumberfreq;
        
        for ksubject=1:length(Asubject_HC)
            RAWDIR = OUTDIR_RAW_HC;
            save_dir  = [RAWDIR cell2str(Asubject_HC{ksubject}(1)) '/']; % subject
            outsub    = [OUTDIR_HC cell2str(Asubject_HC{ksubject}(1)) '/']; %
            if(~exist(save_dir,'dir')), mkdir(save_dir); end
            if(~exist(outsub,'dir')), mkdir(outsub); end
            
            %class_evaluation_age.inversion_gradmdev(outsub,save_dir,usenumberfreq,kfilt);
            
            class_evaluation_age.inversion_gradmdevnoisecorrlin(outsub,save_dir,usenumberfreq,kfilt);
            %class_evaluation_age.inversion_flynncurlmdev(outsub,save_dir,usenumberfreq);
            %class_evaluation_age.inversion_AHI(outsub,save_dir,usenumberfreq);
            
            %script_prozess_allg4('inversion_heiko',Asubject_HC,1:lengt
            %h(Asubject_HC),Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC,kfreq);
            % script_prozess_allg4('inversion_AHI',Asubject_HC,ksub,Nslice,Ntime,Ncomp,Nfreq,OUTDIR_HC,path,OUTDIR_RAW_HC,kfreq);
        end
    end
end

%class_evaluation_age.AHI_springpot(OUTDIR_HC,Asubject_HC);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BWfront = load([DIRPROJ_AGE '/masks/Frontalpolcomb.mat'],'BW');
BWoccip = load([DIRPROJ_AGE '/masks/Occipitalcomb.mat'],'BW');
BWtemp  = load([DIRPROJ_AGE '/masks/Temporalcomb.mat'],'BW');

BWbox(:,:,:,1) = BWfront.BW;
BWbox(:,:,:,2) = BWoccip.BW;
BWbox(:,:,:,3) = BWtemp.BW;
BWbox(:,:,:,4) = BWfront.BW+BWoccip.BW+BWtemp.BW;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(MODEantswarpvis,'yes'))
    for kfreq = selectnumberfreq
        for kfilt = [30 50]
            class_evaluation_age.antswarpvis_grad(DIRPROJ_AGE,ANTSDIR_HC,OUTDIR_HC,OUTDIR_RAW_HC,G1,G2,G3,G4,G5,G6,BWbox,kfreq,kfilt);
        end
        
        class_evaluation_age.antswarpvis_flynn(DIRPROJ_AGE,ANTSDIR_HC,OUTDIR_HC,OUTDIR_RAW_HC,G1,G2,G3,G4,G5,G6,BWbox,kfreq);
        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(strcmp(MODEcompareplotdiff,'yes'))
    for kfreq=selectnumberfreq
    class_evaluation_age.af_compareplotdiff_grad(DIRPROJ_AGE,kfreq,kfilt,BWbox,PICDIR);
    class_evaluation_age.af_compareplotdiff_flynn(DIRPROJ_AGE,kfreq,BWbox,PICDIR);
    end
end

if(strcmp(MODEcreatepng,'yes'))
    for kfreq=selectnumberfreq
        for kfilt = [30 50]
            class_evaluation_age.createpng(PICDIR,kfreq,kfilt)
        end
    end
end



% Amplitudenutnersuchung


if(strcmp(MODEAmplitude,'yes'))
    
    
    for BWCASE=1:2 %{'Result_gradmdev_5_30','Result_gradmdev_5_30'}
        close all
        for ksubject = 1:length(Asubject_HC)
            cd([OUTDIR_HC cell2str(Asubject_HC{ksubject}(1)) '/']);
            disp([OUTDIR_HC cell2str(Asubject_HC{ksubject}(1)) '/']);
            %load([OUTDIR_HC cell2str(Asubject_HC{ksubject}(1)) '/Result_flynncurlmdev_7.mat']);
            load([OUTDIR_HC cell2str(Asubject_HC{ksubject}(1)) '/Result_gradmdev_5_30.mat']);
            
            if (BWCASE == 1)
                BW1 = logical(ABSG>1800);
                
                BWfilt = load([OUTDIR_RAW_HC cell2str(Asubject_HC{ksubject}(1)) '/BWfilt.mat']);
                for kslice = 1:size(BWfilt.BW,3)
                    BW2(:,:,kslice) = imfill(BWfilt.BW(:,:,kslice),'holes');
                end
                
                BW = logical(BW1.*BW2);
                
                %                 load([OUTDIR_RAW_HC cell2str(Asubject_HC{ksubject}(1)) '/M.mat']);
                %                 plot2dwaves(M);
                %                 clim = get(gca,'clim');
                %                 kids = get(gcf,'children');
                %                 ax = findobj(kids,'type','axes');
                %                 set(ax,'clim',clim);
                %                 contour_BW(BW);
                %                 saveas(gcf,[PICDIR '/Thresh_M_' cell2str(Asubject_HC{ksubject}(1)) '.jpg'])
                %                 plot2dwaves(ABSG);
                %                 clim = get(gca,'clim');
                %                 kids = get(gcf,'children');
                %                 ax = findobj(kids,'type','axes');
                %                 set(ax,'clim',clim);
                %                 contour_BW(BW);
                %                 saveas(gcf,[PICDIR '/Thresh_A_' cell2str(Asubject_HC{ksubject}(1)) '.jpg'])
                %
                %                 close
            end
            
            if (BWCASE == 2)
                load([OUTDIR_RAW_HC cell2str(Asubject_HC{ksubject}(1)) '/BWhbrain.mat']);
                
                %                 for kfreq = 1:size(AMP_FREQ,4)
                %                     AMP_FREQ_tmp = logical(AMP_FREQ(:,:,:,kfreq));
                %                     final_vals_all_single(ksubject,1,kfreq) = median(AMP_FREQ_tmp(BW));
                %                 end
                
            end
            
            final_vals_all(ksubject,1) = median(ABSG(BW));
            final_vals_all(ksubject,2) = median(PHI(BW));
            final_vals_all(ksubject,3) = median(AMP(BW));
            final_vals_all(ksubject,4) = cell2mat(Asubject_HC{ksubject}(8));
            
            [a_index,tmp] = find(final_vals_all(:,3)>4.5);
            
            %final_vals_all = final_vals_all(a_index,:);
            
        end
        
        index_w = [index_wo index_wy];
        index_m = [index_mo index_my];
        
        index_w = intersect(index_w,a_index);
        index_m = intersect(index_m,a_index);
        
        % Geschlechtfigure;
        subplot(2,2,1)
        hold on
        plot(final_vals_all(index_w,4),final_vals_all(index_w,1),'*r');
        plot(final_vals_all(index_m,4),final_vals_all(index_m,1),'*b');
        [age_m,index_sort_m]=sort(final_vals_all(index_m,4));
        [age_w,index_sort_w]=sort(final_vals_all(index_w,4));
        yp_r = polyfit(final_vals_all(index_w(index_sort_w),4),final_vals_all(index_w(index_sort_w),1),1);
        yp_b = polyfit(final_vals_all(index_m(index_sort_m),4),final_vals_all(index_m(index_sort_m),1),1);
        plot(final_vals_all(index_w(index_sort_w),4),polyval(yp_r,final_vals_all(index_w(index_sort_w),4)),'r-');
        plot(final_vals_all(index_m(index_sort_m),4),polyval(yp_b,final_vals_all(index_m(index_sort_m),4)),'b-');
        xlim([15 65]);
        ylim([2000 4000]);
        xlabel('ABSG');
        
        subplot(2,2,2);
        hold on
        plot(final_vals_all(index_w,4),final_vals_all(index_w,2),'*r');
        plot(final_vals_all(index_m,4),final_vals_all(index_m,2),'*b');
        yp_r = polyfit(final_vals_all(index_w(index_sort_w),4),final_vals_all(index_w(index_sort_w),2),1);
        yp_b = polyfit(final_vals_all(index_m(index_sort_m),4),final_vals_all(index_m(index_sort_m),2),1);
        plot(final_vals_all(index_w(index_sort_w),4),polyval(yp_r,final_vals_all(index_w(index_sort_w),4)),'r-');
        plot(final_vals_all(index_m(index_sort_m),4),polyval(yp_b,final_vals_all(index_m(index_sort_m),4)),'b-');
        xlabel('PHI');
        ylim([0.3 0.7]);
        xlim([15 65]);
        
        subplot(2,2,3);
        hold on
        plot(final_vals_all(index_w,4),final_vals_all(index_w,3),'*r');
        plot(final_vals_all(index_m,4),final_vals_all(index_m,3),'*b');
        yp_r = polyfit(final_vals_all(index_w(index_sort_w),4),final_vals_all(index_w(index_sort_w),3),1);
        yp_b = polyfit(final_vals_all(index_m(index_sort_m),4),final_vals_all(index_m(index_sort_m),3),1);
        plot(final_vals_all(index_w(index_sort_w),4),polyval(yp_r,final_vals_all(index_w(index_sort_w),4)),'r-');
        plot(final_vals_all(index_m(index_sort_m),4),polyval(yp_b,final_vals_all(index_m(index_sort_m),4)),'b-');
        xlim([15 65]);
        xlabel('AMP')
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        saveas(gcf,[PICDIR 'PLOT_AGE_MW_gradmdev_5_30__BWCASE' int2str(BWCASE) '.jpg'],'jpg');
        
        clear index_w index_m final_vals_all BW BW1 BW2 yp_r  yp_b
        
    end
    
end


% Amplituden-Untersuchung

kfreq = 7;
if(strcmp(MODEAmplitudeABSG,'yes'))
    class_evaluation_age.AmplitudeABSG(DIRPROJ_AGE,Asubject_HC,kfreq,kfilt);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(MODEAHIplot,'yes'))
    class_evaluation_age.AHIplot(DIRPROJ_AGE,OUTDIR_HC,Asubject_HC,index_wo,index_wy,index_mo,index_my);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3 Schichten

if(strcmp(MODEplot3Slices,'yes'))
    for kfreq = selectnumberfreq
    for kfilt = 50
    class_evaluation_age.plot3Slices(DIRPROJ_AGE,PICDIR,OUTDIR_HC,OUTDIR_RAW_HC,Asubject_HC,kfreq,...
        kfilt,index_mo,index_wo,index_my,index_wy,'gradmdev');
    class_evaluation_age.plot3Slices(DIRPROJ_AGE,PICDIR,OUTDIR_HC,OUTDIR_RAW_HC,Asubject_HC,kfreq,...
        kfilt,index_mo,index_wo,index_my,index_wy,'gradmdevnoisecorrlin');
    end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(strcmp(MODEcombineresult_ROIS,'yes'))
    for kfilt = [30 50]
        for kfreq = [3 4 5 6 7]
            txtname = ['Result_gradmdev_' int2str(kfreq) '_' int2str(kfilt) '.mat'];
            if (~exist([DIRPROJ_AGE 'comb_G1_' txtname],'file'))
                class_evaluation_age.af_combine_results(DIRPROJ_AGE,OUTDIR_HC,'G1',G1,txtname);
                class_evaluation_age.af_combine_results(DIRPROJ_AGE,OUTDIR_HC,'G2',G2,txtname);
                class_evaluation_age.af_combine_results(DIRPROJ_AGE,OUTDIR_HC,'G3',G3,txtname);
                class_evaluation_age.af_combine_results(DIRPROJ_AGE,OUTDIR_HC,'G4',G4,txtname);
                class_evaluation_age.af_combine_results(DIRPROJ_AGE,OUTDIR_HC,'G5',G5,txtname);
                class_evaluation_age.af_combine_results(DIRPROJ_AGE,OUTDIR_HC,'G6',G6,txtname);
            end
        end
        
        txtname2 = ['Result_gradmdev_sfreq_' int2str(kfilt) '.mat'];
        if (~exist([DIRPROJ_AGE 'comb_G1_' txtname2],'file'))
            class_evaluation_age.af_combine_results_single(DIRPROJ_AGE,OUTDIR_HC,'G1',G1,txtname2);
            class_evaluation_age.af_combine_results_single(DIRPROJ_AGE,OUTDIR_HC,'G2',G2,txtname2);
            class_evaluation_age.af_combine_results_single(DIRPROJ_AGE,OUTDIR_HC,'G3',G3,txtname2);
            class_evaluation_age.af_combine_results_single(DIRPROJ_AGE,OUTDIR_HC,'G4',G4,txtname2);
            class_evaluation_age.af_combine_results_single(DIRPROJ_AGE,OUTDIR_HC,'G5',G5,txtname2);
            class_evaluation_age.af_combine_results_single(DIRPROJ_AGE,OUTDIR_HC,'G6',G6,txtname2);
        end
        
    end
    
    txtname3 = 'Result_Heiko.mat';
    
    af_combine_results_Heiko(DIRPROJ_AGE,OUTDIR_HC,'G1',G1,txtname3);
    af_combine_results_Heiko(DIRPROJ_AGE,OUTDIR_HC,'G2',G2,txtname3);
    af_combine_results_Heiko(DIRPROJ_AGE,OUTDIR_HC,'G3',G3,txtname3);
    af_combine_results_Heiko(DIRPROJ_AGE,OUTDIR_HC,'G4',G4,txtname3);
    af_combine_results_Heiko(DIRPROJ_AGE,OUTDIR_HC,'G5',G5,txtname3);
    af_combine_results_Heiko(DIRPROJ_AGE,OUTDIR_HC,'G6',G6,txtname3);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% G1 == wy, G2 == wo, G3 == my, G4 == mo

if(strcmp(MODEplot3Slices_ROIS,'yes'))
    
    kfreq = selectnumberfreq;
    kfilt = 50;
    
    DAT_G1=load(['comb_G1_Result_gradmdev_' int2str(kfreq) '_' int2str(kfilt) '.mat']);
    DAT_G2=load(['comb_G2_Result_gradmdev_' int2str(kfreq) '_' int2str(kfilt) '.mat']);
    DAT_G3=load(['comb_G3_Result_gradmdev_' int2str(kfreq) '_' int2str(kfilt) '.mat']);
    DAT_G4=load(['comb_G4_Result_gradmdev_' int2str(kfreq) '_' int2str(kfilt) '.mat']);
    DAT_G5=load(['comb_G5_Result_gradmdev_' int2str(kfreq) '_' int2str(kfilt) '.mat']);
    DAT_G6=load(['comb_G6_Result_gradmdev_' int2str(kfreq) '_' int2str(kfilt) '.mat']);
    
    DAT_HT_G1=load('comb_G1_Result_Heiko.mat');
    DAT_HT_G2=load('comb_G2_Result_Heiko.mat');
    DAT_HT_G3=load('comb_G3_Result_Heiko.mat');
    DAT_HT_G4=load('comb_G4_Result_Heiko.mat');
    DAT_HT_G5=load('comb_G5_Result_Heiko.mat');
    DAT_HT_G6=load('comb_G6_Result_Heiko.mat');
    
    BWG1=load('maskfull_wy_BWreg.mat');
    BWG2=load('maskfull_wo_BWreg.mat');
    BWG3=load('maskfull_my_BWreg.mat');
    BWG4=load('maskfull_mo_BWreg.mat');
    BWG5=load('maskfull_old_BWreg.mat');
    BWG6=load('maskfull_young_BWreg.mat');
    
    %BWG1.BWtmp(:,:,ksub,kslice,kBW)
    
    %     G1 = Asubject_HC(index_wy);
    %     G2 = Asubject_HC(index_wo);
    %     G3 = Asubject_HC(index_my);
    %     G4 = Asubject_HC(index_mo);
    %     G5 = Asubject_HC(index_old);
    %     G6 = Asubject_HC(index_young);
    
    
    finalvals_wy=af_calcmedvals(DAT_G1,BWG1,Asubject_HC,index_wy);
    finalvals_wo=af_calcmedvals(DAT_G2,BWG2,Asubject_HC,index_wo);
    finalvals_my=af_calcmedvals(DAT_G3,BWG3,Asubject_HC,index_my);
    finalvals_mo=af_calcmedvals(DAT_G4,BWG4,Asubject_HC,index_mo);
    finalvals_old=af_calcmedvals(DAT_G5,BWG5,Asubject_HC,index_old);
    finalvals_young=af_calcmedvals(DAT_G6,BWG6,Asubject_HC,index_young);
    
    ht_finalvals_wy    = af_calcmedvals_Heiko(DAT_HT_G1,BWG1,Asubject_HC,index_wy);
    ht_finalvals_wo    = af_calcmedvals_Heiko(DAT_HT_G2,BWG2,Asubject_HC,index_wo);
    ht_finalvals_my    = af_calcmedvals_Heiko(DAT_HT_G3,BWG3,Asubject_HC,index_my);
    ht_finalvals_mo    = af_calcmedvals_Heiko(DAT_HT_G4,BWG4,Asubject_HC,index_mo);
    ht_finalvals_old   = af_calcmedvals_Heiko(DAT_HT_G5,BWG5,Asubject_HC,index_old);
    ht_finalvals_young = af_calcmedvals_Heiko(DAT_HT_G6,BWG6,Asubject_HC,index_young);
    
    for kval=1:3
        for kBW=1:4
            [ht(1,kBW,kval) pt(1,kBW,kval)]=ttest2( finalvals_wo(:,kBW,kval),finalvals_wy(:,kBW,kval));
            [ht(2,kBW,kval) pt(2,kBW,kval)]=ttest2( finalvals_mo(:,kBW,kval),finalvals_my(:,kBW,kval));
            [ht(3,kBW,kval) pt(3,kBW,kval)]=ttest2(finalvals_old(:,kBW,kval),finalvals_young(:,kBW,kval));
            
            [hu(1,kBW,kval) pu(1,kBW,kval)]=ttest2(finalvals_wo(:,kBW,kval),finalvals_wy(:,kBW,kval),0.05,'both','unequal');
            [hu(2,kBW,kval) pu(2,kBW,kval)]=ttest2(finalvals_mo(:,kBW,kval),finalvals_my(:,kBW,kval),0.05,'both','unequal');
            [hu(3,kBW,kval) pu(3,kBW,kval)]=ttest2(finalvals_old(:,kBW,kval),finalvals_young(:,kBW,kval),0.05,'both','unequal');
            
            
            [pr(1,kBW,kval) hr(1,kBW,kval)]=ranksum( finalvals_wo(:,kBW,kval),finalvals_wy(:,kBW,kval));
            [pr(2,kBW,kval) hr(2,kBW,kval)]=ranksum( finalvals_mo(:,kBW,kval),finalvals_my(:,kBW,kval));
            [pr(3,kBW,kval) hr(3,kBW,kval)]=ranksum(finalvals_old(:,kBW,kval),finalvals_young(:,kBW,kval));
            
        end
    end
    
    'ht'
    ht
    'hu'
    hu
    'hr'
    hr
    
    % Heiko
    for kval=1:4
        for kBW=1:4
            [ht_ht(1,kBW,kval) ht_pt(1,kBW,kval)]=ttest2( ht_finalvals_wo(:,kBW,kval),ht_finalvals_wy(:,kBW,kval));
            [ht_ht(2,kBW,kval) ht_pt(2,kBW,kval)]=ttest2( ht_finalvals_mo(:,kBW,kval),ht_finalvals_my(:,kBW,kval));
            [ht_ht(3,kBW,kval) ht_pt(3,kBW,kval)]=ttest2(ht_finalvals_old(:,kBW,kval),ht_finalvals_young(:,kBW,kval));
            
            [ht_hu(1,kBW,kval) ht_pu(1,kBW,kval)]=ttest2( ht_finalvals_wo(:,kBW,kval),ht_finalvals_wy(:,kBW,kval),0.05,'both','unequal');
            [ht_hu(2,kBW,kval) ht_pu(2,kBW,kval)]=ttest2( ht_finalvals_mo(:,kBW,kval),ht_finalvals_my(:,kBW,kval),0.05,'both','unequal');
            [ht_hu(3,kBW,kval) ht_pu(3,kBW,kval)]=ttest2(ht_finalvals_old(:,kBW,kval),ht_finalvals_young(:,kBW,kval),0.05,'both','unequal');
            
            [ht_pr(1,kBW,kval) ht_hr(1,kBW,kval)]=ranksum( ht_finalvals_wo(:,kBW,kval),ht_finalvals_wy(:,kBW,kval));
            [ht_pr(2,kBW,kval) ht_hr(2,kBW,kval)]=ranksum( ht_finalvals_mo(:,kBW,kval),ht_finalvals_my(:,kBW,kval));
            [ht_pr(3,kBW,kval) ht_hr(3,kBW,kval)]=ranksum(ht_finalvals_old(:,kBW,kval),ht_finalvals_young(:,kBW,kval));
            
        end
    end
    
    'ht_ht'
    ht_ht
    'ht_hu'
    ht_hu
    'ht_hr'
    ht_hr
    
end


if(strcmp(MODEplot3Slices_ROISsingle,'yes'))
    
    DAT_G1=load('comb_G1_Result_gradmdev_sfreq_50.mat');
    DAT_G2=load('comb_G2_Result_gradmdev_sfreq_50.mat');
    DAT_G3=load('comb_G3_Result_gradmdev_sfreq_50.mat');
    DAT_G4=load('comb_G4_Result_gradmdev_sfreq_50.mat');
    DAT_G5=load('comb_G5_Result_gradmdev_sfreq_50.mat');
    DAT_G6=load('comb_G6_Result_gradmdev_sfreq_50.mat');
    
    BWG1=load('maskfull_wy_BWreg.mat');
    BWG2=load('maskfull_wo_BWreg.mat');
    BWG3=load('maskfull_my_BWreg.mat');
    BWG4=load('maskfull_mo_BWreg.mat');
    BWG5=load('maskfull_old_BWreg.mat');
    BWG6=load('maskfull_young_BWreg.mat');
    
    %BWG1.BWtmp(:,:,ksub,kslice,kBW)
    
    %     G1 = Asubject_HC(index_wy);
    %     G2 = Asubject_HC(index_wo);
    %     G3 = Asubject_HC(index_my);
    %     G4 = Asubject_HC(index_mo);
    %     G5 = Asubject_HC(index_old);
    %     G6 = Asubject_HC(index_young);
    size(DAT_G1.ABSG)
    size(BWG1.BWtmp)
    
    finalvals_wy=af_calcmedvals_single(DAT_G1,BWG1,Asubject_HC,index_wy);
    finalvals_wo=af_calcmedvals_single(DAT_G2,BWG2,Asubject_HC,index_wo);
    finalvals_my=af_calcmedvals_single(DAT_G3,BWG3,Asubject_HC,index_my);
    finalvals_mo=af_calcmedvals_single(DAT_G4,BWG4,Asubject_HC,index_mo);
    finalvals_old=af_calcmedvals_single(DAT_G5,BWG5,Asubject_HC,index_old);
    finalvals_young=af_calcmedvals_single(DAT_G6,BWG6,Asubject_HC,index_young);
    
    for freq=1:7
        for kval=1 %:3
            for kBW=1:4
                [ht(1,kBW,kval,freq) pt(1,kBW,kval,freq)]=ttest2( finalvals_wo(:,kBW,kval,freq),finalvals_wy(:,kBW,kval,freq));
                [ht(2,kBW,kval,freq) pt(2,kBW,kval,freq)]=ttest2( finalvals_mo(:,kBW,kval,freq),finalvals_my(:,kBW,kval,freq));
                [ht(3,kBW,kval,freq) pt(3,kBW,kval,freq)]=ttest2(finalvals_old(:,kBW,kval,freq),finalvals_young(:,kBW,kval,freq));
                
                [hu(1,kBW,kval,freq) pu(1,kBW,kval,freq)]=ttest2(finalvals_wo(:,kBW,kval,freq),finalvals_wy(:,kBW,kval,freq),0.05,'both','unequal');
                [hu(2,kBW,kval,freq) pu(2,kBW,kval,freq)]=ttest2(finalvals_mo(:,kBW,kval,freq),finalvals_my(:,kBW,kval,freq),0.05,'both','unequal');
                [hu(3,kBW,kval,freq) pu(3,kBW,kval,freq)]=ttest2(finalvals_old(:,kBW,kval,freq),finalvals_young(:,kBW,kval,freq),0.05,'both','unequal');
                
                
                [pr(1,kBW,kval,freq) hr(1,kBW,kval,freq)]=ranksum( finalvals_wo(:,kBW,kval,freq),finalvals_wy(:,kBW,kval,freq));
                [pr(2,kBW,kval,freq) hr(2,kBW,kval,freq)]=ranksum( finalvals_mo(:,kBW,kval,freq),finalvals_my(:,kBW,kval,freq));
                [pr(3,kBW,kval,freq) hr(3,kBW,kval,freq)]=ranksum(finalvals_old(:,kBW,kval,freq),finalvals_young(:,kBW,kval,freq));
                
            end
        end
    end
    
    'ht'
    ht
    'hu'
    hu
    'hr'
    hr
    
    'pt'
    pt
    'pu'
    pu
    'pr'
    pr
    
    
end

