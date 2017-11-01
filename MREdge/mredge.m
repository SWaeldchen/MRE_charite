function [matlab_outputs] = mredge(info, prefs)
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
mredge_dicom_to_nifti(info);
mredge_organize_acquisition(info);
mredge_create_analysis_folder(info, prefs);
mredge_average_magnitude(info, prefs);
save(fullfile(info.path, 'infoprefs.mat'), 'info', 'prefs');

% OSS SNR ROUTINES

% check for compabitility routines

if strcmp(prefs.compat, 'cisnmo')
    matlab_outputs = mredge_compat_cisnmo(info, prefs);
else
    % no compatibility routines

    if prefs.distortion_correction && strcmpi(prefs.dico_method, 'raw')
        disp('Distortion correction');
        tic
        mredge_distortion_correction(info, prefs);
        toc
    end
    if prefs.motion_correction
        disp('Motion correction');
        tic
        mredge_motion_correction(info, prefs);
        toc
    end
    if prefs.denoise_raw
        disp('Raw data denoise');
        tic
        mredge_denoise_raw(info, prefs);
        toc
    end
    if ~strcmp(prefs.phase_unwrap, 'none')
        disp('Phase Unwrapping')
        tic
        mredge_phase_unwrap(info, prefs);
        toc
    end
       
    mredge_temporal_ft(info, prefs);
    mredge_slice_align(info,prefs);
    mredge_amplitudes(info, prefs);

    if prefs.remove_ipds
        disp('IPD Removal');
        tic
        mredge_remove_ipds(info, prefs);
        toc
    end
    %{
    if prefs.outputs.snr.oss
        mredge_oss(info, prefs, 'pre');
    end
    if prefs.outputs.snr.laplacian
        mredge_laplacian_snr(info, prefs, 'pre');
    end
    %}
    if ~prefs.denoise_raw && ~strcmpi(prefs.denoise_strategy, 'none')
        disp('Denoising');
        tic
        mredge_denoise(info, prefs);
        toc
    end
    if ~strcmpi(prefs.curl_strategy, 'none')
        disp('Hodge Decomposition');
        mredge_remove_divergence(info, prefs);
    end
    if prefs.highpass || prefs.lowpass
        disp('Bandpass');
        tic
        mredge_bandpass(info, prefs);
        toc
    end
    
    if prefs.outputs.snr.oss
        %mredge_oss(info, prefs, 'post');
    end
    if prefs.outputs.snr.laplacian
        mredge_laplacian_snr(info, prefs, 'post');
    end
    
    if ~strcmp(prefs.inversion_strategy, 'none')
        disp('Wave Inversion');
        tic
        mredge_invert(info, prefs);
        toc
    end
    mredge_masked_median(info, prefs);
    if prefs.brain_analysis
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
  
end
disp(['Total MREdge time: ' num2str(toc(a)) ]);
cd(mredge_analysis_path(info, prefs));
end


function outputs = initialize_matlab_outputs
  
  outputs.mag = [];
  outputs.phi = [];
  outputs.c = [];
  outputs.a = [];
  outputs.wavefield =[];
  outputs.snr = [];
  
end
