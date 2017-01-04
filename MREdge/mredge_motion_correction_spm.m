%% function mredge_motion_correction(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
% This function will perform motion correction on an acquisition.
% Requires SPM 12.
%
% INPUTS:
%
% info - an acquisition info structure created with make_acquisition_info
% prefs - a preference file structure created with mredge_prefs
%
% OUTPUTS:
%
% none
%	
function mredge_motion_correction_spm(info, prefs)
    tic
    display('MREdge Motion Correction with SPM');
    cd(info.path);
    [MAG_SUB, REAL_SUB, IMAG_SUB, STATS_SUB] = set_dirs(info, prefs);
    
    NIFTI_EXTENSION = '.nii.gz';
	time_steps = info.time_steps;
	total_acqs = numel(info.driving_frequencies)*time_steps*3;
    full_unzipped_file_list_mag = cell(total_acqs, 1);
    full_unzipped_file_list_real = cell(total_acqs, 1);
    full_unzipped_file_list_imag = cell(total_acqs, 1);

    for f_num = 1:numel(info.driving_frequencies)
        f = info.driving_frequencies(f_num);
        for c = 1:3
			index = (time_steps*3)*(f_num-1) + time_steps*(c-1) + 1;
			index_end = index + time_steps - 1;
            mredge_pm2ri(info, f, c);

            file_list_mag = mredge_split_4d(MAG_SUB, f, c, info);
            file_list_mag_unzipped = mredge_unzip_file_list(file_list_mag);
			full_unzipped_file_list_mag(index:index_end) = file_list_mag_unzipped;

            file_list_real = mredge_split_4d(REAL_SUB, f, c, info);
            file_list_real_unzipped = mredge_unzip_file_list(file_list_real);
			full_unzipped_file_list_real(index:index_end) = file_list_real_unzipped;

            file_list_imag = mredge_split_4d(IMAG_SUB, f, c, info);
            file_list_imag_unzipped = mredge_unzip_file_list(file_list_imag);
            full_unzipped_file_list_imag(index:index_end) = file_list_imag_unzipped;
            
        end
    end
            
    % estimate motion, leaving trans matrix in magnitude headers
    spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.realign.estimate.data = {full_unzipped_file_list_mag};
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 0;   % Register to first
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 2;
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [1 0 0];
    matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';

    spm_jobman('run',matlabbatch);
    
    % load mag images to get their headers
    % load real, imag files to get their voxels
    % save real and imag images, with mag headers

    for index = 1: numel(full_unzipped_file_list_mag)        
        [~, mag_header] = mredge_load_with_spm(full_unzipped_file_list_mag{index});
        [real_image, ~] = mredge_load_with_spm(full_unzipped_file_list_real{index});
        [imag_image, ~] = mredge_load_with_spm(full_unzipped_file_list_imag{index});
        real_header = mag_header;
        real_header.fname = full_unzipped_file_list_real{index};
        imag_header = mag_header;
        imag_header.fname = full_unzipped_file_list_imag{index};
        spm_write_vol(real_header, real_image);
        spm_write_vol(imag_header, imag_image);
    end


    % call reslice on real and imaginary images
    prefix = 'r_';
    display('Real');
    call_spm_reslice(full_unzipped_file_list_real, prefix);
    display('Imaginary');
    call_spm_reslice(full_unzipped_file_list_imag, prefix);
    
    replace_files(full_unzipped_file_list_real, prefix, time_steps);
    replace_files(full_unzipped_file_list_imag, prefix, time_steps);
  
   %re-merge and zip
   for f_num = 1:numel(info.driving_frequencies)
        f = info.driving_frequencies(f_num);
        for c = 1:3
			index = (time_steps*3)*(f_num-1) + time_steps*(c-1) + 1;
			index_end = index + time_steps - 1;
				      
			mredge_3d_to_4d(full_unzipped_file_list_real(index:index_end), REAL_SUB, f, c); % automatically rezips
			mredge_3d_to_4d(full_unzipped_file_list_imag(index:index_end), IMAG_SUB, f, c);

			mredge_ri2pm(info, f, c);
        end
   end

   for f_num = 1:numel(info.driving_frequencies)
        f = info.driving_frequencies(f_num);
        for c = 1:3
           % get binary masks for realignment later
 			index = (time_steps*3)*(f_num-1) + time_steps*(c-1) + 1;
            index_end = index + time_steps - 1;
            mag_path =  fullfile(MAG_SUB, num2str(f), num2str(c), mredge_filename(f, c, '.nii.gz'));
            make_moco_mask(mag_path);
        end
   end

       
   %move stats to root folder
   	FSL_SPLIT_PREFIX = 'vol000';
    stats_path = fullfile(MAG_SUB, num2str(info.driving_frequencies(1)), '1', ['rp_', FSL_SPLIT_PREFIX, '0.txt']);
	stats = load(stats_path);
	delete(stats_path);
	CONVERSION_CONSTANT = 360/(2*pi) *50*pi/360; % R=50mm [Power_2012]
	tx  = squeeze(stats(:,1));
    ty  = squeeze(stats(:,2));
    tz  = squeeze(stats(:,3));
    rx  = squeeze(stats(:,4))*CONVERSION_CONSTANT;
    ry  = squeeze(stats(:,5))*CONVERSION_CONSTANT;
    rz  = squeeze(stats(:,6))*CONVERSION_CONSTANT;
	PV  = 2*sqrt(   (  1/3*( std(tx) + std(ty) + std(tz) )  )^2 + (  1/3*( std(rx) + std(ry) + std(rz) )  )^2   );
	fileID = fopen(fullfile(STATS_SUB, 'moco_full.csv'), 'w');
    for n = 1:numel(tx)
   		fprintf(fileID, '%1.3f, %1.3f, %1.3f, %1.3f, %1.3f, %1.3f \n', tx(n), ty(n), tz(n), rx(n), ry(n), rz(n));
    end
    fclose(fileID);
    fileID = fopen(fullfile(STATS_SUB, 'moco_PV.csv'), 'w');
	fprintf(fileID, '%1.3f \n', PV);
	fclose(fileID);
    toc
end

function call_spm_reslice(file_list, prefix)
    spm('defaults','fmri');
    spm_jobman('initcfg');
    matlabbatch{1}.spm.spatial.realign.write.data = file_list;
    matlabbatch{1}.spm.spatial.realign.write.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.write.roptions.wrap = [1 0 0];
    matlabbatch{1}.spm.spatial.realign.write.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.write.roptions.prefix = prefix;
    spm_jobman('run', matlabbatch);    
end

function [MAG_SUB, REAL_SUB, IMAG_SUB, STATS_SUB] = set_dirs(info, prefs)
    MAG_SUB = fullfile(info.path, 'Magnitude');
    REAL_SUB = fullfile(info.path, 'Real');
    IMAG_SUB = fullfile(info.path, 'Imaginary');
    STATS_SUB = mredge_analysis_path(info, prefs, 'Stats');
end

function replace_files(file_list, prefix, time_steps)
	FSL_SPLIT_PREFIX = 'vol000';
    % 4 for .nii
    prefix_from_end = numel(FSL_SPLIT_PREFIX) + 5;
    for n = 1:numel(file_list)
		index = mod(n-1, time_steps);
        entry = file_list{n};
        prefix_entry = [entry(1:end-prefix_from_end), prefix,entry(end-prefix_from_end+1:end)]; 
        movefile(prefix_entry, entry);
    end
end

function make_moco_mask(mag_path)
        moco_mask_path = mag_path(1:end-7);
        moco_mask_path = [moco_mask_path, '_moco_mask.nii.gz'];
        mag_vol = load_untouch_nii_eb(mag_path);
        mask_vol = mag_vol;
        mag_img = mag_vol.img;
        mask_img = (mag_img == 0);
        mask_vol.img = double(mask_img);
        save_untouch_nii(mask_vol, moco_mask_path);
end
    
