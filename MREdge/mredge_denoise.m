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
	time = tic;
	[FT_DIR, RESID_DIR] = set_dirs(info, prefs);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    if ~exist(RESID_DIR, 'dir')
        mkdir(RESID_DIR);
    end
    mask = mredge_load_mask(info, prefs);
      parfor f_num = 1:numel(info.driving_frequencies)
          f = info.driving_frequencies(f_num);
          disp([num2str(f), ' Hz']);
          for c = 1:3
              display(num2str(c));
              wavefield_path = fullfile(FT_DIR, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION)); %#ok<PFBNS>
              wavefield_vol = load_untouch_nii_eb(wavefield_path);
              wavefield_img = wavefield_vol.img;
              resid_vol = wavefield_vol;
              if strcmp(prefs.denoise_strategy, 'z_xy') == 1 %#ok<PFBNS>
                  wavefield_img = dtdenoise_z_mad_u(wavefield_img, prefs.denoise_settings.z_thresh_factor, prefs.denoise_settings.z_level, 1);
                  wavefield_img = dtdenoise_xy_pca_mad_u(wavefield_img, prefs.denoise_settings.xy_thresh_factor, prefs.denoise_settings.xy_level, 1, mask);
              elseif strcmp(prefs.denoise_strategy, '3d') == 1
                  wavefield_img = zden_3D_DWT(real(wavefield_img), prefs.denoise_settings.z_level, mask) + 1i*zden_3D_DWT(imag(wavefield_img), prefs.denoise_settings.z_level, mask);
                  wavefield_img = dtdenoise_3d_mad_ogs_undec(wavefield_img, prefs.denoise_settings.xy_thresh_factor, prefs.denoise_settings.xy_level, 1);
              elseif strcmp(prefs.denoise_strategy, 'lowpass') == 1
                  if prefs.lowpass_settings.dimensions == 2
                      if strcmpi(prefs.lowpass_settings.cutoff_unit, 'norm')
                          for z=1:size(wavefield_img,3)
                             wavefield_img(:,:,z) = butter_2d(prefs.lowpass_settings.order, prefs.lowpass_settings.cutoff, wavefield_img(:,:,z));
                          end
                      elseif strcmpi(prefs.lowpass_settings.cutoff_unit, 'wpm')
                          wpm = prefs.lowpass_settings.cutoff;
                          for z=1:size(wavefield_img,3)
                             wavefield_img(:,:,z) = uh_filtspatio2d(wavefield_img(:,:,z),[info.voxel_spacing(1); info.voxel_spacing(2)],prefs.lowpass_settings.cutoff,1,0,5, 'bwlow', 0);
                          end
                      else
                          disp('MREdge ERROR: lowpass units not recognized');
                      end
                  else
                      wavefield_img = butter_3d(prefs.lowpass_settings.order, prefs.lowpass_settings.cutoff, wavefield_img);
                  end
              elseif strcmp(prefs.denoise_strategy, '3d') == 1
                  wavefield_img = mredge_denoise_3d(wavefield_img);
              end
              wavefield_vol.img = wavefield_img;
              resid_vol.img = resid_vol.img - wavefield_img;
              save_untouch_nii(wavefield_vol, wavefield_path);
              resid_dir = fullfile(RESID_DIR, num2str(f), num2str(c));  %#ok<PFBNS>
              if ~exist(resid_dir, 'dir')
                  mkdir(resid_dir);
              end
              resid_path = fullfile(resid_dir, mredge_filename(f, c, NIFTI_EXTENSION));
              save_untouch_nii(resid_vol, resid_path);
          end
      end
    
	disp(['Denoising time: ', num2str(toc(time))]);
end

function [FT_DIR, RESID_DIR] = set_dirs(info, prefs)
    FT_DIR = mredge_analysis_path(info,prefs,'FT');
    RESID_DIR = mredge_analysis_path(info,prefs,'DENOISE_RESID');
end


