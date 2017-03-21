function [matlab_outputs] = mredge(info, prefs)
%% function [outputs] = mredge(info, prefs);
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
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   returns a structure containing outputs as specified by prefs

a = tic;
mredge_set_environment;
matlab_outputs = initialize_matlab_outputs;
disp('Organizing files');
mredge_clean_acquisition_folder(info);
mredge_organize_acquisition(info, prefs);

% OSS SNR ROUTINES

% check for compabitility routines

if strcmp(prefs.compat, 'cisnmo') == 1
    matlab_outputs = mredge_compat_cisnmo(info, prefs);
else
    % INVERSION

    if prefs.distortion_correction == 1
        disp('Distortion correction');
        
        mredge_distortion_correction(info);
        
    end
    if prefs.motion_correction == 1
        disp('Motion correction');
        
        mredge_motion_correction(info, prefs);
        
    end
    %psf stats
    % mredge_psf(info, prefs);
    if prefs.aniso_diff == 1
        disp('Anisotropic Diffusion')
        
        mredge_aniso_diff(info, prefs);
        
    end
    if prefs.gaussian == 1
        disp('Gaussian Smoothing')
        
        mredge_gaussian(info, prefs);
        
    end
    if strcmp(prefs.phase_unwrap, 'none') == 0
        disp('Phase Unwrapping')
        
        mredge_phase_unwrap(info, prefs);
        
    end
    % if no Temporal FT, some new routines need to be written
    if prefs.temporal_ft == 1
        disp('Temporal FT');
        
        mredge_temporal_ft(info, prefs);
        
    else
        disp('MREdge ERROR: Not implemented without FT yet.');
        return
        %mredge_copy_no_ft(info);
    end
    mredge_slice_align(info,prefs);
    % measure signal SNR before denoising
    mredge_amplitudes(info, prefs);
    mredge_stable_amplitudes(info, prefs);

    
    if strcmp(prefs.denoise_strategy, 'none') == 0
        disp('Denoising');
        
        mredge_denoise(info, prefs);
        
    end
    if strcmp(prefs.curl_strategy, 'none') == 0
        disp('Divergence Removal');
        mredge_remove_divergence(info, prefs);
        
    end
    %now remake amplitudes to contain denoising
    mredge_amplitudes(info, prefs);
    mredge_stable_amplitudes(info, prefs);
    mredge_displacement_snr_stable(info, prefs);

    if strcmp(prefs.inversion_strategy, 'none') == 0
        disp('Wave Inversion');
        mredge_invert(info, prefs);
    end

    mredge_stable_inversions(info, prefs, 1)
    mredge_laplacian_snr_stable(info, prefs);

    if prefs.outputs.rer == 1
        mredge_rer(info, prefs);
    end
    if prefs.outputs.springpot == 1
        mredge_springpot(info, prefs);
        %mredge_springpot_stable(info,prefs);
        mredge_springpot_stable_weighted(info, prefs);
    end
 
    if prefs.brain_analysis == 1
        mredge_masked_median(info, prefs);
        mredge_brain_analysis(info, prefs);
        mredge_brain_analysis_stable(info, prefs);
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
  
end
disp(['Total MREdge time: ' num2str(toc(a)) ]);


end


function outputs = initialize_matlab_outputs
  
  outputs.mag = [];
  outputs.phi = [];
  outputs.c = [];
  outputs.a = [];
  outputs.wavefield =[];
  outputs.snr = [];
  
end
