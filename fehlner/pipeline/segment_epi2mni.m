function segment_epi2mni(DATA_DIR,filename,TPMdir)
disp(['segment epi2mni ' filename]);

if strcmp(filename,'EPI_MAGf_dico')
    filestr = 'dico';
end

if strcmp(filename,'EPI_MAGf_orig')
    filestr = 'orig';
end

if strcmp(filename,'EPI_MAGm_orig')
    filestr = '1';
end

if strcmp(filename,'EPI_MAGm_moco')
    filestr = '2';
end

if strcmp(filename,'EPI_MAGm_dico')
    filestr = '3';
end

if strcmp(filename,'EPI_MAGm_modico')
    filestr = '4';
end


if ~exist(fullfile(DATA_DIR,[filename '_epi2mni_seg8.mat']),'file');
    
    clear matlabbatch
    spm('defaults','fmri');
    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.spatial.preproc.channel.vols = {[fullfile(DATA_DIR,[filename '.nii']) ',1']};
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
    
    movefile(fullfile(DATA_DIR,['y_' filename '.nii']),fullfile(DATA_DIR,['MNI_y_epi2mni_' filestr '.nii']));
    movefile(fullfile(DATA_DIR,['iy_' filename '.nii']),fullfile(DATA_DIR,['EPI_iy_epi2mni_' filestr '.nii']));        
    
    movefile(fullfile(DATA_DIR,['c1' filename '.nii']),fullfile(DATA_DIR,['EPI_c1_epi2mni_' filestr '.nii']));       
    movefile(fullfile(DATA_DIR,['c2' filename '.nii']),fullfile(DATA_DIR,['EPI_c2_epi2mni_' filestr '.nii']));       
    movefile(fullfile(DATA_DIR,['c3' filename '.nii']),fullfile(DATA_DIR,['EPI_c3_epi2mni_' filestr '.nii']));       
    movefile(fullfile(DATA_DIR,['c4' filename '.nii']),fullfile(DATA_DIR,['EPI_c4_epi2mni_' filestr '.nii']));    
    movefile(fullfile(DATA_DIR,['c5' filename '.nii']),fullfile(DATA_DIR,['EPI_c5_epi2mni_' filestr '.nii']));       
   
    movefile(fullfile(DATA_DIR,[filename '_seg8.mat']),fullfile(DATA_DIR,[filename '_epi2mni_seg8.mat'])); 
    
end

end

