%% function mredge_cortical_median(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Using the previously set T2 mask, calculates cortical values for a
%   parameter
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none

function mredge_masked_median(info, prefs)

    if strcmp(prefs.inversion_strategy, 'MDEV') == 1
        if prefs.outputs.absg == 1
            masked(info, prefs, 'Abs_G');
        end
        if prefs.outputs.phi == 1
            masked(info, prefs, 'Phi');
        end
        if prefs.outputs.absg == 1 && prefs.outputs.phi == 1 && prefs.outputs.springpot == 1
            masked_springpot(info, prefs);
        end
        if prefs.outputs.c == 1
            masked(info, prefs, 'C');
        end
        if prefs.outputs.a == 1
            masked(info, prefs, 'A');
        end
        if prefs.outputs.amplitude == 1
            masked(info, prefs, 'Amp');
        end
    elseif strcmp(prefs.inversion_strategy, 'SFWI') == 1
        masked(info, prefs, 'SFWI');
        %masked(info, prefs, 'HELM');
    end
end

function masked(info, prefs, param)

	display(['Masked Median: ',param]);

    [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param);
    NIFTI_EXTENSION = getenv('NIFTI_EXTENSION');
    param_path = fullfile(PARAM_SUB, ['ALL', NIFTI_EXTENSION]);
    param_path = mredge_unzip_if_zip(param_path);
    param_vol = load_untouch_nii_eb(param_path);
    param_img = param_vol.img;
	mask = double(mredge_load_mask(info,prefs));
	masked = double(mask).*double(param_img);
	masked(masked == 0) = nan;
    param_masked = median(masked(~isnan(masked)));
    fileID = fopen(fullfile(STATS_SUB, [ 'masked_',param,'.csv']), 'w');
    fprintf(fileID, 'F, Masked Median \n');
    fprintf(fileID, 'ALL, %1.4f \n', param_masked);
	save(fullfile(PARAM_SUB, 'ALL_masked_image.mat'), 'masked');
    for f = info.driving_frequencies
		disp([num2str(f), 'Hz']);
        param_path = mredge_unzip_if_zip(fullfile(PARAM_SUB, num2str(f), [num2str(f), NIFTI_EXTENSION]));
        if exist(param_path, 'file')
            param_vol = load_untouch_nii_eb(param_path);
            param_img = param_vol.img;
            masked = double(mask).*double(param_img);
            masked(masked == 0) = nan;
            param_masked = median(masked(~isnan(masked)));
            fileID = fopen(fullfile(STATS_SUB, [ 'masked_',param,'.csv']), 'a');
            fprintf(fileID, '%d, %1.4f\n', f, param_masked);
        end
    end
    fclose('all');
    masked_stable(info, prefs, param);
end 

function masked_stable(info, prefs, param)

	display(['Masked Medians, Stable Inversions ',param]);
    [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param);
    mask = double(mredge_load_mask(info,prefs));
    [stable_filenames, stable_frequencies] = mredge_stable_inversions(info, prefs, 0);
    fileID = fopen(fullfile(STATS_SUB, [ 'masked_stable_',param,'.csv']), 'w');
    fprintf(fileID, 'F, Masked Median \n');
    fclose(fileID);
    for f = 1:numel(stable_frequencies)
		disp([num2str(stable_frequencies(f)), 'Hz']);
        param_path = mredge_unzip_if_zip(fullfile(PARAM_SUB, stable_filenames{f}));
        if exist(param_path, 'file')
            param_vol = load_untouch_nii_eb(param_path);
            param_img = param_vol.img;
            masked = double(mask).*double(param_img);
            masked(masked == 0) = nan;
            param_masked = median(masked(~isnan(masked)));
            fileID = fopen(fullfile(STATS_SUB, [ 'masked_stable_',param,'.csv']), 'a');
            fprintf(fileID, '%d, %1.4f \n',stable_frequencies(f), param_masked);
            fclose(fileID);
        end
    end
    fclose('all');

end 

function [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param)

    PARAM_SUB = mredge_analysis_path(info, prefs, param);
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
end

function [SPRINGPOT_SUB, STATS_SUB] = set_dirs_springpot(info, prefs)

    SPRINGPOT_SUB = mredge_analysis_path(info, prefs, 'Springpot');
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
end


function masked_springpot(info, prefs)

	disp('Cortical Medians, Springpot');
    MU_FILENAME = 'mu.nii.gz';
    ALPHA_FILENAME = 'alpha.nii.gz';
    RSS_FILENAME = 'rss.nii.gz';
    MU_MIN = 200;

    [SPRINGPOT_SUB, STATS_SUB] = set_dirs_springpot(info, prefs);
    mu_path_zip = fullfile(SPRINGPOT_SUB, MU_FILENAME);
    alpha_path_zip = fullfile(SPRINGPOT_SUB, ALPHA_FILENAME);
    rss_path_zip = fullfile(SPRINGPOT_SUB, RSS_FILENAME);
    mu_path_unzip = mu_path_zip(1:end-3);
    alpha_path_unzip = alpha_path_zip(1:end-3);
    rss_path_unzip = rss_path_zip(1:end-3);
    if exist(mu_path_zip, 'file')
        gunzip(mu_path_zip);
    end
    if exist(alpha_path_zip, 'file')
        gunzip(alpha_path_zip);
    end
    if exist(rss_path_zip, 'file')
        gunzip(rss_path_zip);
    end
    mu_vol = load_untouch_nii_eb(mu_path_unzip);
    mu_img = mu_vol.img;
    alpha_vol = load_untouch_nii_eb(alpha_path_unzip);
    alpha_img = alpha_vol.img;	
    rss_vol = load_untouch_nii_eb(rss_path_unzip);
    rss_img = rss_vol.img;	    
    mask = double(mredge_load_mask(info,prefs));
	mu_masked = double(mask).*double(mu_img);
	alpha_masked = double(mask).*double(alpha_img);
	rss_masked = double(mask).*double(rss_img);
	mu_masked(mu_masked == 0) = nan;
	alpha_masked(alpha_masked == 0) = nan;
	rss_masked(rss_masked == 0) = nan;
    mu_masked = median(mu_masked(mu_masked > MU_MIN));
    alpha_masked = median(alpha_masked(~isnan(alpha_masked)));
    rss_masked = median(rss_masked(~isnan(rss_masked)));
    mu_ID = fopen(fullfile(STATS_SUB, 'masked_Mu.csv'), 'w');
    alpha_ID = fopen(fullfile(STATS_SUB, 'masked_Alpha.csv'), 'w');
    rss_ID = fopen(fullfile(STATS_SUB, 'masked_RSS.csv'), 'w');
    fprintf(mu_ID, 'Cortical Median \n');
    fprintf(mu_ID, '%1.4f \n', mu_masked);
    fprintf(alpha_ID, 'Cortical Median \n');
    fprintf(alpha_ID, '%1.4f \n', alpha_masked);
    fprintf(rss_ID, 'Cortical Median \n');
    fprintf(rss_ID, '%1.4f \n', rss_masked);    
    fclose('all');
    masked_stable(info, prefs, param);
end 