%% function mredge_springpot_stable_weighted(info, prefs);
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

function mredge_springpot_stable_weighted(info, prefs)

	tic
	display('Calculating Springpot Fit (Least-Squares Method, Stable Inversions, Amplitude Weighted)');
	[ABSG_SUB, PHI_SUB, SPRINGPOT_SUB, AMP_SUB] = set_dirs(info, prefs);
    if ~exist(SPRINGPOT_SUB, 'dir')
        mkdir(SPRINGPOT_SUB);
    end
	NIFTI_EXTENSION = '.nii.gz';
    BRAIN_ETA = 3.7;

    [stable_filenames, stable_frequencies] = mredge_stable_inversions(info, prefs, 1);
    df = stable_frequencies;
    nf = numel(df);
    wvec = 2*pi*df;
    absg_images = cell(numel(df), 1);
    phi_images = cell(numel(df), 1);
	amp_images = cell(numel(df), 1);
    for f_num = 1:nf
        absg_path = fullfile(ABSG_SUB, stable_filenames{f_num});
        absg_vol = load_untouch_nii(absg_path);
        absg_images{f_num} = absg_vol.img; 
    end
    for f_num = 1:nf
        phi_path = fullfile(PHI_SUB, stable_filenames{f_num});
        phi_vol = load_untouch_nii(phi_path);
        phi_images{f_num} = phi_vol.img; 
    end
    for f_num = 1:nf
        amp_path = fullfile(AMP_SUB, stable_filenames{f_num});
        amp_vol = load_untouch_nii(amp_path);
        amp_images{f_num} = amp_vol.img; 
    end
    sz = size(absg_images{1});
    image_block = zeros(sz(1), sz(2), sz(3), nf);
	weights_block = zeros(sz(1), sz(2), sz(3), nf);
    for n = 1:nf
        absg_image = absg_images{n};
        phi_image = phi_images{n};
        % MEDIAN FILTER
        %absg_image = medfilt3(absg_image, [5 5 5]);
        %phi_image = medfilt3(phi_image, [5 5 5]);
        image_block(:,:,:,n) = absg_image.*cos(phi_image) + 1i*absg_image.*sin(phi_image); % REAL IMAG
		weights_block(:,:,:,n) = amp_images{n};
    end
    image_block = reshape(image_block, sz(1)*sz(2)*sz(3), nf);
    weights_block = reshape(weights_block, sz(1)*sz(2)*sz(3), nf);
    sz_vec = size(image_block);
    mu = zeros(sz_vec(1),1);
    alpha = zeros(sz_vec(1),1);
    rss = zeros(sz_vec(1),1);
    mask = mredge_load_mask(info,prefs);
    mask = mask(:);
    
    parfor i = 1:sz_vec(1)
        if mask(i) == 1
            Gvec = permute(squeeze(image_block(i,:)), [2 1]);
			weights_vec = permute(squeeze(weights_block(i,:)), [2 1]);
			% normalize weights
			weights_vec = ( weights_vec - min(weights_vec) ) ./ ( max(weights_vec) - min(weights_vec) );
            [mu_vox, alpha_vox, rss_vox] = bruteforce_springpot_fit_weighted(wvec, Gvec, weights_vec, BRAIN_ETA);
            mu(i) = mu_vox;
            alpha(i) = alpha_vox;
            rss(i) = rss_vox;
        end
    end
    
    mu_vol = absg_vol;
    mu_vol.img = reshape(mu, sz(1), sz(2), sz(3));
    save_untouch_nii(mu_vol, fullfile(SPRINGPOT_SUB, 'mu_weighted.nii.gz'));
    
    alpha_vol = absg_vol;
    alpha_vol.img = reshape(alpha, sz(1), sz(2), sz(3));
    save_untouch_nii(alpha_vol, fullfile(SPRINGPOT_SUB, 'alpha_weighted.nii.gz'));
    
    rss_vol = absg_vol;
    rss_vol.img = reshape(rss, sz(1), sz(2), sz(3));
    save_untouch_nii(rss_vol, fullfile(SPRINGPOT_SUB, 'rss_weighted.nii.gz'));
    toc           
end

function [ABSG_SUB, PHI_SUB, SPRINGPOT_SUB, AMP_SUB] = set_dirs(info, prefs)
	ABSG_SUB = mredge_analysis_path(info, prefs, 'Abs_G');
	PHI_SUB = mredge_analysis_path(info, prefs, 'Phi');
	SPRINGPOT_SUB = mredge_analysis_path(info, prefs, 'Springpot');
	AMP_SUB = mredge_analysis_path(info, prefs, 'Amp');
end
