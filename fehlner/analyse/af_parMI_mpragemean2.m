function af_parMI_mpragemean2(PROJ_DIR,Asubject,id,prestr)
mkdir(fullfile(PROJ_DIR,'MI_DIR'));

if strcmp(id,'data3T')
    threshold = 200;
end

if strcmp(id,'data7T')
    threshold = 100;
end

for subj =  1:length(Asubject) %:numel(Asubject)

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
    
    MAGf1 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_orig.nii'],threshold);
    MAGf2 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGf_dico.nii'],threshold);
    
    BWMAG = MAGf1.*MAGf2;
    disp('sizeMAG');
    disp(size(BWMAG));
    
    BW1 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_orig.nii'],threshold);
    BW2 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_moco.nii'],threshold);
    BW3 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_dico.nii'],threshold);
    BW4 = createmaskgetCC(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA'),[prestr 'MAGm_modico.nii'],threshold);
    
    MAGBW12 = BW1.*BW2;
    MAGBW14 = BW1.*BW4;
    MAGBW34 = BW3.*BW4;
    
%     for kslice=1:size(X,3)
%         fprintf('*');
%         X_tmp = double(X(:,:,kslice));
%         Mfo_tmp = double(Mf_o(:,:,kslice));
%         Mfc_tmp = double(Mf_c(:,:,kslice));
%         
%         Mo_tmp = double(Mm_o(:,:,kslice));
%         Mm_tmp = double(Mm_m(:,:,kslice));
%         Md_tmp = double(Mm_d(:,:,kslice));
%         Mmd_tmp = double(Mm_md(:,:,kslice));
%         
%         Ao_tmp = double(A_o(:,:,kslice));
%         Am_tmp = double(A_m(:,:,kslice));
%         Ad_tmp = double(A_d(:,:,kslice));
%         Amd_tmp = double(A_md(:,:,kslice));
%         
%         MI_mpragevsMfo = mutualInformationGLCM(X_tmp, BWMAG(:,:,kslice), Mfo_tmp, BWMAG(:,:,kslice));
%         MI_mpragevsMfc = mutualInformationGLCM(X_tmp, BWMAG(:,:,kslice), Mfc_tmp, BWMAG(:,:,kslice));
%         
%         MI_mpragevsAo12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Ao_tmp, MAGBW12(:,:,kslice));
%         MI_mpragevsAm12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Am_tmp, MAGBW12(:,:,kslice));
%         MI_mpragevsAo14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Ao_tmp, MAGBW14(:,:,kslice));
%         MI_mpragevsAmd14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Amd_tmp, MAGBW14(:,:,kslice));
%         MI_mpragevsAd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Ad_tmp, MAGBW34(:,:,kslice));
%         MI_mpragevsAmd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Amd_tmp, MAGBW34(:,:,kslice));
%         
%         MI_mpragevsMo12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Mo_tmp, MAGBW12(:,:,kslice));
%         MI_mpragevsMm12 = mutualInformationGLCM(X_tmp, MAGBW12(:,:,kslice), Mm_tmp, MAGBW12(:,:,kslice));
%         MI_mpragevsMo14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Mo_tmp, MAGBW14(:,:,kslice));
%         MI_mpragevsMmd14 = mutualInformationGLCM(X_tmp, MAGBW14(:,:,kslice), Mmd_tmp, MAGBW14(:,:,kslice));
%         MI_mpragevsMd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Md_tmp, MAGBW34(:,:,kslice));
%         MI_mpragevsMmd34 = mutualInformationGLCM(X_tmp, MAGBW34(:,:,kslice), Mmd_tmp, MAGBW34(:,:,kslice));
%         
%         
%         parsave(fullfile(PROJ_DIR,'MI_DIR',['N3DATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]),...
%             MI_mpragevsMfo,MI_mpragevsMfc,...
%             MI_mpragevsAo12,MI_mpragevsAm12,MI_mpragevsAo14,MI_mpragevsAmd14,MI_mpragevsAd34,MI_mpragevsAmd34,...
%             MI_mpragevsMo12,MI_mpragevsMm12,MI_mpragevsMo14,MI_mpragevsMmd14,MI_mpragevsMd34,MI_mpragevsMmd34);
%         
%     end

    disp('mutual slice');
    for kslice=1:size(X,3)
        fprintf('*');
        X_tmp = double(X(:,:,kslice));
        Mfo_tmp = double(Mf_o(:,:,kslice));
        Mfc_tmp = double(Mf_c(:,:,kslice));
        
        MI_mpragevsMfo = mutualInformationGLCM(X_tmp, BWMAG(:,:,kslice), Mfo_tmp, BWMAG(:,:,kslice));
        MI_mpragevsMfc = mutualInformationGLCM(X_tmp, BWMAG(:,:,kslice), Mfc_tmp, BWMAG(:,:,kslice));
        
        parsavefirst(fullfile(PROJ_DIR,'MI_DIR',['N3DATA_first_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]),...
            MI_mpragevsMfo,MI_mpragevsMfc);
        
    end

    
    disp('mutual field');
    B0 = spm_read_vols(spm_vol(fullfile(PROJ_DIR,Asubject{subj}{1},'ANA','MNI_myfield.nii')));    
    dB = 10; % frequency step [Hz]
    for k = 1:31
        fprintf('*');
        B = 10*(k-16); % -150 .. +150 Hz        
        TMP_ROI = ((B-dB/2 < B0) & (B+dB/2> B0));
%        
%         disp('sizeX');
%         disp(size(X));        
%         disp('sizeMfo');
%         disp(size(Mf_o));        
%         disp('sizeMfc');
%         disp(size(Mf_c));        
%         disp('sizeTMProi');
%         disp(size(TMP_ROI));
        
        TMP_MPRAGE = double(X) .* double(TMP_ROI) .* BWMAG;        
        TMP_Mfo = double(Mf_o) .* double(TMP_ROI) .* BWMAG;
        TMP_Mfc = double(Mf_c) .* double(TMP_ROI) .* BWMAG;
        
        B0mpragemni_orig = corr2(TMP_MPRAGE(:),TMP_Mfo(:));
        B0mpragemni_dico = corr2(TMP_MPRAGE(:),TMP_Mfc(:));
        
        parsavefield(fullfile(PROJ_DIR,'MI_DIR',['BO_N3DATA_' id '_sub' int2str(subj) '_' prestr '_k' int2str(k)]),...
            B0mpragemni_orig,B0mpragemni_dico);
        
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

function parsavefield(fname,B0mpragemni_orig,B0mpragemni_dico)
save(fname,'B0mpragemni_orig','B0mpragemni_dico');
end

function parsavefirst(fname,MI_mpragevsMfo,MI_mpragevsMfc)
save(fname,'MI_mpragevsMfo','MI_mpragevsMfc');
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