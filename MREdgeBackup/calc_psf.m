function [X] = calc_psf(PROJ_DATA,Asubject,n1,n2)

for subj = 1:numel(Asubject)
    disp(subj);
    SUBJ_DIR = Asubject{subj}{1};
    
    %% SPM
%     X(:,subj) = spm_est_smoothness(fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n1 '.nii']),fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n2 '.nii']));
    
    %% FSL
    [A,B] = system(['fsl5.0-smoothest -d 1 -r ' fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n1 '.nii']) ' -m ' fullfile(PROJ_DATA,SUBJ_DIR,'ANA',[n2 '.nii']) ' -V']);
    C = strsplit(B,'\n');
    D = C{1,22};
    E = strsplit(D,' ');
    for i=1:3
        F = E(4*i-1); %E(3,7,11)
        G(i) = str2num(F{1});%/2*0.65;
    end
    X(:,subj) = G;
end
