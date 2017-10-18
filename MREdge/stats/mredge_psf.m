%% function mredge_psf(info);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% Estimates point spread function of magnitude images for quality control
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
%
% OUTPUTS:
%
% none
%	
function mredge_psf(info, prefs)
    tic
    [AVG_SUB, MAG_SUB, STATS_SUB] = set_dirs(info, prefs);
    stats_filepath = fullfile(STATS_SUB,'psf.csv');
    fileID = fopen(stats_filepath, 'w');
    fprintf(fileID, 'F.C.D, PSF \n');
    fclose(fileID);
    if ~exist(AVG_SUB, 'dir')
        mkdir(AVG_SUB);
    end
    
    for f = info.driving_frequencies
      FWHM_f = zeros(3,3);
        for c = 1:3
            mag_path = fullfile(MAG_SUB, num2str(f), num2str(c), mredge_filename(f, c, '.nii.gz'));
            mag_time_series_vol = load_untouch_nii_eb(mag_path);
            mag_time_series_img = mag_time_series_vol.img;
            mag_avg = mean(mag_time_series_img, 4);
            
            % get placeholder volume
            first_path = fullfile(MAG_SUB, num2str(f), num2str(c), 'first.nii.gz');
            fslroi_command = ['fsl5.0-fslroi ', mag_path, ' ', first_path, ' ', ' 0 1'];
            system(fslroi_command);
            mag_avg_vol = load_untouch_nii_eb(first_path);
            delete(first_path);
            
            % fill with avg
            mag_avg_vol.img = mag_avg;
            mag_avg_path = fullfile(MAG_SUB, num2str(f), num2str(c), mredge_filename(f, c, '.nii.gz', 'avg'));
            save_untouch_nii(mag_avg_vol, mag_avg_path);
            
            %mask image required
            mag_mask_vol = mag_avg_vol;
            mag_mask_vol.img = mredge_load_mask(info,prefs);
            mag_mask_path = fullfile(MAG_SUB, num2str(f), num2str(c), mredge_filename(f, c, '.nii.gz', 'mask'));
            save_untouch_nii(mag_mask_vol, mag_mask_path);
            
            output_path = fullfile(MAG_SUB, num2str(f), num2str(c), 'fsl_psf.txt');
            
            psf_command = ['fsl5.0-smoothest -d 1 -r ', mag_path, ' -m ', mag_mask_path, ' -V &> ', output_path];
            system(psf_command);
            mag_path_unzip = mag_path(1:end-3);
            mag_mask_path_unzip = mag_mask_path(1:end-3);
            gunzip(mag_path);
            gunzip(mag_mask_path);
            [~, spm_resids_header] = mredge_load_with_spm(mag_path_unzip);
            [~, spm_mask_header] = mredge_load_with_spm(mag_mask_path_unzip);
            FWHM(:,c) = spm_est_smoothness(spm_resids_header, spm_mask_header);
        end
        fileID = fopen(stats_filepath, 'a');
        fprintf(fileID, '%d, %1.4f \n', f, norm(FWHM(:)));
        fclose(fileID);
        delete(mag_path_unzip);
        delete(mag_mask_path_unzip);
    end
    fclose('all');
    toc
end

function [AVG_SUB, MAG_SUB, STATS_SUB] = set_dirs(info, prefs)

    MAG_SUB = fullfile(info.path, 'Magnitude');
    AVG_SUB = mredge_analysis_path(info, prefs, 'Magnitude');
    STATS_SUB = mredge_analysis_path(info, prefs, 'stats');
            
end
