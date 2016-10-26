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

function mredge_oss(info, prefs)

	
	display('Calculating OSS');
	[PHASE_SUB, OSS_SUB, STATS_SUB] = set_dirs(info, prefs);
    if ~exist(OSS_SUB, 'dir')
        mkdir(OSS_SUB)
    end
	RGA_DIFFERENCES_FILE_PATH = '/home/ericbarnhill/barnhill-eclipse-workspace/PhaseTools/differences.dat';
	NIFTI_EXTENSION = '.nii.gz';
	mredge_average_magnitude(info, prefs);
    oss_snr_file_path = fullfile(STATS_SUB, 'oss_snr.csv');
    oss_snr_ID = fopen(oss_snr_file_path, 'w');
    fprintf(oss_snr_ID, 'F, OSS SNR \n');
    motion_snr_file_path = fullfile(STATS_SUB, 'motion_snr.csv');
    motion_snr_ID = fopen(motion_snr_file_path, 'w');
    fprintf(motion_snr_ID, 'F, Motion SNR \n');
    fclose('all');
    parfor f_num = 1:numel(info.driving_frequencies)
		f = info.driving_frequencies(f_num);
		denoised_components = []; % cat strategy
		for c = 1:3
			tic
			display([num2str(f), ' ', num2str(c)]);
			vol_path = fullfile(PHASE_SUB, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
			vol = load_untouch_nii(vol_path);
			rg4d = com.ericbarnhill.phaseTools.RG4D;
			rg4d.setDifferencesFilePath(RGA_DIFFERENCES_FILE_PATH);
			vol.img =  rga_progressive(vol.img, rg4d); 
			vol.img =  dtdenoise_z_auto_noise_est(vol.img, prefs.denoise_settings.z_level, 'w1', 0);
			vol.img =  dtdenoise_xy_pca_mad(vol.img, prefs.denoise_settings.xy_thresh_factor, prefs.denoise_settings.xy_num_spins,0);
			denoised_components = cat(5, denoised_components, vol.img);
			toc
		end
		mask = mredge_load_mask(info,prefs);
		[OSS_SNR,Motion_SNR,OSS_SNR_Dist,Motion_SNR_Dist,oss,ons]=Strain_SNR_from_phase(denoised_components,mask,info.voxel_spacing); %#ok<ASGLU>
        oss_snr_ID = fopen(oss_snr_file_path, 'a');
        fprintf(oss_snr_ID, '%d, %1.3f \n',f, OSS_SNR);
        fclose(oss_snr_ID);
        motion_snr_ID = fopen(motion_snr_file_path, 'a');
        fprintf(motion_snr_ID, '%d, %1.3f \n',f, Motion_SNR);
        fclose(motion_snr_ID);
    end

end

function [PHASE_SUB, OSS_SUB, STATS_SUB] = set_dirs(info, prefs)
	PHASE_SUB = fullfile(info.path, 'Phase');
	OSS_SUB = mredge_analysis_path(info, prefs, 'OSS');
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
end
