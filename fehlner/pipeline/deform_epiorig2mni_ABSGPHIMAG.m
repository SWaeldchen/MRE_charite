function deform_epiorig2mni_ABSGPHIMAG(DATA_DIR,voxsize)
disp('#### deform_epiorig2mni_ABSGPHIMAG ####');
cd(DATA_DIR);

normdata{1} = 'ABSG_orig_nc.nii';
normdata{2} = 'ABSG_orig.nii';
normdata{3} = 'ABSG_moco_nc.nii';
normdata{4} = 'ABSG_moco.nii';
normdata{5} = 'PHI_orig_nc.nii';
normdata{6} = 'PHI_orig.nii';
normdata{7} = 'PHI_moco_nc.nii';
normdata{8} = 'PHI_moco.nii';
normdata{9} = 'MAGm_orig.nii';
normdata{10} = 'MAGm_moco.nii';
normdata{11} = 'MAGf_orig.nii';
normdata{12} = 'AMP_orig_nc.nii';
normdata{13} = 'AMP_orig.nii';
normdata{14} = 'AMP_moco_nc.nii';
normdata{15} = 'AMP_moco.nii';

for knormdata = 1:length(normdata)
    
    if ~exist(fullfile(DATA_DIR,['MNI_' normdata{knormdata}]),'file');
        if exist(fullfile(DATA_DIR,['EPI_' normdata{knormdata}]),'file');
        disp(['...write_normalise... ' normdata{knormdata}]);
        
        clear matlabbatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = {fullfile(DATA_DIR,'MNI_y_epi2mni_orig.nii')};
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {fullfile(DATA_DIR,['EPI_' normdata{knormdata}])};
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = voxsize;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        spm_jobman('run',matlabbatch);
        
        movefile(fullfile(DATA_DIR,['wEPI_' normdata{knormdata}]),fullfile(DATA_DIR,['MNI_' normdata{knormdata}]));
        
        end
    end
    
end

end
