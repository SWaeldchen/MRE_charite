%% function [outputs] = mredge_octave(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   calls inversion pipeline specified in prefs on data set specified in info
%   may contain tweaks for Octave compatibility
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   returns a structure containing outputs as specified by prefs

function [matlab_outputs] = mredge_octave(info, prefs)

    time_all = tic;

    matlab_outputs = initialize_matlab_outputs;
    display('Organizing files')
    tic
    % OSS SNR ROUTINES
    
    if prefs.outputs.snr == 1
        mredge_clean_acquisition_folder(info);
        mredge_organize_acquisition_octave(info, prefs);
        mredge_mag2double(info);
        mredge_average_magnitude(info, prefs);
        mredge_amp_wave_snr(info, prefs);
        mredge_oss(info, prefs);
    end
    
    % INVERSION
	mredge_clean_acquisition_folder(info);
    mredge_organize_acquisition_octave(info, prefs);
    mredge_mag2double(info);

    toc
    
    if prefs.distortion_correction == 1
        display('Distortion correction');
        tic
        mredge_distortion_correction(info, prefs);
        toc
    end
    if prefs.motion_correction == 1
        display('Motion correction');
        tic
        mredge_motion_correction(info, prefs);
        toc
    end
    %psf stats
    mredge_psf(info, prefs);
    if prefs.aniso_diff == 1
        display('Anisotropic Diffusion')
        tic
        mredge_aniso_diff(info, prefs);
        toc
    end
    if prefs.gaussian == 1
        display('Gaussian Smoothing')
        tic
        mredge_gaussian(info, prefs);
        toc
    end
    if strcmp(prefs.phase_unwrap, 'none') == 0
        display('Phase Unwrapping')
        tic
        mredge_phase_unwrap(info, prefs);
        toc
    end
    % if no Temporal FT, some new routines need to be written 
    if prefs.temporal_ft == 1
        display('Temporal FT');
        tic
        mredge_temporal_ft(info, prefs);
        toc
    else
        display('MREdge ERROR: Not implemented without FT yet.');
        return
		%mredge_copy_no_ft(info);
    end
    % z stats
	% run once while noised, once after denoising
    mredge_z_xy_noise(info, prefs);
    if strcmp(prefs.denoise_strategy, 'none') == 0
        display('Denoising');
        tic
        mredge_denoise(info, prefs);
        toc
    end
    if strcmp(prefs.curl_strategy, 'none') == 0
        display('Curl Decomposition');
        tic
        mredge_curl(info, prefs);
        toc
    end
    mredge_amplitudes(info, prefs);
    mredge_stable_amplitudes(info, prefs);
    if strcmp(prefs.inversion_strategy, 'none') == 0
        display('Wave Inversion');
        tic
        mredge_invert(info, prefs);
        toc
    end
	mredge_rer(info, prefs);
    mredge_springpot(info, prefs);
    mredge_springpot_stable(info,prefs);
	mredge_springpot_stable_weighted(info, prefs);
    mredge_cortical_median(info, prefs);
    mredge_cortical_median_stable(info, prefs);
    if prefs.brain_analysis == 1
        mredge_brain_analysis(info, prefs);
    end
    
    % set outputs
	%{
    if prefs.outputs.matlab.absg == 1
        outputs.mag = mredge_load_absg;
    end
    if prefs.outputs.matlab.phi == 1
        outputs.phi = mredge_load_phi;
    end
    if prefs.outputs.matlab.c == 1
        outputs.c = mredge_load_c;
    end
    if prefs.outputs.matlab.a == 1
        outputs.a = mredge_load_a;
    end
    if prefs.outputs.matlab.wavefield == 1
        outputs.wavefield = mredge_load_wavefield;
    end
    if prefs.outputs.matlab.snr == 1
        outputs.snr = mredge_load_snr;
    end
	%}
    toc(time_all)
end

function outputs = initialize_matlab_outputs
  
  outputs.mag = [];
  outputs.phi = [];
  outputs.c = [];
  outputs.a = [];
  outputs.wavefield =[];
  outputs.snr = [];
  
end
