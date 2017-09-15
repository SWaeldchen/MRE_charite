%% function mredge_springpot_stable(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   voxel-wise springpot fit, stabilizing each inversion by combining 3
%   frequencies
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_springpot_stable(info, prefs)

	tic
	display('Calculating Springpot Fit (Least-Squares Method, Stable Inversions)');
	[ABSG_SUB, PHI_SUB, SPRINGPOT_SUB] = set_dirs(info, prefs);
    if ~exist(SPRINGPOT_SUB, 'dir')
        mkdir(SPRINGPOT_SUB);
    end
	NIF_EXT = '.nii.gz';
    BRAIN_ETA = 10;

    [stable_filenames, stable_frequencies] = mredge_stable_inversions(info, prefs, 1);
    df = stable_frequencies;
    nf = numel(df);
    wvec = 2*pi*df;
    absg_images = cell(numel(df), 1);
    phi_images = cell(numel(df), 1);
    for f_num = 1:nf
        absg_path = fullfile(ABSG_SUB, stable_filenames{f_num});
        absg_vol = load_untouch_nii_eb(absg_path);
        absg_images{f_num} = absg_vol.img; 
    end
    for f_num = 1:nf
        phi_path = fullfile(PHI_SUB, stable_filenames{f_num});
        phi_vol = load_untouch_nii_eb(phi_path);
        phi_images{f_num} = phi_vol.img; 
    end
    sz = size(absg_images{1});
    image_block = zeros(sz(1), sz(2), sz(3), nf);
    for n = 1:nf
        absg_image = absg_images{n};
        phi_image = phi_images{n};
        % MEDIAN FILTER
        absg_image = medfilt3(absg_image, [5 5 5]);
        phi_image = medfilt3(phi_image, [5 5 5]);
        image_block(:,:,:,n) = absg_image.*cos(phi_image) + 1i*absg_image.*sin(phi_image); % REAL IMAG
    end
    image_block = reshape(image_block, sz(1)*sz(2)*sz(3), nf);
    sz_vec = size(image_block);
    mu = zeros(sz_vec(1),1);
    alpha = zeros(sz_vec(1),1);
    rss = zeros(sz_vec(1),1);
    mask = mredge_load_mask(info,prefs);
    mask = mask(:);
    
    parfor i = 1:sz_vec(1)
        if mask(i) == 1
            Gvec = permute(squeeze(image_block(i,:)), [2 1]);
            [mu_vox, alpha_vox, rss_vox] = bruteforce_springpot_fit(wvec, Gvec, BRAIN_ETA);
            mu(i) = mu_vox;
            alpha(i) = alpha_vox;
            rss(i) = rss_vox;
        end
    end
    
    mu_vol = absg_vol;
    mu_vol.img = reshape(mu, sz(1), sz(2), sz(3));
    save_untouch_nii(mu_vol, fullfile(SPRINGPOT_SUB, 'mu_stable.nii.gz'));
    
    alpha_vol = absg_vol;
    alpha_vol.img = reshape(alpha, sz(1), sz(2), sz(3));
    save_untouch_nii(alpha_vol, fullfile(SPRINGPOT_SUB, 'alpha_stable.nii.gz'));
    
    rss_vol = absg_vol;
    rss_vol.img = reshape(rss, sz(1), sz(2), sz(3));
    save_untouch_nii(rss_vol, fullfile(SPRINGPOT_SUB, 'rss_stable.nii.gz'));
    toc           
end

function [ABSG_SUB, PHI_SUB, SPRINGPOT_SUB] = set_dirs(info, prefs)
	ABSG_SUB = mredge_analysis_path(info, prefs, 'Abs_G');
	PHI_SUB = mredge_analysis_path(info, prefs, 'Phi');
	SPRINGPOT_SUB = mredge_analysis_path(info, prefs, 'Springpot');
end