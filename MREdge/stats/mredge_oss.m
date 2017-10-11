%% function mredge_oss(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Determines OSS-SNR and Motion SNR.
%
%   OSS-SNR method from the work of:
%
%   McGarry, M. D. J., Van Houten, E. E. W., Perrinez, P. R., Pattison,
%   A. J., Weaver, J. B., & Paulsen, K. D. (2011). An octahedral shear
%   strain-based measure of SNR for 3D MR elastography. Physics in
%   medicine and biology, 56(13), N153.
%
%   Motion SNR from the work of:
%
%   Sinkus, R., Tanter, M., Xydeas, T., Catheline, S., Bercoff, J., &
%   Fink, M. (2005). Viscoelastic shear properties of in vivo breast
%   lesions measured by MR elastography. Magnetic resonance imaging,
%   23(2), 159-165.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_oss(info, prefs, label)

    if nargin < 3
        label = '';
    end
	display('Calculating OSS');
    mask = mredge_load_mask(info, prefs);
    magnitude = mredge_load_magnitude_as_6d(info);
    oss_snr_file_path = fullfile(mredge_analysis_path(info, prefs, 'stats'), [label, 'oss_snr.csv']);
    oss_snr_ID = fopen(oss_snr_file_path, 'w');
    fprintf(oss_snr_ID, 'F, OSS SNR \n');
    motion_snr_file_path = fullfile(mredge_analysis_path(info, prefs, 'stats'), [label, 'motion_snr.csv']);
    motion_snr_ID = fopen(motion_snr_file_path, 'w');
    fprintf(motion_snr_ID, 'F, Motion SNR \n');
    for f = 1:numel(info.ds.subdirs)
        components = [];
        components_ts = [];
        for c = 1:3
            subdir = mredge_file_component_path(info.ds.subdirs(f), c);
            wavefield_path = fullfile(mredge_analysis_path(info, prefs, 'FT'), subdir);
            wavefield_vol = load_untouch_nii_eb(wavefield_path);
            components = cat(4, components, wavefield_vol.img);
            ts = ft_to_time_steps(wavefield_vol.img, magnitude(:,:,:,:,f,c));
            components_ts = cat(5, components_ts, ts);
        end
        E = strain_tensor(components);
        [OSS_SNR,Motion_SNR,OSS_SNR_Dist,Motion_SNR_Dist,oss,ons]=Strain_SNR_from_phase(denoised_components,mask,info.voxel_spacing); %#ok<ASGLU>

        oss_snr_ID = fopen(oss_snr_file_path, 'a');
        fprintf(oss_snr_ID, '%d, %1.3f \n',f, OSS_SNR);
        fclose(oss_snr_ID);
        motion_snr_ID = fopen(motion_snr_file_path, 'a');
        fprintf(motion_snr_ID, '%d, %1.3f \n',f, Motion_SNR);
        fclose(motion_snr_ID);
    end
    fclose('all');
end
