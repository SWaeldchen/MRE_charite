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

function mredge_zden(info, prefs)
	time = tic;
	[FT_DIR, RESID_DIR] = set_dirs(info, prefs);
	NIF_EXT = getenv('NIFTI_EXTENSION');
    PAD = 5;
    if ~exist(RESID_DIR, 'dir')
        mkdir(RESID_DIR);
    end
    mask = mredge_load_mask(info, prefs);
      parfor f_num = 1:numel(info.driving_frequencies)
          f = info.driving_frequencies(f_num);
          disp([num2str(f), ' Hz']);
          for c = 1:3
              display(num2str(c));
              wavefield_path = fullfile(FT_DIR, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT)); %#ok<PFBNS>
              wavefield_vol = load_untouch_nii_eb(wavefield_path);
              wavefield_img = wavefield_vol.img;
              resid_vol = wavefield_vol;
              if strcmp(prefs.denoise_strategy, 'z_xy') == 1 %#ok<PFBNS>
                  wavefield_img = dtdenoise_z_mad_u(wavefield_img, prefs.denoise_settings.z_thresh_factor, prefs.denoise_settings.z_level, 1);
              elseif strcmp(prefs.denoise_strategy, '3d') || strcmp(prefs.denoise_strategy, '2d') ||...
                (prefs.distortion_correction == 1 && strcmpi(prefs.dico_method, 'ft') )
                  wavefield_img = dejitter_phase_mask(wavefield_img, logical(mask), 0.5, 256);
                  wavefield_img = zden_3D_DWT(wavefield_img, prefs.denoise_settings.z_level, mask, prefs.denoise_settings.z_hipass_cut);
              end
              wavefield_vol.img = wavefield_img;
              resid_vol.img = resid_vol.img - wavefield_img;
              save_untouch_nii(wavefield_vol, wavefield_path);
          end
      end
	  disp(['Dejitter time: ', num2str(toc(time))]);
end

function [FT_DIR, RESID_DIR] = set_dirs(info, prefs)
    FT_DIR = mredge_analysis_path(info,prefs,'FT');
    RESID_DIR = mredge_analysis_path(info,prefs,'DENOISE_RESID');
end


