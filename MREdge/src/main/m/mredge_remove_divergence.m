function mredge_remove_divergence(info, prefs)
% Numerical divergence removal of the wave field
%
% USAGE:
%
%   Helmholtz-Hodge decomposition of the vector fields, retaining curl
%   component
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none
%
% NOTE:
%
%   High-pass filtering is currently recommended instead of this method.
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
tic
disp('Divergence Removal');
[FT_DIR, RESID_DIR] = set_dirs(info, prefs);
NIF_EXT = getenv('NIFTI_EXTENSION');
if ~exist(RESID_DIR, 'dir')
    mkdir(RESID_DIR);
end
for f = info.driving_frequencies
    % make use of component order in prefs
    order_vec = get_order_vec(prefs);
    wavefield_vol = cell(3,1);
    components = cell(3,1);
    for c = 1:3
        wavefield_path = fullfile(FT_DIR, num2str(f), num2str(order_vec(c)), mredge_filename(f, order_vec(c), NIF_EXT));
        wavefield_vol{c} = load_untouch_nii_eb(wavefield_path);
        components{order_vec(c)} = wavefield_vol{c}.img;
    end
    resid_vol = wavefield_vol;
    if strcmp(prefs.curl_strategy, 'lsqr') == 1
        components = mredge_hhd_lsqr(components, prefs);
    elseif strcmp(prefs.curl_strategy, 'fd') == 1
        [components{1}, components{2}, components{3}] = curl(components{1}, components{2}, components{3});
    elseif strcmp(prefs.curl_strategy, 'hipass') == 1
        for n = 1:3
            components{n} = butter_2d(prefs.highpass_settings.order, prefs.highpass_settings.cutoff, components{n}, 1);
        end
    end
    for c = 1:3
        wavefield_path = fullfile(FT_DIR, num2str(f), num2str(order_vec(c)), mredge_filename(f, order_vec(c), NIF_EXT));
        wavefield_vol{c}.img = components{order_vec(c)};
        save_untouch_nii(wavefield_vol{c}, wavefield_path);
        resid_dir = fullfile(RESID_DIR, num2str(f), num2str(c));
        if ~exist(resid_dir, 'dir')
            mkdir(resid_dir);
        end
        resid_path = fullfile(resid_dir, mredge_filename(f, c, NIF_EXT));
        resid_vol{c}.img = resid_vol{c}.img - wavefield_vol{c}.img;
        save_untouch_nii(resid_vol{c}, resid_path);
    end
end
toc   

end

function [FT_DIR, RESID_DIR] = set_dirs(info, prefs)
    FT_DIR = mredge_analysis_path(info,prefs,'FT');
    RESID_DIR = mredge_analysis_path(info,prefs,'CURL_RESID');
end

function order_vec = get_order_vec(prefs)
    order_vec = zeros(3,1);
    if strcmp(prefs.component_order(1), 'x') == 1
        order_vec(1) = 1;
    elseif strcmp(prefs(1), 'y') == 1
        order_vec(1) = 2;
    else
        order_vec(1) = 3;
    end
    if strcmp(prefs.component_order(2), 'x') == 1
        order_vec(2) = 1;
    elseif strcmp(prefs.component_order(2), 'y') == 1
        order_vec(2) = 2;
    else
        order_vec(2) = 3;
    end
    if strcmp(prefs.component_order(3), 'x') == 1
        order_vec(3) = 1;
    elseif strcmp(prefs.component_order(3), 'y') == 1
        order_vec(3) = 2;
    else
        order_vec(3) = 3;
    end
end


