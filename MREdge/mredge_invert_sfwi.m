%% function mredge_invert_sfwi(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   create an elastogram of param using the SFWI approach
%
%   If you use this method cite
%
%   [To Come]
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%   param - name of MDEV-compatible parameter: 'absg', 'phi', 'c' or 'a'
%
% OUTPUTS:
%
%   none

function mredge_invert_sfwi(info, prefs, freq_indices)
    if nargin == 2
        freq_indices = 1:numel(info.driving_frequencies);
        SPECIAL_FREQ_SET = 0;
    else
        SPECIAL_FREQ_SET = 1;
    end
	[FT_DIRS, SFWI_SUB, HELM_SUB] =set_dirs(info, prefs);
	NIF_EXT = getenv('NIFTI_EXTENSION');
	U = [];
    for f_ind = freq_indices
        f = info.driving_frequencies(f_ind);
        U_f = [];
        for c = 1:3
            for d = 1:numel(FT_DIRS)
                wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
                wavefield_vol = load_untouch_nii_eb(wavefield_path);
                wavefield_img = wavefield_vol.img;
                U_f = cat(4, U_f, wavefield_img);
            end
        end
        U = cat(5, U, U_f);
    end
	%call inversion
	%[g_sfwi, g_helm] = sfwi_inversion(U, info.driving_frequencies(freq_indices), info.voxel_spacing);
    if strcmpi(prefs.gradient_strategy, 'fd')
        g_sfwi = sfwi_inversion(U, info.driving_frequencies(freq_indices), info.voxel_spacing, [1 2 3], 1);
    elseif strcmpi(prefs.gradient_strategy, 'lsq')
        g_sfwi = sfwi_inversion_reg_grad(U, info.driving_frequencies(freq_indices), info.voxel_spacing, [1 2 3], 1);
    end
        % sfwi output - take last loaded volume as placeholder
	sfwi_set = {g_sfwi, SFWI_SUB};
	%helm_set = {g_helm, HELM_SUB};
    sets = {sfwi_set}; %, helm_set};
	for s = 1:numel(sets)
        set = sets{s};
    	param_vol = wavefield_vol;
		param_vol.hdr.dime.datatype = 64;
		param_vol.img = set{1};
        param_vol = update_nifti_dims(param_vol);
		param_dir = set{2};
		if ~exist(param_dir, 'dir')
			mkdir(param_dir);
		end
    	if SPECIAL_FREQ_SET == 0
        	param_path = fullfile(set{2}, ['ALL', NIF_EXT]);
    	else % make file path unique to particular frequency combination
        	filename = '';
        	nfreqs = numel(freq_indices);
		    for n = 1:nfreqs
		        filename = [filename, num2str(info.driving_frequencies(freq_indices(n)))]; %#ok<AGROW>
		        if n < nfreqs
		            filename = [filename, '_']; %#ok<AGROW>
		        end
		    end
        	param_path = fullfile(param_dir, [filename, NIF_EXT]);
    	end
   		save_untouch_nii(param_vol, param_path);
	end

end
    
function [FT_DIRS, SFWI_SUB, HELM_SUB] = set_dirs(info, prefs)
    FT_DIRS = mredge_get_ft_dirs(info, prefs);
    SFWI_SUB = mredge_analysis_path(info, prefs, 'SFWI');
    HELM_SUB = mredge_analysis_path(info, prefs, 'HELM');
end

