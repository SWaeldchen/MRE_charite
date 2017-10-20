function AVG(PROJ_DATA,Asubject,n1)

D=[];
for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    H = spm_vol(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n1 '.nii']));
    C(:,:,:,subj) = spm_read_vols(H);
    
end

Dm = mean(C,4);
H.fname = fullfile(PROJ_DATA,[n1 '_mean.nii']);
spm_write_vol(H,Dm);

Ds = std(C,[],4);
H.fname = fullfile(PROJ_DATA,[n1 '_std.nii']);
spm_write_vol(H,Ds);