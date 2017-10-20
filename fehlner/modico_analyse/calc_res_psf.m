function res = calc_res_psf(PROJ_DIR,Asubject,prestr)
disp('CALC PSF');

A1 = calc_psf(PROJ_DIR,Asubject,[prestr '_ABSG_orig'],[prestr '_MAGm_orig']); % ABSG_orig
A2 = calc_psf(PROJ_DIR,Asubject,[prestr '_ABSG_moco'],[prestr '_MAGm_moco']); % ABSG_moco
A3 = calc_psf(PROJ_DIR,Asubject,[prestr '_ABSG_dico'],[prestr '_MAGm_dico']); % ABSG_dico
A4 = calc_psf(PROJ_DIR,Asubject,[prestr '_ABSG_modico'],[prestr '_MAGm_modico']); % ABSG_modico

X1 = calc_psf(PROJ_DIR,Asubject,[prestr '_MAGm_orig'],[prestr '_MAGm_orig']); % MAG_orig
X2 = calc_psf(PROJ_DIR,Asubject,[prestr '_MAGm_moco'],[prestr '_MAGm_moco']); % MAG_moco
X3 = calc_psf(PROJ_DIR,Asubject,[prestr '_MAGm_dico'],[prestr '_MAGm_dico']); % MAG_dico
X4 = calc_psf(PROJ_DIR,Asubject,[prestr '_MAGm_modico'],[prestr '_MAGm_modico']); % MAG_modico

t_X1 = squeeze(mean(X1,1));
t_X2 = squeeze(mean(X2,1));
t_X3 = squeeze(mean(X3,1));
t_X4 = squeeze(mean(X4,1));

t_A1 = squeeze(mean(A1,1));
t_A2 = squeeze(mean(A2,1));
t_A3 = squeeze(mean(A3,1));
t_A4 = squeeze(mean(A4,1));

res.psf_MAG(1,1:length(t_X1))=t_X1;
res.psf_MAG(2,1:length(t_X1))=t_X2;
res.psf_MAG(3,1:length(t_X1))=t_X3;
res.psf_MAG(4,1:length(t_X1))=t_X4;

res.psf_ABSG(1,1:length(t_X1))=t_A1;
res.psf_ABSG(2,1:length(t_X1))=t_A2;
res.psf_ABSG(3,1:length(t_X1))=t_A3;
res.psf_ABSG(4,1:length(t_X1))=t_A4;

end