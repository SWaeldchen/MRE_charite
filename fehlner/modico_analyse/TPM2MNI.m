function TPM2MNI(PROJ_DATA,Asubject)

for subj = 1:numel(Asubject)
    
    disp(subj)
    SUBJ_DIR = Asubject{subj}{1};
    
    clear matlabbatch
    spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.util.defs.comp{1}.id.space = {fullfile(PROJ_DATA,SUBJ_DIR,'ANA','MNI_c1_epi2mni_1.nii')};
    matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {'/store01_analysis/realtime/TPM.nii'};
    matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {fullfile(PROJ_DATA,SUBJ_DIR,'ANA')};
    matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 4;
    matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
    matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
    spm_jobman('run',matlabbatch);
    
end

end