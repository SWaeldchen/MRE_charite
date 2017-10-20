function deform_ana2epi(DATA_DIR,filename)
disp(['deform_ana2epi ' filename]);

if (strcmp(filename,'EPI_MAGf_orig'))
    filestr = 'orig';
end

if (strcmp(filename,'EPI_MAGf_dico'))
    filestr ='dico';
end

if (strcmp(filename,'EPI_MAGm_orig'))
    filestr = '1';
end

if (strcmp(filename,'EPI_MAGm_moco'))
    filestr = '2';
end

if (strcmp(filename,'EPI_MAGm_dico'))
    filestr = '3';
end

if (strcmp(filename,'EPI_MAGm_modico'))
    filestr ='4';
end

normdata{1} = 'ANA_c1.nii';
normdata{2} = 'ANA_c2.nii';
normdata{3} = 'ANA_c3.nii';
normdata{4} = 'ANA_c4.nii';
normdata{5} = 'ANA_c5.nii';

cd(DATA_DIR);

if ~exist(fullfile(DATA_DIR,['EPI_segana_' filestr '_MPRAGE.nii']),'file');
    
    clear matlabbatch
    spm('defaults','fmri');
    spm_jobman('initcfg');
    
    matlabbatch{1}.spm.util.defs.comp{1}.def = {fullfile(DATA_DIR,['ANA_y_epi2ana_' filestr '.nii'])};
    matlabbatch{1}.spm.util.defs.out{1}.push.fnames = {fullfile(DATA_DIR,'MPRAGE.nii')};
    matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
    matlabbatch{1}.spm.util.defs.out{1}.push.savedir.savepwd = 1;
    matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = {fullfile(DATA_DIR,['EPI_c2_epi2mni_' filestr '.nii'])};
    matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
    matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
    spm_jobman('run',matlabbatch);
    
    movefile(fullfile(DATA_DIR,'wMPRAGE.nii'),fullfile(DATA_DIR,['EPI_segana_' filestr '_MPRAGE.nii']));
    
end

for k = 1:length(normdata)    
    
    if ~exist(fullfile(DATA_DIR,['EPI_c5_segana_' filestr '_MPRAGE.nii']),'file');
        if exist(fullfile(DATA_DIR,[normdata{k}]),'file');
            disp(['...write_normalise... ' normdata{k} ]);
            
            clear matlabbatch
            spm('defaults','fmri');
            spm_jobman('initcfg');
            
            matlabbatch{1}.spm.util.defs.comp{1}.def = {fullfile(DATA_DIR,['ANA_y_epi2ana_' filestr '.nii'])};
            matlabbatch{1}.spm.util.defs.out{1}.push.fnames = {fullfile(DATA_DIR,normdata{k})};
            matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
            matlabbatch{1}.spm.util.defs.out{1}.push.savedir.savepwd = 1;
            matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = {fullfile(DATA_DIR,['EPI_c2_epi2mni_' filestr '.nii'])};
            matlabbatch{1}.spm.util.defs.out{1}.push.preserve = 0;
            matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [0 0 0];
            spm_jobman('run',matlabbatch);
        end
        
        movefile(fullfile(DATA_DIR,['wANA_c' int2str(k) '.nii']),fullfile(DATA_DIR,['EPI_c' int2str(k) '_segana_' filestr '_MPRAGE.nii']));
        
        
    end
    
end

end
