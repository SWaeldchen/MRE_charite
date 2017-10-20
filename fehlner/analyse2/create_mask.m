function [X] = create_mask(PROJ_DATA,Asubject,n1,thres)

for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    H = spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n1 '.nii']));
    D = spm_read_vols(H);
    D = (D > thres);
    H.fname = fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n1 '_mask.nii']);
    spm_write_vol(H,D);
    
end