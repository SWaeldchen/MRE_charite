function Realign_estimate_h(S)
spm_jobman('initcfg')
matlabbatch_reg{1}.spm.spatial.realign.estimate.data =S;
matlabbatch_reg{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch_reg{1}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch_reg{1}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
matlabbatch_reg{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;
matlabbatch_reg{1}.spm.spatial.realign.estimate.eoptions.interp = 2;
matlabbatch_reg{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch_reg{1}.spm.spatial.realign.estimate.eoptions.weight = {''};

spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch_reg);
end