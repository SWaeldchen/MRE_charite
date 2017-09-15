
%%
function coreg_param_to_mni(path, magname, paramname, voxel_spacing)

if nargin < 4
    voxel_spacing = [2 2 2];
end
    mag_file = fullfile(path, ['y_',magname]);
    param_file = fullfile(path, paramname);
    spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.normalise.write.subj.def = {mag_file};
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {param_file};
    matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = voxel_spacing;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
    spm_jobman('run',matlabbatch);
end
