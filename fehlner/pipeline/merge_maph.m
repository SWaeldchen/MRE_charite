function merge_maph(RAWN_SUB,DATstr)
%% Combine MA and Ph
cd(RAWN_SUB);
disp(['Merging Ma + Ph niftis... (' DATstr ')']);
% DATstr_dyn_m_4D.nii
if ~isunix %Windows
    if ~exist(fullfile(RAWN_SUB,[DATstr '_dyn_p_4D.nii']),'file')
        clear liste_p liste_m listebatch
        spm('defaults','fmri');
        spm_jobman('initcfg');
        liste_m = spm_select('FPList',RAWN_SUB,([DATstr '_dyn_ma.*\.nii$']));
        liste_p = spm_select('FPList',RAWN_SUB,([DATstr '_dyn_ph.*\.nii$']));
        clear f_m; for nf_m = 1:size(liste_m,1), f_m{1,nf_m} = liste_m(nf_m,:); end;
        clear f_p; for nf_p = 1:size(liste_p,1), f_p{1,nf_p} = liste_p(nf_p,:); end;
        listebatch{1}.spm.util.cat.vols = f_m';
        listebatch{1}.spm.util.cat.name = [DATstr '_dyn_m_4D.nii'];
        listebatch{1}.spm.util.cat.dtype = 4;
        listebatch{2}.spm.util.cat.vols = f_p';
        listebatch{2}.spm.util.cat.name = [DATstr '_dyn_p_4D.nii'];
        listebatch{2}.spm.util.cat.dtype = 4;
        spm_jobman('run',listebatch);
    end
else %Linux
    if ~exist(fullfile(RAWN_SUB,[DATstr '_dyn_m_4D.nii']),'file');
        system(['fsl5.0-fslmerge -t ' DATstr '_dyn_m_4D ' DATstr '_dyn_ma*.nii']);
        system(['fsl5.0-fslmerge -t ' DATstr '_dyn_p_4D ' DATstr '_dyn_ph*.nii']);
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