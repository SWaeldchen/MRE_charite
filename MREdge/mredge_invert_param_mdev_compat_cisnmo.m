function mredge_invert_param_mdev_compat_cisnmo(info, prefs, param, frequencies, freq_indices)
%% function mredge_invert_param_mdev_compat_cisnmo(info, prefs, param, frequencies, freq_indices)
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

% special_freq_set is for inverting selected combinations of
% frequencies, and individual results are skipped
if nargin < 4
    frequencies = info.driving_frequencies;
    freq_indices = 1:numel(frequencies);
    special_freq_set = 0;
else
    special_freq_set = 1;
end
[FT_DIRS, PARAM_SUB] =set_dirs(info, prefs, param);
NIF_EXT = '.nii.gz';
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
            wavefield_path = fullfile(FT_DIRS{d}, num2str(f), num2str(c), mredge_filename(f, c, NIF_EXT));
            wavefield_vol = load_untouch_nii(wavefield_path);
            wavefield_img = wavefield_vol.img;
            [param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, param_num_comp, param_denom_comp] = get_param(param, param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, wavefield_img, f, info, prefs);
        end
        % outputs for component
        if special_freq_set == 0
            param_comp = wavefield_vol;
            param_comp.img = divide(param, param_num_comp, param_denom_comp);
            param_comp_dir = fullfile(PARAM_SUB, num2str(f), num2str(c));
            if ~exist(param_comp_dir, 'dir')
                mkdir(param_comp_dir);
            end
            param_comp_path = fullfile(param_comp_dir, mredge_filename(f, c, NIF_EXT));
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
        param_freq_path = fullfile(param_freq_dir, [num2str(f), NIF_EXT]);
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

function [param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, param_num_comp, param_denom_comp] =  get_param(param, param_num_mdev, param_denom_mdev, param_num_freq, param_denom_freq, wavefield_img, f, info, prefs)

OMEGA = 2*pi*f;
RHO = 1000;

U = wavefield_img;

pixel_spacing = info.voxel_spacing;

if strcmp(param, 'Abs_G') == 1   
        
    tmpU = U;
    for k_filter = 1:size(U,3)
        tmpU2(:,:,k_filter) = uh_filtspatio2d(tmpU(:,:,k_filter),[pixel_spacing(1); pixel_spacing(2)],100,1,0,5,'bwlow', 0);
    end
    U = tmpU2;
    
    
    [wx, wy]   = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
    [wxx, tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
    [tmp, wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    DU = wxx + wyy;
    
    N = smooth3(U,'gaussian',[3 3 1]) - U;
    [wx, wy]   = gradient(N,pixel_spacing(1),pixel_spacing(2),1);
    [wxx, tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
    [tmp, wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    DN = wxx + wyy;
    
    %param_num_comp = RHO.*OMEGA.^2.*abs(U) - abs(N); % AF: wrong
    %implementation ?
    param_num_comp = RHO.*OMEGA.^2.*(abs(U) - abs(N));
    param_denom_comp = abs(DU) - abs(DN);
    %param_num_comp_mdev = RHO.*OMEGA.^2.*abs(U) - abs(N); % AF: wrong
    %implementation ?
    param_num_comp_mdev = RHO.*OMEGA.^2.*(abs(U) - abs(N));
    param_denom_comp_mdev = abs(DU) - abs(DN);
    
elseif strcmp(param, 'Phi') == 1
    
    [wx, wy]   = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
    [wxx, tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
    [tmp, wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    DU = wxx + wyy;
    
    N = smooth3(U,'gaussian',[3 3 1]) - U;
    [wx, wy]   = gradient(N,pixel_spacing(1),pixel_spacing(2),1);
    [wxx, tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
    [tmp, wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    DN = wxx + wyy;
    
    param_num_comp_noise = real(N).*real(DN) + imag(N).*imag(DN);
    param_denom_comp_noise = abs(N).*abs(DN);
    
    param_num_comp = real(U).*real(DU) + imag(U).*imag(DU);
    param_denom_comp = abs(U).*abs(DU);
    
    param_num_comp = param_num_comp - param_num_comp_noise;
    param_denom_comp = param_denom_comp - param_denom_comp_noise;
    
    param_num_comp_mdev_noise = real(N).*real(DN) + imag(N).*imag(DN);
    param_denom_comp_mdev_noise = abs(N).*abs(DN);
    
    param_num_comp_mdev = real(U).*real(DU) + imag(U).*imag(DU);
    param_denom_comp_mdev = abs(U).*abs(DU);
    
    param_num_comp_mdev = param_num_comp_mdev - param_num_comp_mdev_noise;
    param_denom_comp_mdev = param_denom_comp_mdev - param_denom_comp_mdev_noise;
    
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
