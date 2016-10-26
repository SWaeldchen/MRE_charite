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

function mredge_cortical_median_stable(info, prefs)

    if prefs.outputs.absg == 1
        cortex_stable(info, prefs, 'Abs_G');
    end
    if prefs.outputs.phi == 1
        cortex_stable(info, prefs, 'Phi');
    end
    if prefs.outputs.absg == 1 && prefs.outputs.phi == 1 && prefs.outputs.springpot == 1
        cortex_stable_springpot(info, prefs);
		cortex_stable_springpot_weighted(info, prefs);
    end
    if prefs.outputs.c == 1
        cortex_stable(info, prefs, 'C');
    end
    if prefs.outputs.a == 1
        cortex_stable(info, prefs, 'A');
    end
end

function cortex_stable(info, prefs, param)

	display(['Cortical Medians, Stable Inversions ',param]);

    [PARAM_SUB, STATS_SUB] = set_dirs(info, prefs, param);
    NIFTI_EXTENSION = '.nii.gz';
    mask = double(mredge_load_mask(info,prefs));
    [stable_filenames, stable_frequencies] = mredge_stable_inversions(info, prefs, 1);
    fileID = fopen(fullfile(STATS_SUB, [ 'cortex_stable_',param,'.csv']), 'w');
    fprintf(fileID, 'F, Cortical Median \n');
    fclose(fileID);
    for f = 1:numel(stable_frequencies)
		display([num2str(stable_frequencies(f)), 'Hz']);
        param_path_zip = fullfile(PARAM_SUB, stable_filenames{f});
        param_path_unzip = param_path_zip(1:end-3);
        if exist(param_path_zip, 'file')
            gunzip(param_path_zip);
        end
        param_vol = load_untouch_nii(param_path_unzip);
        param_img = param_vol.img;
        cortex_masked = double(mask).*double(param_img);
        cortex_masked(cortex_masked == 0) = nan;
        param_cortex = median(cortex_masked(~isnan(cortex_masked)));
        fileID = fopen(fullfile(STATS_SUB, [ 'cortex_stable_',param,'.csv']), 'a');
        fprintf(fileID, '%d, %1.4f \n',stable_frequencies(f), param_cortex);
        fclose(fileID);
    end
    fclose('all');

end 
    
function cortex_stable_springpot(info, prefs)

	display(['Cortical Medians, Springpot']);
    MU_FILENAME = 'mu_weighted.nii.gz';
    ALPHA_FILENAME = 'alpha_weighted.nii.gz';
    RSS_FILENAME = 'rss_weighted.nii.gz';
    MU_MIN = 200;

    [SPRINGPOT_SUB, STATS_SUB] = set_dirs_springpot(info, prefs);
    NIFTI_EXTENSION = '.nii.gz';
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
    mu_vol = load_untouch_nii(mu_path_unzip);
    mu_img = mu_vol.img;
    alpha_vol = load_untouch_nii(alpha_path_unzip);
    alpha_img = alpha_vol.img;	
    rss_vol = load_untouch_nii(rss_path_unzip);
    rss_img = rss_vol.img;	    
    mask = double(mredge_load_mask(info,prefs));
	mu_masked = double(mask).*double(mu_img);
	alpha_masked = double(mask).*double(alpha_img);
	rss_masked = double(mask).*double(rss_img);
	mu_masked(mu_masked == 0) = nan;
	alpha_masked(alpha_masked == 0) = nan;
	rss_masked(rss_masked == 0) = nan;
    mu_cortex = median(mu_masked(mu_masked > MU_MIN));
    alpha_cortex = median(alpha_masked(~isnan(alpha_masked)));
    rss_cortex = median(rss_masked(~isnan(rss_masked)));
    mu_ID = fopen(fullfile(STATS_SUB, 'cortex_stable_Mu.csv'), 'w');
    alpha_ID = fopen(fullfile(STATS_SUB, 'cortex_stable_Alpha.csv'), 'w');
    rss_ID = fopen(fullfile(STATS_SUB, 'cortex_stable_RSS.csv'), 'w');
    fprintf(mu_ID, 'Cortical Median \n');
    fprintf(mu_ID, '%1.4f \n', mu_cortex);
    fprintf(alpha_ID, 'Cortical Median \n');
    fprintf(alpha_ID, '%1.4f \n', alpha_cortex);
    fprintf(rss_ID, 'Cortical Median \n');
    fprintf(rss_ID, '%1.4f \n', rss_cortex);    
    fclose('all');

end

   
function cortex_stable_springpot_weighted(info, prefs)

	display(['Cortical Medians, Springpot']);
    MU_FILENAME = 'mu_weighted.nii.gz';
    ALPHA_FILENAME = 'alpha_weighted.nii.gz';
    RSS_FILENAME = 'rss_weighted.nii.gz';
    MU_MIN = 200;

    [SPRINGPOT_SUB, STATS_SUB] = set_dirs_springpot(info, prefs);
    NIFTI_EXTENSION = '.nii.gz';
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
    mu_vol = load_untouch_nii(mu_path_unzip);
    mu_img = mu_vol.img;
    alpha_vol = load_untouch_nii(alpha_path_unzip);
    alpha_img = alpha_vol.img;	
    rss_vol = load_untouch_nii(rss_path_unzip);
    rss_img = rss_vol.img;	    
    mask = double(mredge_load_mask(info,prefs));
	mu_masked = double(mask).*double(mu_img);
	alpha_masked = double(mask).*double(alpha_img);
	rss_masked = double(mask).*double(rss_img);
	mu_masked(mu_masked == 0) = nan;
	alpha_masked(alpha_masked == 0) = nan;
	rss_masked(rss_masked == 0) = nan;
    mu_cortex = median(mu_masked(mu_masked > MU_MIN));
    alpha_cortex = median(alpha_masked(~isnan(alpha_masked)));
    rss_cortex = median(rss_masked(~isnan(rss_masked)));
    mu_ID = fopen(fullfile(STATS_SUB, 'cortex_stable_Mu.csv'), 'w');
    alpha_ID = fopen(fullfile(STATS_SUB, 'cortex_stable_Alpha.csv'), 'w');
    rss_ID = fopen(fullfile(STATS_SUB, 'cortex_stable_RSS.csv'), 'w');
    fprintf(mu_ID, 'Cortical Median \n');
    fprintf(mu_ID, '%1.4f \n', mu_cortex);
    fprintf(alpha_ID, 'Cortical Median \n');
    fprintf(alpha_ID, '%1.4f \n', alpha_cortex);
    fprintf(rss_ID, 'Cortical Median \n');
    fprintf(rss_ID, '%1.4f \n', rss_cortex);    
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
