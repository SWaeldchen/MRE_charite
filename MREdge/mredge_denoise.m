%% function mredge_denoise(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Deonise the complex wave field.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_denoise(info, prefs)

	[FT_DIRS, RESID_DIRS] = set_dirs(info, prefs);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    for n = 1:numel(RESID_DIRS)
        if ~exist(RESID_DIRS{n}, 'dir')
            mkdir(RESID_DIRS{n});
        end
    end
    mask = mredge_load_mask(info, prefs);
    for d = 1:numel(FT_DIRS)
        for f_num = 1:numel(info.driving_frequencies)
			f = info.driving_frequencies(f_num);
            disp([num2str(f), ' Hz']);
            for c = 1:3
                display(num2str(c));
                wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION)); %#ok<PFBNS>
                wavefield_vol = load_untouch_nii_eb(wavefield_path);
				wavefield_img = wavefield_vol.img;
                resid_vol = wavefield_vol;
                if strcmp(prefs.denoise_strategy, 'z_xy') == 1 %#ok<PFBNS>
                    wavefield_img = dtdenoise_z_mad_u(wavefield_img, prefs.denoise_settings.z_thresh_factor, prefs.denoise_settings.z_level);
                    wavefield_img = dtdenoise_xy_pca_mad_u(wavefield_img, prefs.denoise_settings.xy_thresh_factor, prefs.denoise_settings.xy_level, 1, mask);
                elseif strcmp(prefs.denoise_strategy, '3d') == 1
                    wavefield_img = dtdenoise_z_mad_u(wavefield_img, prefs.denoise_settings.z_level, prefs.denoise_settings.z_thresh_factor);
                    wavefield_img = dtdenoise_3d_mad_ogs_undec(wavefield_img, prefs.denoise_settings.xy_level, prefs.denoise_settings.xy_thresh_factor);
                elseif strcmp(prefs.denoise_strategy, 'lowpass') == 1
					if prefs.lowpass_settings.dimensions == 2
						if strcmp(prefs.lowpass_settings.cutoff_unit, 'norm') == 1
							wpm = mredge_convert_norm_thresh_to_wpm(prefs.lowpass_settings.cutoff, info.voxel_spacing(1), size(wavefield_img, 1), size(wavefield_img, 2));
						elseif strcmp(prefs.lowpass_settings.cutoff_unit, 'wpm') == 1
                            disp('wpm');
							wpm = prefs.lowpass_settings.cutoff;
						else
							display('MREdge ERROR: Lowpass denoise settings not compatible.');
						end
						for z=1:size(wavefield_img,3)
						   wavefield_img(:,:,z) = uh_filtspatio2d(wavefield_img(:,:,z),[info.voxel_spacing(1); info.voxel_spacing(2)],prefs.lowpass_settings.cutoff,1,0,5, 'bwlow', 0);
						end
					end
                elseif strcmp(prefs.denoise_strategy, '3d') == 1
                    wavefield_img = mredge_denoise_3d(wavefield_img);
                end
                wavefield_vol.img = wavefield_img;
                resid_vol.img = resid_vol.img - wavefield_img;
				save_untouch_nii(wavefield_vol, wavefield_path);
                resid_dir = fullfile(RESID_DIRS{d}, num2str(f), num2str(c));  %#ok<PFBNS>
                if ~exist(resid_dir, 'dir')
                    mkdir(resid_dir);
                end
                resid_path = fullfile(resid_dir, mredge_filename(f, c, NIFTI_EXTENSION));
                save_untouch_nii(resid_vol, resid_path);
            end
        end
    end
    

end

function [FT_DIRS, RESID_DIRS] = set_dirs(info, prefs)
	if strcmp(prefs.phase_unwrap, 'gradient') == 1;
		FT_X = mredge_analysis_path(info,prefs,'FT_X');
		FT_Y = mredge_analysis_path(info,prefs,'FT_Y');
		FT_DIRS = cell(2,1);
		FT_DIRS{1} = FT_X;
		FT_DIRS{2} = FT_Y;
		RESID_X = mredge_analysis_path(info,prefs,'DENOISE_RESID_X');
		RESID_Y = mredge_analysis_path(info,prefs,'DENOISE_RESID_Y');
		RESID_DIRS = cell(2,1);
		RESID_DIRS{1} = RESID_X;
		RESID_DIRS{2} = RESID_Y;
	else
		FT_SUB = mredge_analysis_path(info,prefs,'FT');
		FT_DIRS = cell(1,1);
		FT_DIRS{1} = FT_SUB;
		RESID_SUB = mredge_analysis_path(info,prefs,'DENOISE_RESID');
		RESID_DIRS = cell(1,1);
		RESID_DIRS{1} = RESID_SUB;
	end
end


