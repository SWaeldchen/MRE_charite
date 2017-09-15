
function mni_to_label_space(path, file)

    tpm_path = fullfile(spm('Dir'), 'tpm', 'labels_Neuromorphometrics.nii');
    filepath = fullfile(path, ['w',file]);
	spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.coreg.write.ref = {tpm_path};
    matlabbatch{1}.spm.spatial.coreg.write.source = {filepath};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
    evalc('spm_jobman(''run'',matlabbatch);');
    
end