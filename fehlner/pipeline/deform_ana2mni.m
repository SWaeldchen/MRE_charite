function deform_ana2mni(DATA_DIR)
disp('deform_ana2mni');

normdata{1} = 'MPRAGE.nii';
normdata{2} = 'ANA_c1.nii';
normdata{3} = 'ANA_c2.nii';
normdata{4} = 'ANA_c3.nii';
normdata{5} = 'ANA_c4.nii';
normdata{6} = 'ANA_c5.nii';

for knormdata = 1:length(normdata)
    if ~exist(fullfile(DATA_DIR,['MNI_' normdata{knormdata}]),'file');
        disp(['...deform_ana2mni... ' normdata{knormdata} ]);
        
        clear matlabbatchs
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.util.defs.comp{1}.def = {fullfile(DATA_DIR,'ANA_iy_MPRAGE.nii')};
        matlabbatch{1}.spm.util.defs.out{1}.push.fnames = {fullfile(DATA_DIR,[normdata{knormdata}])};
        matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
        matlabbatch{1}.spm.util.defs.out{1}.push.savedir.savepwd = 1;
        matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = {fullfile(DATA_DIR,'MNI_MAGf_orig.nii')};
        matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
        matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
        spm_jobman('run',matlabbatch);
        
        movefile(fullfile(DATA_DIR,['w' normdata{knormdata}]),fullfile(DATA_DIR,['MNI_' normdata{knormdata}]));
    end
end

end
