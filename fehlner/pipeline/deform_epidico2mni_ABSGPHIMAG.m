function deform_epidico2mni_ABSGPHIMAG(DATA_DIR,voxelsize)
disp('#### deform_epidico2mni_ABSGPHIMAG ####');
cd(DATA_DIR);

normdata{1} = 'ABSG_dico_nc.nii';
normdata{2} = 'ABSG_dico.nii';
normdata{3} = 'ABSG_modico_nc.nii';
normdata{4} = 'ABSG_modico.nii';
normdata{5} = 'PHI_dico_nc.nii';
normdata{6} = 'PHI_dico.nii';
normdata{7} = 'PHI_modico_nc.nii';
normdata{8} = 'PHI_modico.nii';
normdata{9} = 'MAGm_dico.nii';
normdata{10} = 'MAGm_modico.nii';
normdata{11} = 'MAGf_dico.nii';
normdata{12} = 'myfield.nii';

for knormdata = 1:length(normdata)
    
    if ~exist(fullfile(DATA_DIR,['MNI_' normdata{knormdata}]),'file');
        if exist(fullfile(DATA_DIR,['EPI_' normdata{knormdata}]),'file');
        disp(['...write_normalise... ' normdata{knormdata} ]);
        
        clear matlabbatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = {fullfile(DATA_DIR,'MNI_y_epi2mni_dico.nii')};
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {fullfile(DATA_DIR,['EPI_' normdata{knormdata}])};
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = voxelsize;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        spm_jobman('run',matlabbatch);
        
        movefile(fullfile(DATA_DIR,['wEPI_' normdata{knormdata}]),fullfile(DATA_DIR,['MNI_' normdata{knormdata}]));
        
        end
    end
    
end

end
