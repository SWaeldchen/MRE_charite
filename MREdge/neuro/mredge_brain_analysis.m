function mredge_brain_analysis(info, prefs)
%% function mredge_brain_analysis(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   coregisters and labels brain results
%
%   If you use this method cite
%
%   [fehlner ref to come]
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
    t = tic;
	mredge_avg_mag_to_mni(info, prefs);

    if strcmpi(prefs.inversion_strategy, 'MDEV')
        if prefs.outputs.absg
            brain_analysis(info, prefs, 'Abs_G');
        end
        if prefs.outputs.springpot
            brain_analysis_springpot(info, prefs);
        end
        if prefs.outputs.c
            brain_analysis(info, prefs, 'C');
        end
        if prefs.outputs.a
            brain_analysis(info, prefs, 'A');
        end
        if prefs.outputs.amplitude
            brain_analysis(info, prefs, 'amp');
        end
    elseif strcmpi(prefs.inversion_strategy, 'SFWI')
        brain_analysis(info, prefs, 'SFWI');
        %brain_analysis(info, prefs, 'HELM');
    end
    if prefs.sliding_windows
        mredge_brain_analysis_sliding(info, prefs);
    end
    disp(['Brain analysis time: ', num2str(toc(t))]);
    
end

function brain_analysis(info, prefs, param)
    
    mredge_coreg_param_to_mni(info, prefs, param);
    mredge_mni_to_label_space(info, prefs, param);
    mredge_label_param_map(info, prefs, param);
    
end

function brain_analysis_springpot(info, prefs)
    
    mredge_coreg_param_to_mni_springpot(info, prefs);
    mredge_mni_to_label_space_springpot(info, prefs);
    mredge_label_param_map_springpot(info, prefs);
    
end
