clear all
addpath('/home/realtime/spm12');
addpath(genpath('/home/realtime/project_modico'));

if (strcmp(version('-release'),'2013a'))
    myCluster = parcluster('local');
    myCluster.NumWorkers = 12;  % 'Modified' property now TRUE
    saveProfile(myCluster);
end

if (strcmp(version('-release'),'2015a'))
    myCluster = parcluster('local');
    myCluster.NumWorkers = 64;  % 'Modified' property now TRUE
    saveProfile(myCluster);
end


% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'))


t_id{1} = '3T'; % PERF
t_id{2} = '15T';
t_id{3} = '30T';
t_id{4} = '7T';


%% Subjects %%

Asubject3T = {
    {'MREPERF-FD_20150513-133126',7,16,18,14,[30 40 50],40,30,3,4,5,'F. Dittmann',26} % dicom mprage korrupt (nutze nii!)
    {'SHi_MREPERF_20150622',26,9,11,3,[30 40 50],40,30,15,16,17,'S. Hirsch',31}
    {'MREPERF-LM_20150624-131215',14,5,7,3,[30 40 50],40,30,11,12,13,'L. Marz',20}
    {'MREPERF-SH_20150625-145714',14,5,7,3,[30 40 50],40,30,11,12,13,'S. Hetzer',38}
    {'MREPERF-AFAndi_20150625-140247',14,5,7,3,[30 40 50],40,30,11,12,13,'A. Fehlner',29}
    {'MREPERF-TS_20150626-090422',14,5,7,3,[30 40 50],40,30,11,12,13,'T. Scheuermann',28}
    {'MREPERF-JB_20150630-110303',14,5,7,3,[30 40 50],40,30,11,12,13,'J. Braun',54}
    {'MREPERF-IS_20150630-132315',6,19,21,17,[30 40 50],40,30,3,4,5,'I. Sack',45}
    {'MREPERF-HT_20150630-114822',6,19,21,17,[30 40 50],40,30,3,4,5,'H. Tzschaetzsch',30}
    {'MREPERF-AR_20150706-095001',15,5,7,3,[30 40 50],40,30,12,13,14,'A. Ratthey',48} % seg_epi2mni falsch registriert!
    {'MREPERF-DS_20150707-164535',15,5,7,3,[30 40 50],40,30,24,13,14,'D. Schubert',56}
    {'MREPERF-TC_20150707-155729',15,5,7,3,[30 40 50],40,30,12,13,14,'T. Christofel',32}
    {'MREPERF-VG_20150707-173412',15,5,7,3,[30 40 50],40,30,12,13,14,'V. Gruendel',28}
    {'MREPERF-DG_20150708-112321',15,5,7,3,[30 40 50],40,30,12,13,14,'D. Glass',53} % seg_epi2mni falsch registriert!
    };

% 7T
Asubject7T = {
    {'nd81-3188_20150114-103840',5,15,17,[7,13,19],[30,40,50],42,70}
    {'ql48-3194_20150115-122916',5,9,11,[7,13,19],[30,40,50],42,70}
    {'ls93-3191_20150115-095226',5,9,11,[7,13,19],[30,40,50],42,70}
    {'hr27-3184_20150113-103002',5,9,11,[7,13,19],[30,40,50],42,70}
    {'ko96-3193_20150115-113626',5,9,11,[7,13,19],[30,40,50],42,70}
    {'bh27-3203_20150121-133914',5,9,11,[7,13,19],[30,40,50],42,70}
    {'sc17-3187_20150113-141143',5,9,11,[7,13,19],[30,40,50],42,70}
    {'rk17-3190_20150114-125344',5,9,11,[7,13,19],[30,40,50],42,70}
    {'zr20-3195_20150115-135043',3,7,9,[5,11,17],[30,40,50],42,70}
    {'br01-3196_20150115-143917',5,9,11,[7,13,19],[30,40,50],42,70}
    {'va08-3199_20150116-101423',5,9,11,[7,13,19],[30,40,50],42,70}
    {'zi11-3182_20150112-113229',27,13,15,[11,17,23],[30,40,50],42,70}
    {'dn20-3186_20150113-130353',5,9,11,[7,13,19],[30,40,50],42,70}
    {'kw96-3189_20150114-115052',5,10,12,[8,14,20],[30,40,50],42,70}
    {'br72-3192_20150115-104047',5,9,11,[7,13,19],[30,40,50],42,70}
    {'vu57-3183_20150112-131410',5,9,11,[9,17,23],[30,40,50],42,70}
    {'kq53-3204_20150121-144103',5,9,11,[7,13,19],[30,40,50],42,70}
    {'mo64-3200_20150119-125505',5,9,11,[7,13,19],[30,40,50],42,70}
    };

Asubject15T = {
    {'MMRE-brain-Edin-AF-1-5T-2015-01-21_20150121-161216',2,4,8,10,[30,40,50],20,15}
    {'MMRE-brainedin-AK-1-5T-20150427_20150427-140826',2,3,5,7,[30,40,50],20,15}
    {'MMRE-brainedin-1-5T-AR-20150427_20150427-163927',2,3,	5,7,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-BG-20150515_20150515-134350',2,3,5,7,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-BS-20150722_20150722-112215',2,3,5,7,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-DS-2015-01-16_20150116-204027',2,4,8,10,[30,40,50],20,15}
    {'MMRE-brain-edin-FS-1-5T-2015-03-03_20150303-173116',2,3,5,9,[30,40,50],20,15}
    {'MMRE-brainedin-1-5T-HS-20150427_20150427-170204',2,3,5,7,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-HT-2015-01-16_20150116-104358',2,4,6,8,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-IS-2015-01-29_20150129-160033',3,8,10,12,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-JB-2015-01-29_20150129-153622',2,7,9,11,[30,40,50],20,15}
    %{'MMRE-brain-edin-JD-2015-03-03_20150303-175444',2,3,5,	7,[30,40,50],20,15}
    {'MMRE-brain-Edin-JG-1-5T-2015-01-21_20150121-154615',2,4,6,8,[30,40,50],20,15}
    {'MMRE-brainedin-1-5T-JH-20150427_20150427-161707',2,3,	5,7,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-HaJ-20150205_20150205-160443',2,11,9,7,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-OB-20150205_20150205-172153',2,3,5,7,[30,40,50],20,15}
    {'MMRE-brain-edin-RL-1-5T_20150907-182401',2,3,5,7,[30,40,50],20,15}
    {'MMRE-brain-edin-1-5T-SH-2015-01-15_20150115-180610',2,5,7,9,[30,40,50],20,15}
    {'MMRE-brain-edin-SS-1-5T-2015-03-03_20150303-170041',2,3,5,7,[30,40,50],20,15}
    };

Asubject30T = {
    {'MMRE-brain-edin-3T-AF-2015-01-16_20150116-095142',2,7,9,11,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-AK-2015-01-29_20150129-125926',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-DS-2015-01-16_20150116-201002',2,4,6,8,[30,40,50],16,30} % Probleme, dauerte ewig
    {'MMRE-brain-edin3T-HT-2015-01-15_20150115-145827',2,5,7,3,[30,40,50],16,30}
    {'mmre-brain-edin-3T-IS-2015-01-29_20150129-124057',3,4,6,8,[30,40,50],16,30}
    {'mmre-brain-edin-3T-jb-2015-01-29_20150129-121857',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-JHA-2015-02-05_20150205-151732',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-SS-2015-03-03_20150303-182203',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-AR-3T-2015-03-09_20150309-155843',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-FS-3T-2015-03-03_20150303-184049',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-HS-3T-2015-03-03_20150309-164039',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-JD-3T-2015-03-03_20150303-185722',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-JH-3T-2015-03-09_20150309-162220',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-JG-3T-2015-01-26_20150126-120220',2,3,5,7,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-SH-2015-01-26_20150126-113526',2,3,5,9,[30,40,50],16,30}
    {'MMRE-brain-edin-3T-SIU-2015-01-26_20150126-122207',2,3,5,7,[30,40,50],16,30}
    };

save('/store01_analysis/realtime/Asubject_list.mat','Asubject3T','Asubject15T','Asubject30T','Asubject7T');
save('/home/realtime/Asubject_list.mat','Asubject3T','Asubject15T','Asubject30T','Asubject7T');

for prestr = {'MNI'}
    
    prestr = cell2str(prestr);
    
    for kid = [1 2 3] % 1 2 3] %[2 3] %[1 4] %:4 %30,3 %1:length(t_id)
        id = t_id{kid};
        
        disp([prestr '_' id]);
        
        if strcmp(id,'3T')
            Asubject = Asubject3T;
            PROJ_DIR = '/store01_analysis/realtime/PERF3T/';
        end
        
        if strcmp(id,'15T')
            Asubject = Asubject15T;
            PROJ_DIR = '/store01_analysis/realtime/edin15T/';
        end
        
        if strcmp(id,'30T')
            Asubject = Asubject30T;
            PROJ_DIR = '/store01_analysis/realtime/edin3T/';
        end
        
        if strcmp(id,'7T')
            Asubject = Asubject7T;
            PROJ_DIR = '/store01_analysis/realtime/edin7T/';
        end
        
        disp(PROJ_DIR);
        
        % class_analysemodico.plotoverview_MNI(PROJ_DIR,Asubject);
        % class_analysemodico.plotoverview_EPI(PROJ_DIR,Asubject);       
        % class_analysemodico.averagetissue(PROJ_DIR,Asubject);         %% Average Tissue Masks
        % TPM2MNI(PROJ_DIR,Asubject);        %% TPM2MNI              
        
        %class_analysemodico.GMWM_MNI(PROJ_DIR,Asubject);
        
        class_analysemodico.GMWM_ttestfullbrain(PROJ_DIR,Asubject,id);
        
        
        kgm=0;
        for kthres_gm = 0.7:0.05:0.8
            kgm = kgm + 1;
            kwm = 0;
            for kthres_wm = 0.5:0.05:0.7
                kwm = kwm +1;
                
                TMP = load(['/home/realtime/matrixpM_' id '_' int2str(kthres_gm*100) '_' int2str(kthres_wm*100) '.mat'],'matrixpM');
                
                DATA_all2(kgm,kwm,:,:)=TMP.matrixpM;
            end
        end
         plot2dwaves(permute(squeeze(DATA_all2(2,:,:,:)),[1 3 2]))
        
%        class_analysemodico.GMWM_MNI_plot(PROJ_DIR,Asubject);
        %% Motion
%         mFD = calc_SFD(PROJ_DIR,Asubject);
         
%         
%         
%         if strcmp(id,'7T')
%             BWthres = 80;
%         else
%             BWthres = 200;
%         end
%         
%         res1 = calc_res_rer_sliced(PROJ_DIR,Asubject,BWthres,prestr);
%         res2 = calc_res_psf(PROJ_DIR,Asubject,prestr);
%         res3 = calc_res_entropy(PROJ_DIR,Asubject,BWthres,prestr);
%         
%         
%         % Reassign old library paths
%         
%         save(fullfile('/store01_analysis/realtime/',['resdata7_' id '_' prestr '.mat']),'res1','res2','res3','mFD');
%         clear res1 res2 res3 mFD
%         
        
    end
    
end
