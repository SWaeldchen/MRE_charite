function af_parMI_mpragemean(PROJ_DIR,Asubject,id,prestr)

mkdir(fullfile(PROJ_DIR,'MI_DIR'));

parfor subj =  1:length(Asubject) %:numel(Asubject)
    
    %SUBJ_DIR = ;
    X =  int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,'MNI_MPRAGE_mean.nii'))));
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
    
    
    if strcmp(id,'data3T')
        threshold = 200;
    end
    
    if strcmp(id,'data7T')
        threshold = 100;
    end
    
    MAGf1 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_orig.nii'],threshold);
    MAGf2 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_dico.nii'],threshold);
    
    BWMAG = MAGf1.*MAGf2;
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
        
        MI_mpragevsMfo = mutualInformationGLCM(X_tmp, BWMAG(:,:,kslice), Mfo_tmp, BWMAG(:,:,kslice));
        MI_mpragevsMfc = mutualInformationGLCM(X_tmp, BWMAG(:,:,kslice), Mfc_tmp, BWMAG(:,:,kslice));
        
        MI_mpragevsAo12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Ao_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsAm12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Am_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsAo14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Ao_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsAmd14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Amd_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsAd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Ad_tmp, MAGBW34(:,:,kslice));
        MI_mpragevsAmd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Amd_tmp, MAGBW34(:,:,kslice));
        
        MI_mpragevsMo12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Mo_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsMm12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Mm_tmp, MAGBW12(:,:,kslice));
        MI_mpragevsMo14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Mo_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsMmd14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Mmd_tmp, MAGBW14(:,:,kslice));
        MI_mpragevsMd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Md_tmp, MAGBW34(:,:,kslice));
        MI_mpragevsMmd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Mmd_tmp, MAGBW34(:,:,kslice));
        
        
        parsave(fullfile(PROJ_DIR,'MI_DIR',['N3DATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]),...
            MI_mpragevsMfo,MI_mpragevsMfc,...
            MI_mpragevsAo12,MI_mpragevsAm12,MI_mpragevsAo14,MI_mpragevsAmd14,MI_mpragevsAd34,MI_mpragevsAmd34,...
            MI_mpragevsMo12,MI_mpragevsMm12,MI_mpragevsMo14,MI_mpragevsMmd14,MI_mpragevsMd34,MI_mpragevsMmd34);
        
    end
    
    B0 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','wmyfield.nii')));
    
    MASK_SEGorig = SEG_orig(:,:,:,1)+SEG_orig(:,:,:,2)+SEG_orig(:,:,:,3) > 0.9;
    dB = 10; % frequency step [Hz]
    for k = 1:31
        B = 10*(k-16); % -150 .. +150 Hz
        
        TMP_ROI = ((B-dB/2 < B0) & (B+dB/2> B0));
       
        TMP_MPRAGE = X .* TMP_ROI;
        
        TMP_Mfo = Mf_o .* TMP_ROI;
        TMP_Mfc = Mf_c .* TMP_ROI;
        
        BSEG1(k,kmask,subj) = corr2(TMP_MPRAGE(:),TMP_TPM1(:));
        
    end
    
    
end

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