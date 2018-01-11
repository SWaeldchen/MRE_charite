function mredge_ft_to_end(info, prefs)
% Calls mredge inversion pipeline, but skips mredge preprocessing
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
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
if prefs.temporal_ft == 1
    display('Temporal FT');
    
    mredge_temporal_ft(info, prefs);
    
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
    
    mredge_denoise(info, prefs);
    
end
if strcmp(prefs.curl_strategy, 'none') == 0
    display('Curl Decomposition');
    
    mredge_curl(info, prefs);
    
end
mredge_amplitudes(info, prefs);
mredge_stable_amplitudes(info, prefs);

if strcmp(prefs.inversion_strategy, 'none') == 0
    display('Wave Inversion');

    if isfield(prefs, 'compat')
        if strcmp(prefs.compat, 'cisnmo') == 1
            mredge_invert_compat_cisnmo(info, prefs);
        end
    end
    mredge_invert(info, prefs);

end

mredge_stable_inversions(info, prefs, 1)

if prefs.outputs.rer == 1
    mredge_rer(info, prefs);
end
if prefs.outputs.springpot == 1
    mredge_springpot(info, prefs);
    %mredge_springpot_stable(info,prefs);
    mredge_springpot_stable_weighted(info, prefs);
end
mredge_cortical_median(info, prefs);
mredge_cortical_median_stable(info, prefs);
if prefs.brain_analysis == 1
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
toc
end

function outputs = initialize_matlab_outputs
  
  outputs.mag = [];
  outputs.phi = [];
  outputs.c = [];
  outputs.a = [];
  outputs.wavefield =[];
  outputs.snr = [];
  
end
