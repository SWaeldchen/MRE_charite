

clear matlabbatch
spm('defaults','fmri');
spm_jobman('initcfg');
matlabbatch{1}.spm.util.defs.comp{1}.id.space = {'/store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/MREPERF-AFAndi_20150625-140247/ANA/MNI_c1_epi2mni_1.nii'};
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {'/store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/TPM.nii'};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savepwd = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 4;
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
spm_jobman('run',matlabbatch);