%% function mredge_invert(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   create an elastogram of param using the MDEV approach
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
%   param - name of MDEV-compatible parameter: 'absg', 'phi', 'c' or 'a'
%
% OUTPUTS:
%
%   none

function mredge_invert_param_mdev(info, prefs, param, freq_indices)
	frequencies = info.driving_frequencies;
    if isempty(freq_indices)
        freq_indices = 1:numel(frequencies);
        special_freq_set = 0;
    else
        special_freq_set = 1;
    end
	[FT_DIRS, PARAM_SUB] =set_dirs(info, prefs, param);
	NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    param_num_mdev = [];
    param_denom_mdev = [];
    for f_ind = freq_indices
        f = info.driving_frequencies(f_ind);
        param_num_freq = [];
        param_denom_freq = [];
        for c = 1:3
            param_num_comp = [];
            param_denom_comp = [];
            for d = 1:numel(FT_DIRS);
                wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIFTI_EXTENSION));
                wavefield_vol = load_untouch_nii(wavefield_path);
                wavefield_img = wavefield_vol.img;
                [param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, param_num_comp, param_denom_comp] = get_param(param, param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, wavefield_img, f, info);
            end
            % outputs for component
            if special_freq_set == 0
                param_comp = wavefield_vol;
                param_comp.img = divide(param, param_num_comp, param_denom_comp);
                param_comp_dir = fullfile(PARAM_SUB, num2str(f), num2str(c));
                if ~exist(param_comp_dir, 'dir')
                    mkdir(param_comp_dir);
                end
                param_comp_path = fullfile(param_comp_dir, mredge_filename(f, c, NIFTI_EXTENSION));
                save_untouch_nii(param_comp, param_comp_path);
            end
        end
        % outputs for frequency
        if special_freq_set == 0
            param_freq = wavefield_vol;
            param_freq.img = divide(param, param_num_freq, param_denom_freq);
            param_freq.hdr.dime.datatype = 64;
            param_freq_dir = fullfile(PARAM_SUB, num2str(f));
            if ~exist(param_freq_dir, 'dir')
               display('MREdge ERROR: Frequency folder not found');
               return
            end
            param_freq_path = fullfile(param_freq_dir, [num2str(f), NIFTI_EXTENSION]);
            save_untouch_nii(param_freq, param_freq_path);
        end
    end
    % mdev output
    param_mdev = wavefield_vol;
    param_mdev.img = divide(param, param_num_mdev, param_denom_mdev);
    param_mdev.hdr.dime.datatype = 64;
    param_mdev_dir = fullfile(PARAM_SUB);
    if ~exist(param_mdev_dir, 'dir')
       display('MREdge ERROR: Param folder not found');
       return
    end
    if special_freq_set == 0
        param_mdev_path = fullfile(param_mdev_dir, 'MDEV.nii.gz');
    else % make file path unique to particular frequency combination
        filename = '';
        nfreqs = numel(frequencies);
        for n = 1:nfreqs
            filename = [filename, num2str(frequencies(n))]; %#ok<AGROW>
            if n < nfreqs
                filename = [filename, '_']; %#ok<AGROW>
            end
        end
        param_mdev_path = fullfile(param_mdev_dir, [filename, '.nii.gz']);
    end
   save_untouch_nii(param_mdev, param_mdev_path);

end

function [param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, param_num_comp, param_denom_comp] =  get_param(param, param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, wavefield_img, f, info)
    
    OMEGA = 2*pi*f;
    RHO = 1050;
    
    if strcmp(param, 'Abs_G') == 1
        laplacian_img_2d = mredge_compact_laplacian(wavefield_img, info.voxel_spacing, 2);
        laplacian_img_3d = mredge_compact_laplacian(wavefield_img, info.voxel_spacing, 3);
        param_num_comp = RHO.*OMEGA.^2.*abs(wavefield_img);
        param_denom_comp = abs(laplacian_img_3d);
        param_num_comp_mdev = RHO.*OMEGA.^2.*abs(wavefield_img);
        param_denom_comp_mdev = abs(laplacian_img_3d);
        %param_denom_comp_mdev = abs(laplacian_img_2d);
    elseif strcmp(param, 'Phi') == 1
        laplacian_img_2d = mredge_compact_laplacian(wavefield_img, info.voxel_spacing, 2);
        laplacian_img_3d = mredge_compact_laplacian(wavefield_img, info.voxel_spacing, 3);
        param_num_comp = real(wavefield_img).*real(laplacian_img_3d) + imag(wavefield_img).*imag(laplacian_img_3d);
        param_denom_comp = abs(wavefield_img).*abs(laplacian_img_3d);
        param_num_comp_mdev = real(wavefield_img).*real(laplacian_img_3d) + imag(wavefield_img).*imag(laplacian_img_3d);
        param_denom_comp_mdev = abs(wavefield_img).*abs(laplacian_img_3d);
        %param_num_comp = real(wavefield_img).*real(laplacian_img_2d) + imag(wavefield_img).*imag(laplacian_img_2d);
        %param_denom_comp = abs(wavefield_img).*abs(laplacian_img_2d);
        %param_num_comp_mdev = real(wavefield_img).*real(laplacian_img_2d) + imag(wavefield_img).*imag(laplacian_img_2d);
        %param_denom_comp_mdev = abs(wavefield_img).*abs(laplacian_img_2d);
    else
        display('MREdge ERROR: Inversion parameter not yet implemented.');
    end
    
    if isempty(param_num_mdev)
        param_num_mdev = param_num_comp_mdev;
        param_denom_mdev = param_denom_comp_mdev;
    else 
        param_num_mdev = param_num_mdev + param_num_comp_mdev;
        param_denom_mdev = param_denom_mdev + param_denom_comp_mdev;
    end
    if isempty(param_num_freq)
        param_num_freq = param_num_comp;
        param_denom_freq = param_denom_comp;
    else
        param_num_freq = param_num_freq + param_num_comp;
        param_denom_freq = param_denom_freq + param_denom_comp;
    end

end
    
function [FT_DIRS, PARAM_SUB] = set_dirs(info, prefs, param)
    FT_DIRS = mredge_get_ft_dirs(info, prefs);
    PARAM_SUB = mredge_analysis_path(info, prefs, param);
end

function res = divide(param, num, denom)
    if strcmp(param, 'Abs_G') == 1
        res = num ./ denom;
    elseif strcmp(param, 'Phi') == 1
        res = acos(-num./denom);
    else
        display('MREdge ERROR: Parameter ', param,' not implemented.');
    end
end
