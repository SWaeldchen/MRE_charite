function deform_epi2mni(DATA_DIR,filename,voxsize)
disp('#### deform_epi2mni ####');
cd(DATA_DIR);

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

wnormdata{1} = ['wx_Twarp_'  filestr '_epi2mni.nii'];
wnormdata{2} = ['wy_Twarp_'  filestr '_epi2mni.nii'];
wnormdata{3} = ['wz_Twarp_'  filestr '_epi2mni.nii'];
wnormdata{4} = ['wx_Twarp_'  filestr '_epi2ana.nii'];
wnormdata{5} = ['wy_Twarp_'  filestr '_epi2ana.nii'];
wnormdata{6} = ['wz_Twarp_'  filestr '_epi2ana.nii'];

for kwnormdata = 1:length(wnormdata)
    
    if ~exist(fullfile(DATA_DIR,['MNI_' wnormdata{kwnormdata}]),'file');
        if ~exist(fullfile(DATA_DIR,['w' wnormdata{kwnormdata}]),'file');
            disp(['...write_normalise... ' wnormdata{kwnormdata} ]);
            
            clear matlabbatch
            spm('defaults','fmri');
            spm_jobman('initcfg');
            matlabbatch{1}.spm.spatial.normalise.write.subj.def = {fullfile(DATA_DIR,['MNI_y_epi2mni_' filestr '.nii'])};
            matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {fullfile(DATA_DIR,[wnormdata{kwnormdata}])};
            matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                78 76 85];
            matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = voxsize;
            matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
            spm_jobman('run',matlabbatch);
        end
        movefile(fullfile(DATA_DIR,['w' wnormdata{kwnormdata}]),fullfile(DATA_DIR,['MNI_' wnormdata{kwnormdata}]));
    end
    
end
    

end
