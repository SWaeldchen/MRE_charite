function merge_reim(RAWN_SUB,DATstr)
%% Combine Re and Im
cd(RAWN_SUB);
disp(['Merging Re + Im niftis... (' DATstr ')']);
% DATstr_dyn_r_4D.nii
if ~isunix %Windows
    if ~exist(fullfile(RAWN_SUB,[DATstr '_dyn_r_4D.nii']),'file')
        clear liste_r liste_i listebatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        liste_r = spm_select('FPList',RAWN_SUB,([DATstr '_dyn_re.*\.nii$']));
        liste_i = spm_select('FPList',RAWN_SUB,([DATstr '_dyn_im.*\.nii$']));
        clear f_r; for nf_r = 1:size(liste_r,1), f_r{1,nf_r} = liste_r(nf_r,:); end;
        clear f_i; for nf_i = 1:size(liste_i,1), f_i{1,nf_i} = liste_i(nf_i,:); end;
        listebatch{1}.spm.util.cat.vols = f_r';
        listebatch{1}.spm.util.cat.name = [DATstr '_dyn_r_4D.nii'];
        listebatch{1}.spm.util.cat.dtype = 4;
        listebatch{2}.spm.util.cat.vols = f_i';
        listebatch{2}.spm.util.cat.name = [DATstr '_dyn_i_4D.nii'];
        listebatch{2}.spm.util.cat.dtype = 4;
        spm_jobman('run',listebatch);
    end
else %Linux
    if ~exist(fullfile(RAWN_SUB,[DATstr '_dyn_r_4D.nii']),'file');
        system(['fsl5.0-fslmerge -t ' DATstr '_dyn_r_4D ' DATstr '_dyn_re*.nii']);
        system(['fsl5.0-fslmerge -t ' DATstr '_dyn_i_4D ' DATstr '_dyn_im*.nii']);
    end
end

tmpA = dir('*.gz');
if ~isempty(tmpA)
    tmpdat = gunzip('*.gz');
    if ~isempty(tmpdat)
        for k = 1:length(tmpdat)
            delete([tmpdat{k} '.gz']);
        end
    end
end

end