function segment_epi2mni(DATA_DIR,TPMdir)
disp('segment ana2mni');

if ~exist(fullfile(DATA_DIR,'MNI_y_MPRAGE.nii'),'file');
    
    clear matlabbatch
    spm('defaults','fmri');
    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.spatial.preproc.channel.vols = {[fullfile(DATA_DIR,'MPRAGE.nii') ',1']};
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {fullfile(TPMdir,'TPM.nii,1')};
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {fullfile(TPMdir,'TPM.nii,2')};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {fullfile(TPMdir,'TPM.nii,3')};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {fullfile(TPMdir,'TPM.nii,4')};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {fullfile(TPMdir,'TPM.nii,5')};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {fullfile(TPMdir,'TPM.nii,6')};
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
    spm_jobman('run',matlabbatch);
    
    movefile(fullfile(DATA_DIR,'y_MPRAGE.nii'),fullfile(DATA_DIR,'MNI_y_MPRAGE.nii'));
    movefile(fullfile(DATA_DIR,'iy_MPRAGE.nii'),fullfile(DATA_DIR,'ANA_iy_MPRAGE.nii'));   % TODO: nicht ausgeben!
    
    movefile(fullfile(DATA_DIR,'c1MPRAGE.nii'),fullfile(DATA_DIR,'ANA_c1.nii'));   
    movefile(fullfile(DATA_DIR,'c2MPRAGE.nii'),fullfile(DATA_DIR,'ANA_c2.nii'));   
    movefile(fullfile(DATA_DIR,'c3MPRAGE.nii'),fullfile(DATA_DIR,'ANA_c3.nii'));   
    movefile(fullfile(DATA_DIR,'c4MPRAGE.nii'),fullfile(DATA_DIR,'ANA_c4.nii'));   
    movefile(fullfile(DATA_DIR,'c5MPRAGE.nii'),fullfile(DATA_DIR,'ANA_c5.nii'));       
   
    
end

end

