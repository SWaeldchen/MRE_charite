function outputs = mredge(info, prefs)
% Base function for the processing and analysis of MRE data
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   returns a structure containing outputs as specified by prefs
%
% EXAMPLE USAGE:
%
%   local_data_path = pwd; % copy raw data locally before running MREdge!
%   info = mredge_info('path', local_data_path, 'magnitude', 2, 'phase',
%   3);
%   prefs = mredge_prefs('outputs.elastograms', 1);
%   elastograms = mredge(info, prefs);
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.

%% prepare data
a = tic;
if isempty(getenv('MREDGE_ENV_SET'))
    mredge_set_environment;
end
prefs.ds = mredge_dir_struct(info, prefs);
mredge_clean_acquisition_folder(info);
mredge_dicom_to_nifti(info, prefs);
mredge_organize_acquisition(info, prefs);
if prefs.downsample
    mredge_downsample(prefs);
end
mredge_average_magnitude(info, prefs);
save(fullfile(mredge_analysis_path(info, prefs), 'infoprefs.mat'), 'info', 'prefs');

% check for compabitility routines
if strcmp(prefs.compat, 'cisnmo')
    outputs = mredge_compat_cisnmo(info, prefs);
else
    %% preprocess
    if prefs.distortion_correction && strcmpi(prefs.dico_method, 'raw')
        mredge_distortion_correction(info, prefs);
    end
    if prefs.motion_correction
        mredge_motion_correction(info, prefs);
    end
    if prefs.denoise_raw
        mredge_denoise_raw(info, prefs);
    end
    if ~strcmp(prefs.phase_unwrap, 'none')
        mredge_phase_unwrap(info, prefs);
    end
    mredge_temporal_ft(info, prefs);
    if prefs.remove_ipds
        mredge_slice_align(info,prefs);
        mredge_remove_ipds(info, prefs);
    end
    if ~prefs.denoise_raw && ~strcmpi(prefs.denoise_strategy, 'none')
        mredge_denoise(info, prefs);
    end
    if ~strcmpi(prefs.curl_strategy, 'none')
        mredge_remove_divergence(info, prefs);
    end
    if prefs.highpass || prefs.lowpass
        mredge_bandpass(info, prefs);
    end
    mredge_snr(info, prefs);
    if prefs.slicewise_snr
        mredge_slicewise_snr(info,prefs);
    end
    %% invert and generate outputs
    mredge_invert_and_stats(info,prefs)
    % set outputs
    outputs = [];
    if prefs.outputs.elastograms
        outputs.elastograms = mredge_load_elastograms(info, prefs);
    end
    if prefs.outputs.amplitudes
        outputs.amplitudes = mredge_load_amplitudes(info, prefs);
    end
    if prefs.outputs.wavefields
        outputs.wavefields = mredge_load_FT_as_5d(info, prefs);
    end
  
end
disp(['Total MREdge time: ' num2str(toc(a)) ]);
end