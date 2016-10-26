%% function mredge_avg_mag_to_mni(info)

%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Deforms acquisition T2 image to MNI space, and saves deformation field,
% which can be applied to elastograms
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
% none

%% collect series numbers

function mredge_avg_mag_to_mni(info, prefs)

    TPM_dir = fullfile(spm('Dir'),'tpm');
    spm('defaults','fmri');
    spm_jobman('initcfg');
    [AVG_MAG_SUB, STATS_DIR] = set_dirs(info, prefs);
    avg_mag_path = fullfile(AVG_MAG_SUB, 'Avg_Magnitude.nii.gz');
	avg_mag_path_unzip = avg_mag_path(1:end-3);
    gunzip(avg_mag_path);
    % align
    matlabbatch{1}.spm.spatial.preproc.channel.vols = {avg_mag_path_unzip};
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {fullfile(TPM_dir,'TPM.nii,1')};
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {fullfile(TPM_dir,'TPM.nii,2')};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {fullfile(TPM_dir,'TPM.nii,3')};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {fullfile(TPM_dir,'TPM.nii,4')};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {fullfile(TPM_dir,'TPM.nii,5')};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {fullfile(TPM_dir,'TPM.nii,6')};
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
    spm_jobman('run',matlabbatch);
    gzip(avg_mag_path_unzip);
    delete(avg_mag_path_unzip);
    
    seg_filepath = fullfile(STATS_DIR, 'pct_segmented_voxels.csv');
    if exist(seg_filepath, 'file')
      delete(seg_filepath);
    end
    calc_segmented_voxels(AVG_MAG_SUB, seg_filepath);
    
    deform_filepath = fullfile(STATS_DIR, 'deformation_variance.csv');
    if exist(deform_filepath, 'file')
      delete(deform_filepath);
    end
    calc_deformation_variance(AVG_MAG_SUB, deform_filepath);
end

function [AVG_MAG_SUB, STATS_DIR] = set_dirs(info, prefs)
    AVG_MAG_SUB = mredge_analysis_path(info, prefs, 'Magnitude');
    STATS_DIR = mredge_analysis_path(info, prefs, 'Stats');
end

function calc_segmented_voxels(AVG_MAG_SUB, seg_filepath)
    fileID = fopen(seg_filepath, 'a');
    pcts = zeros(5,1);
    for n = 1:5
        file_path = fullfile(AVG_MAG_SUB, ['c', num2str(n), 'Avg_Magnitude.nii']);
        seg_vol = load_untouch_nii(file_path);
        seg_img = seg_vol.img;
        num_vox = numel(seg_img);
        pcts(n) = numel(seg_img(seg_img > 128)) ./ num_vox;
    end
    fprintf(fileID, '%1.3f \n%1.3f \n %1.3f \n %1.3f \n %1.3f \n', pcts(1), pcts(2), pcts(3), pcts(4), pcts(5));
end

function calc_deformation_variance(AVG_MAG_SUB, deform_filepath)
    fileID = fopen(deform_filepath, 'a');
    seg8 = load(fullfile(AVG_MAG_SUB, 'Avg_Magnitude_seg8.mat'));
    vars = zeros(3, 1);
    for n = 1:3
        field = seg8.Twarp(:,:,:,n);
        vars(n) = var(field(:));
    end
    fprintf(fileID, '%1.3f \n %1.3f \n %1.3f \n', vars(1), vars(2), vars(3));
end      
    
