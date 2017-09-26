%% function mredge_invert_param_all(info, prefs, param, freq_indices);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   create an elastogram of param using the all approach
%
%   If you use this method cite
%
%   Braun, Jürgen, Jing Guo, Ralf Lützkendorf, Jörg Stadler, Sebastian
%   Papazoglou, Sebastian Hirsch, Ingolf Sack, and Johannes Bernarding. 
%   "High-resolution mechanical imaging of the human brain by 
%   three-dimensional multifrequency magnetic resonance elastography at 
%   7T." Neuroimage 90 (2014): 308-314.
%
%   and preferably also
%
%   Papazoglou, Sebastian, Sebastian Hirsch, Jürgen Braun, and Ingolf 
%   Sack. "Multifrequency inversion in magnetic resonance elastography." 
%   Physics in medicine and biology 57, no. 8 (2012): 2329.
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%   param - name of all-compatible parameter: 'absg', 'phi', 'c' or 'a'
%
% OUTPUTS:
%
%   none

function mredge_invert_param_mdev(info, prefs, param, freq_indices)
	frequencies = info.driving_frequencies;
    if nargin < 4
        freq_indices = 1:numel(frequencies);
        special_freq_set = 0;
    else
        special_freq_set = 1;
    end
	[FT_DIRS, PARAM_SUB] =set_dirs(info, prefs, param);
	NIF_EXT = getenv('NIFTI_EXTENSION');
    if numel(unique(info.voxel_spacing)) == 1
        ndims = 4;
        iso = 1;
    else
        ndims = 2;
        iso = 0;
    end
    all_u = [];
    for f_ind = freq_indices
        f = info.driving_frequencies(f_ind);
        freq_u = [];
        for c = 1:3
            for d = 1:numel(FT_DIRS)
                wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
                wavefield_vol = load_untouch_nii_eb(wavefield_path);
                wavefield_img = wavefield_vol.img;
                freq_u = cat(4, freq_u, wavefield_img);
            end
            % outputs for component
            if special_freq_set == 0
                absg = helmholtz_inversion(wavefield_img, f, info.voxel_spacing, prefs.inversion_settings.mdev_laplacian_dims, ndims, iso);
                param_comp = wavefield_vol;
                param_comp.img = absg;
                param_comp_dir = fullfile(PARAM_SUB, num2str(f), num2str(c));
                if ~exist(param_comp_dir, 'dir')
                    mkdir(param_comp_dir);
                end
                param_comp_path = fullfile(param_comp_dir, mredge_filename(f, c, NIF_EXT));
                save_untouch_nii(param_comp, param_comp_path);
            end
        end
        all_u = cat(5, all_u, freq_u);
        % outputs for frequency
        if special_freq_set == 0
            absg = helmholtz_inversion(freq_u, f, info.voxel_spacing, prefs.inversion_settings.mdev_laplacian_dims, 4, iso);
            param_freq = wavefield_vol;
            param_freq.img = absg;
            param_freq.hdr.dime.datatype = 64;
            param_freq_dir = fullfile(PARAM_SUB, num2str(f));
            if ~exist(param_freq_dir, 'dir')
               disp('MREdge ERROR: Frequency folder not found');
               return
            end
            param_freq_path = fullfile(param_freq_dir, [num2str(f), NIF_EXT]);
            save_untouch_nii(param_freq, param_freq_path);
        end
    end
    % all output
    if prefs.inversion_settings.bootstrap
        [x0, x1] = bootstrap_helmholtz(double(all_u), info.driving_frequencies, info.voxel_spacing);
        mean_freq = mean(info.driving_frequencies);
        absg = x0 + x1*mean_freq;
    else
        absg = helmholtz_inversion(all_u, info.driving_frequencies, info.voxel_spacing, ...
            prefs.inversion_settings.mdev_laplacian_dims, 4, iso);
    end
    param_all = wavefield_vol;
    param_all.img = absg;
    param_all.hdr.dime.datatype = 64;
    param_all_dir = fullfile(PARAM_SUB);
    if ~exist(param_all_dir, 'dir')
       disp('MREdge ERROR: Param folder not found');
       return
    end
    if special_freq_set == 0
        param_all_path = fullfile(param_all_dir, ['ALL', NIF_EXT]);
    else % make file path unique to particular frequency combination
        filename = '';
        curr_freqs = frequencies(freq_indices);
        nfreqs = numel(curr_freqs);
        for n = 1:nfreqs
            filename = [filename, num2str(curr_freqs(n))]; %#ok<AGROW>
            if n < nfreqs
                filename = [filename, '_']; %#ok<AGROW>
            end
        end
        param_all_path = fullfile(param_all_dir, [filename, NIF_EXT]);
    end
   save_untouch_nii(param_all, param_all_path);

end

function [FT_DIRS, PARAM_SUB] = set_dirs(info, prefs, param)
    FT_DIRS = mredge_get_ft_dirs(info, prefs);
    PARAM_SUB = mredge_analysis_path(info, prefs, param);
end
