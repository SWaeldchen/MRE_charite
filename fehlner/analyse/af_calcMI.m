function af_calcMI(PROJ_DIR,Asubject,id,prestr)

mkdir(fullfile(PROJ_DIR,'MI_DIR'));

parfor subj =  1:length(Asubject) %:numel(Asubject)
    
    %SUBJ_DIR = ;
    X =  int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','MNI_MPRAGE.nii'))));
    Mf_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGf_orig.nii']))));
    Mf_c = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGf_dico.nii']))));
    
    Mm_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_orig.nii']))));
    Mm_m = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_moco.nii']))));
    Mm_d = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_dico.nii']))));
    Mm_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'MAGm_modico.nii']))));
    
    A_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_orig.nii']))));
    A_m = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_moco.nii']))));
    A_d = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_dico.nii']))));
    A_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_modico.nii']))));
    Anc_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_orig_nc.nii']))));
    Anc_m = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_moco_nc.nii']))));
    Anc_d = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_dico_nc.nii']))));
    Anc_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'ABSG_modico_nc.nii']))));
    
%     P_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_orig.nii']))));
%     P_m = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_moco.nii']))));
%     P_d = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_dico.nii']))));
%     P_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_modico.nii']))));
%     Pnc_o = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_orig_nc.nii']))));
%     Pnc_m = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_moco_nc.nii']))));
%     Pnc_d = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_dico_nc.nii']))));
%     Pnc_md = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA',[prestr 'PHI_modico_nc.nii']))));
            
    if strcmp(id,'data3T')
        threshold = 200;
        TMPBW1 = getLargestCc(Mf_o>threshold);
        TMPBW2 = getLargestCc(Mf_c>threshold);
        BW1 = imfill(TMPBW1,'holes');
        BW2 = imfill(TMPBW2,'holes');
        BW = (BW1+BW2) > 0.9;
    end
    
    if strcmp(id,'data7T')
        threshold = 100;
        TMPBW1 = getLargestCc(Mf_o>threshold,4,70);
        TMPBW2 = getLargestCc(Mf_c>threshold,4,70);
        BW1 = imfill(TMPBW1,'holes');
        BW2 = imfill(TMPBW2,'holes');
        BW = (BW1+BW2) > 0.9;
    end
    mask = BW;
    
    for kslice=1:size(X,3)       
        disp(kslice)
        X_tmp = double(X(:,:,kslice));
        tmp_mask = double(mask(:,:,kslice));
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
        
        Aonc_tmp = double(Anc_o(:,:,kslice));
        Amnc_tmp = double(Anc_m(:,:,kslice));
        Adnc_tmp = double(Anc_d(:,:,kslice));
        Amdnc_tmp = double(Anc_md(:,:,kslice));        
        
        MI_mpragevsMfo = mutualInformationGLCM(X_tmp, tmp_mask, Mfo_tmp, tmp_mask);
        MI_mpragevsMfc = mutualInformationGLCM(X_tmp, tmp_mask, Mfc_tmp, tmp_mask);

        MI_mpragevsAo = mutualInformationGLCM(X_tmp, tmp_mask, Ao_tmp, tmp_mask);
        MI_mpragevsAm = mutualInformationGLCM(X_tmp, tmp_mask, Am_tmp, tmp_mask);
        MI_mpragevsAd = mutualInformationGLCM(X_tmp, tmp_mask, Ad_tmp, tmp_mask);
        MI_mpragevsAmd = mutualInformationGLCM(X_tmp, tmp_mask, Amd_tmp, tmp_mask);        
 
        
        MI_mpragevsAnco = mutualInformationGLCM(X_tmp, tmp_mask, Aonc_tmp, tmp_mask);
        MI_mpragevsAncm = mutualInformationGLCM(X_tmp, tmp_mask, Amnc_tmp, tmp_mask);
        MI_mpragevsAncd = mutualInformationGLCM(X_tmp, tmp_mask, Adnc_tmp, tmp_mask);
        MI_mpragevsAncmd = mutualInformationGLCM(X_tmp, tmp_mask, Amdnc_tmp, tmp_mask);        
 
        MI_mpragevsMo = mutualInformationGLCM(X_tmp, tmp_mask, Mo_tmp, tmp_mask);
        MI_mpragevsMm = mutualInformationGLCM(X_tmp, tmp_mask, Mm_tmp, tmp_mask);
        MI_mpragevsMd = mutualInformationGLCM(X_tmp, tmp_mask, Md_tmp, tmp_mask);
        MI_mpragevsMmd = mutualInformationGLCM(X_tmp, tmp_mask, Mmd_tmp, tmp_mask);
        


    parsave(fullfile(PROJ_DIR,'MI_DIR',['NDATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]),...
        MI_mpragevsMfo,MI_mpragevsMfc,...
        MI_mpragevsAo,MI_mpragevsAm,MI_mpragevsAd,MI_mpragevsAmd,...
        MI_mpragevsMo,MI_mpragevsMm,MI_mpragevsMd,MI_mpragevsMmd,...
        MI_mpragevsAnco,MI_mpragevsAncm,MI_mpragevsAncd,MI_mpragevsAncmd);    

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
        MI_mpragevsAo,MI_mpragevsAm,MI_mpragevsAd,MI_mpragevsAmd,...
        MI_mpragevsMo,MI_mpragevsMm,MI_mpragevsMd,MI_mpragevsMmd,...
        MI_mpragevsAnco,MI_mpragevsAncm,MI_mpragevsAncd,MI_mpragevsAncmd);


    save(fname); %,'MI_mpragevsMfo','MI_mpragevsMfc',...
        %'MI_mpragevsAo','MI_mpragevsAm','MI_mpragevsAd','MI_mpragevsAmd')
end
