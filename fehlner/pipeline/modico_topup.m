function modico_topup(PROJ_DIR,RAWN_SUB)

if ~isunix
    copyfile(fullfile(PROJ_DIR,'topup_param.txt'),RAWN_SUB);
else

cd(RAWN_SUB);
disp('Preparing data for distortion correction via TOPUP ...');
!gunzip -f *.gz
system('fsl5.0-fslmerge -t RLLR RL_dico_ma.nii LR_dico_ma.nii');
!gunzip -f *.gz
if ~exist('my_field.nii','file')
    system('fsl5.0-topup --imain=RLLR --datain=topup_param.txt --config=b02b0.cnf --out=my_topup_results --fout=my_field --iout=uRLLR');
    !gunzip -f *.gz
end

end

