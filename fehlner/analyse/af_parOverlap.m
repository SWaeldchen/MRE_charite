function af_parOverlap(PROJ_DIR,Asubject,id,prestr)

mkdir(fullfile(PROJ_DIR,'MI_DIR'));

normtxtstr = 'epi2ana';

for subj =  1:length(Asubject) %:numel(Asubject)
    
%     %SUBJ_DIR = ;
%     X =  int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','MNI_MPRAGE.nii'))));
%     Mf_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGf_orig.nii']))));
%     Mf_c = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGf_dico.nii']))));
%     
%     Mm_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_orig.nii']))));
%     Mm_m = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_moco.nii']))));
%     Mm_d = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_dico.nii']))));
%     Mm_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_modico.nii']))));
    
    EPI_c1_1 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c1_' normtxtstr '_1.nii']))));
    EPI_c2_2 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c2_' normtxtstr '_1.nii']))));
    EPI_c3_1 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c3_' normtxtstr '_1.nii']))));
    EPI_c4_1 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c4_' normtxtstr '_1.nii']))));
    
    EPI_c1_2 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c1_' normtxtstr '_2.nii']))));
    EPI_c2_2 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c2_' normtxtstr '_2.nii']))));
    EPI_c3_2 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c3_' normtxtstr '_2.nii']))));
    EPI_c4_2 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c4_' normtxtstr '_2.nii']))));
    
    EPI_c1_3 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c1_' normtxtstr '_3.nii']))));
    EPI_c2_3 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c2_' normtxtstr '_3.nii']))));
    EPI_c3_3 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c3_' normtxtstr '_3.nii']))));
    EPI_c4_3 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c4_' normtxtstr '_3.nii']))));
    
    EPI_c1_4 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c1_' normtxtstr '_4.nii']))));
    EPI_c2_4 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c2_' normtxtstr '_4.nii']))));
    EPI_c3_4 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c3_' normtxtstr '_4.nii']))));
    EPI_c4_4 = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c4_' normtxtstr '_4.nii']))));
    
    EPI_c1_orig = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c1_' normtxtstr '_orig.nii']))));
    EPI_c2_orig = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c2_' normtxtstr '_orig.nii']))));
    EPI_c3_orig = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c3_' normtxtstr '_orig.nii']))));
    EPI_c4_orig = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c4_' normtxtstr '_orig.nii']))));
    
    EPI_c1_dico = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c1_' normtxtstr '_dico.nii']))));
    EPI_c2_dico = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c2_' normtxtstr '_dico.nii']))));
    EPI_c3_dico = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c3_' normtxtstr '_dico.nii']))));
    EPI_c4_dico = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',['EPI_c4_' normtxtstr '_dico.nii']))));
    
    
    Mm_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','EPI_c1_epi2ana_dico.nii'))));
    Mm_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','EPI_c2_epi2ana_dico.nii'))));
    Mm_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','EPI_c3_epi2ana_dico.nii'))));
    Mm_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','EPI_c4_epi2ana_dico.nii'))));
    
    

        
    if strcmp(id,'data3T')
        threshold = 200;
    end
    
    if strcmp(id,'data7T')
        threshold = 100;
    end
    
    MAGf1 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_orig.nii'],threshold);
    MAGf2 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_dico.nii'],threshold);
    
    BWMAGf = MAGf1.*MAGf2;
    disp('sizeMAGf');
    disp(size(BWMAGf));
    
    BW1 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_orig.nii'],threshold);
    BW2 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_moco.nii'],threshold);
    BW3 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_dico.nii'],threshold);
    BW4 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_modico.nii'],threshold);
    
    MAGBW12 = BW1.*BW2;    
    MAGBW14 = BW1.*BW4;
    MAGBW34 = BW3.*BW4;
    
    for kslice=1:size(X,3)
        disp(kslice)
        X_tmp = double(X(:,:,kslice));        
        Mfo_tmp = double(Mf_o(:,:,kslice));
        Mfc_tmp = double(Mf_c(:,:,kslice));
        
        Mo_tmp = double(Mm_o(:,:,kslice));
        Mm_tmp = double(Mm_m(:,:,kslice));
        Md_tmp = double(Mm_d(:,:,kslice));
        Mmd_tmp = double(Mm_md(:,:,kslice));        
        
        Ao_tmp = double(A_o(:,:,kslice));
        Am_tmp = double(A_m(:,:,kslice));
        Ad_tmp = double(A_d(:,:,kslice));
        Amd_tmp = double(A_md(:,:,kslice));        
%  
%         Anco_tmp = double(Anc_o(:,:,kslice));
%         Ancm_tmp = double(Anc_m(:,:,kslice));
%         Ancd_tmp = double(Anc_d(:,:,kslice));
%         Ancmd_tmp = double(Anc_md(:,:,kslice)); 
        
        MI_mpragevsMfo = mutualInformationGLCM(X_tmp, BWMAGf(:,:,kslice), Mfo_tmp, BWMAGf(:,:,kslice));
        MI_mpragevsMfc = mutualInformationGLCM(X_tmp, BWMAGf(:,:,kslice), Mfc_tmp, BWMAGf(:,:,kslice));

        MI_mpragevsAo12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Ao_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsAm12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Am_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsAo14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Ao_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsAmd14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Amd_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsAd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Ad_tmp, MAGBW34(:,:,kslice));
        MI_mpragevsAmd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Amd_tmp, MAGBW34(:,:,kslice));
        
%         MI_mpragevsAnco12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Anco_tmp, MAGBW12(:,:,kslice));
%         MI_mpragevsAncm12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Ancm_tmp, MAGBW12(:,:,kslice));
%         MI_mpragevsAnco14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Anco_tmp, MAGBW14(:,:,kslice));
%         MI_mpragevsAncmd14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Ancmd_tmp, MAGBW14(:,:,kslice));
%         MI_mpragevsAncd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Ancd_tmp, MAGBW34(:,:,kslice));
%         MI_mpragevsAncmd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Ancmd_tmp, MAGBW34(:,:,kslice));        
        
        MI_mpragevsMo12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Mo_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsMm12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Mm_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsMo14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Mo_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsMmd14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Mmd_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsMd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Md_tmp, MAGBW34(:,:,kslice));
        MI_mpragevsMmd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Mmd_tmp, MAGBW34(:,:,kslice));      


    parsave(fullfile(PROJ_DIR,'MI_DIR',['N2DATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]),...
   MI_mpragevsMfo,MI_mpragevsMfc,...
   MI_mpragevsAo12,MI_mpragevsAm12,MI_mpragevsAo14,MI_mpragevsAmd14,MI_mpragevsAd34,MI_mpragevsAmd34,...
   MI_mpragevsMo12,MI_mpragevsMm12,MI_mpragevsMo14,MI_mpragevsMmd14,MI_mpragevsMd34,MI_mpragevsMmd34);

    end
    
%     MI_mpragevsMfo
%     
%     save(fullfile(PROJ_DIR,['DATA_' id '_' int2str(subj) '_' prestr '_' int2str(kslice)]),...
%         'MI_mpragevsMfo','MI_mpragevsMfo',...
%         'MI_mpragevsAo','MI_mpragevsAm','MI_mpragevsAd','MI_mpragevsAmd');
    

    
end




%save(fullfile(PROJ_DIR,['DATA_' id '_' prestr]),'X','Mf') %,'Mm','A','A_nc','P','P_nc','mask');


% save(fullfile(PROJ_DIR,['mutual_' id '_' prestr]),'MIGLCM_o','MIGLCM_c','MI_o','MI_c',...
%     'MIGLCMnomask_o','MIGLCMnomask_c','MInomask_o','MInomask_c','IMI','IIGLCM',...
%     'MIGLCM_A','MIGLCM_Anc','MIGLCM_P','MIGLCM_Pnc');

end

function parsave(fname,MI_mpragevsMfo,MI_mpragevsMfc,...
   MI_mpragevsAo12,MI_mpragevsAm12,MI_mpragevsAo14,MI_mpragevsAmd14,MI_mpragevsAd34,MI_mpragevsAmd34,...
   MI_mpragevsMo12,MI_mpragevsMm12,MI_mpragevsMo14,MI_mpragevsMmd14,MI_mpragevsMd34,MI_mpragevsMmd34)


    save(fname,'MI_mpragevsMfo','MI_mpragevsMfc',...
   'MI_mpragevsAo12','MI_mpragevsAm12','MI_mpragevsAo14','MI_mpragevsAmd14','MI_mpragevsAd34','MI_mpragevsAmd34',...
   'MI_mpragevsMo12','MI_mpragevsMm12','MI_mpragevsMo14','MI_mpragevsMmd14','MI_mpragevsMd34','MI_mpragevsMmd34');
end

function BW = createmaskgetCC(DATA_DIR,filename1,threshold)
        A = spm_read_vols(spm_vol(fullfile(DATA_DIR,filename1))) > threshold;
        A_tmp = zeros(size(A));
        BW = zeros(size(A));
        for kslice = 1:size(A,3)
            %disp(kslice);
            if sum(sum((A(:,:,kslice)))) == 0
                A_tmp(:,:,kslice) = 0;
            else
                A_tmp(:,:,kslice) = getLargestCc(A(:,:,kslice),4,1);
            end
            BW(:,:,kslice) = imfill(A_tmp(:,:,kslice),'holes');
        end
end