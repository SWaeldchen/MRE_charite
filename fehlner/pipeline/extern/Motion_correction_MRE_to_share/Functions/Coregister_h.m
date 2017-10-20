function Coregister_h(Ref,Source,S)
spm_jobman('initcfg')
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.ref = Ref;
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.source = Source;
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.other = S;
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.roptions.interp = 7;
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch_reg{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

spm('defaults', 'FMRI');
spm_jobman('serial', matlabbatch_reg);
end