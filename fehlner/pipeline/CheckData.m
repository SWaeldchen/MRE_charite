function [X] = CheckData(PROJ_DATA,Asubject,slc,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,n13,n14,n15)



for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
        
        
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n1 '.nii'])));
    X1  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n2 '.nii'])));
    X2  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n3 '.nii'])));
    X3  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n4 '.nii'])));
    X4  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n5 '.nii'])));
    X5  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n6 '.nii'])));
    X6  = TMP(:,:,slc);    
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n7 '.nii'])));
    X7  = TMP(:,:,slc);      
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n8 '.nii'])));
    X8  = TMP(:,:,slc);   
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n9 '.nii'])));
    X9  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n10 '.nii'])));
    X10  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n11 '.nii'])));
    X11  = TMP(:,:,slc);
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n12 '.nii'])));
    X12  = TMP(:,:,slc);    
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n13 '.nii'])));
    X13  = TMP(:,:,slc);      
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n14 '.nii'])));
    X14  = TMP(:,:,slc);   
    TMP = spm_read_vols(spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n15 '.nii'])));
    X15  = TMP(:,:,slc);  
    
    X(:,:,subj) = cat(2,X1/(3*nanmean(abs(X1(:)))),X2/(3*nanmean(abs(X2(:)))),X3/(3*nanmean(abs(X3(:)))),X4/(3*nanmean(abs(X4(:)))),...
                        X5/(3*nanmean(abs(X5(:)))),X6/(3*nanmean(abs(X6(:)))),X7/(3*nanmean(abs(X7(:)))),X8/(3*nanmean(abs(X8(:)))),...
                        X9/(3*nanmean(abs(X9(:)))),X10/(3*nanmean(abs(X10(:)))),X11/(3*nanmean(abs(X11(:)))),X12/(3*nanmean(abs(X12(:)))),...
                        X13/(3*nanmean(abs(X13(:)))),X14/(3*nanmean(abs(X14(:)))),X15/(3*nanmean(abs(X15(:))))  );
    
end
