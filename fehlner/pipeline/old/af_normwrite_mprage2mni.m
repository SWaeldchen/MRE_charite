function af_normwrite_mprage2mni(DATA_DIR)
disp('#### af_normwrite_mprage2mni ####');
cd(DATA_DIR);

normdata{1} =   'MPRAGE_mprage';
normdata{2} = 'c1MPRAGE_mprage';
normdata{3} = 'c2MPRAGE_mprage';
normdata{4} = 'c3MPRAGE_mprage';
normdata{5} = 'c4MPRAGE_mprage';
normdata{6} = 'c5MPRAGE_mprage';


for knormdata = 1:length(normdata)   

    if ~exist(fullfile(DATA_DIR,[normdata{knormdata} '_mni.nii']),'file');
        disp(['...write_normalise... ' normdata{knormdata} ]);
        
        clear matlabbatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = { fullfile(DATA_DIR,'y_MPRAGEsegmprage2mni.nii')};
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = { fullfile(DATA_DIR,[normdata{knormdata} '.nii']) };
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        spm_jobman('run',matlabbatch);
        
       movefile(fullfile(DATA_DIR,[normdata{knormdata} '.nii']), fullfile(DATA_DIR,[normdata{knormdata} '_mni.nii']));
    end
end


end

