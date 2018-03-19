function mredge_avg_mag_to_mni(info, prefs)
% Co-registers magnitude image to MNI space. The deformation map is then used to co-register all elasticity maps.
%
% INPUTS:
%
%   info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_brain_analysis, mredge_coreg_param_to_mni,
%   mredge_mni_to_label_space, mredge_label_parameter_map
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%

%% collect series numbers


    NIF_EXT = getenv('NIFTI_EXTENSION');
    AVG_MAG_SUB = mredge_analysis_path(info, prefs, 'magnitude');
    STATS_DIR = mredge_analysis_path(info, prefs, 'stats');
    avg_mag_path = fullfile(AVG_MAG_SUB, ['t_avg_magnitude', NIF_EXT]);
    % align
    if false
    %if exist(fullfile(AVG_MAG_SUB, ['y_t_avg_magnitude', NIF_EXT]), 'file')
        disp('MREdge: Magnitude appears to already be co-registered to MNI SPACE. Skipping this step');
        return
    else 
        TPM_dir = fullfile(spm('Dir'),'tpm');
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch{1}.spm.spatial.preproc.channel.vols = {avg_mag_path};
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
        %evalc('spm_jobman(''run'',matlabbatch);');
        spm_jobman('run',matlabbatch);

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
end

function calc_segmented_voxels(AVG_MAG_SUB, seg_filepath)
    NIF_EXT = getenv('NIFTI_EXTENSION');
    fileID = fopen(seg_filepath, 'a');
    pcts = zeros(5,1);
    for n = 1:5
        file_path = fullfile(AVG_MAG_SUB, ['c', num2str(n), 't_avg_magnitude', NIF_EXT]);
        seg_vol = load_untouch_nii_eb(file_path);
        seg_img = seg_vol.img;
        num_vox = numel(seg_img);
        pcts(n) = numel(seg_img(seg_img > 128)) ./ num_vox;
    end
    fprintf(fileID, '%1.3f\n%1.3f\n %1.3f\n%1.3f\n%1.3f\n', pcts(1), pcts(2), pcts(3), pcts(4), pcts(5));
end

function calc_deformation_variance(AVG_MAG_SUB, deform_filepath)
    fileID = fopen(deform_filepath, 'a');
    seg8 = load(fullfile(AVG_MAG_SUB, 't_avg_magnitude_seg8.mat'));
    vars = zeros(3, 1);
    for n = 1:3
        field = seg8.Twarp(:,:,:,n);
        vars(n) = var(field(:));
    end
    fprintf(fileID, ' %1.3f\n%1.3f\n %1.3f\n', vars(1), vars(2), vars(3));
end      
    
