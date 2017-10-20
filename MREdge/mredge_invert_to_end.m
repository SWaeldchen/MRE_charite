function mredge_invert_to_end(info, prefs)
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
    
    if ~strcmp(prefs.inversion_strategy, 'none')
        disp('Wave Inversion');
        mredge_invert(info, prefs);
    end
    mredge_amplitudes(info, prefs);
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
  
disp(['Total MREdge time: ' num2str(toc(a)) ]);
cd(mredge_analysis_path(info, prefs));
end