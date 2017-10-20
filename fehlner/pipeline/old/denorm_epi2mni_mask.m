function norm_epi2mni_mask(DATA_DIR,filename,voxsize)
disp('#### norm_epi2mni_mask ####');
cd(DATA_DIR);

if strcmp(filename,'MAGf_dico')
    filestr = 'dico';
end

if strcmp(filename,'MAGf_orig')
    filestr = 'orig';
end

if strcmp(filename,'MAGm_orig')
    filestr = '1';
end

if strcmp(filename,'MAGm_moco')
    filestr = '2';
end

if strcmp(filename,'MAGm_dico')
    filestr = '3';
end

if strcmp(filename,'MAGm_modico')
    filestr = '4';
end

normdata{1} = ['c1_epi2mni_' filestr '.nii'];
normdata{2} = ['c2_epi2mni_' filestr '.nii'];
normdata{3} = ['c3_epi2mni_' filestr '.nii'];
normdata{4} = ['c4_epi2mni_' filestr '.nii'];
normdata{5} = ['c5_epi2mni_' filestr '.nii'];


for knormdata = 1:length(normdata)
    
    if ~exist(fullfile(DATA_DIR,['MNI_' normdata{knormdata}]),'file');
        if exist(fullfile(DATA_DIR,['EPI_' normdata{knormdata}]),'file');
        disp(['...write_normalise... ' normdata{knormdata} ]);
        
        clear matlabbatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = {fullfile(DATA_DIR,['MNI_y_epi2mni_' filestr '.nii'])};
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {fullfile(DATA_DIR,['EPI_' normdata{knormdata}])};
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = voxsize;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        spm_jobman('run',matlabbatch);
        end
        movefile(fullfile(DATA_DIR,['wEPI_' normdata{knormdata}]),fullfile(DATA_DIR,['MNI_' normdata{knormdata}]));           
    end
 
    
end

    

end
