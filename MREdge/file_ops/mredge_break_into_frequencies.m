%% function mredge_break_into_frequencies(series_number, subdir, driving_frequencies)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% For acquisitions with the all_frequencies_one_series flag,
% partitions the time series by frequency
%
% INPUTS:
%
% series_number - number of series. should be entire file name produced by dcm2niix
% subdir - path of subdir that will contain this series (e.g. 'Phase')
% info - acquisition info 
%
% OUTPUTS:
%
% none

%% collect series numbers

function mredge_break_into_frequencies(series_number, subdir, info)
  	NIF_EXT = getenv('NIFTI_EXTENSION');
	TIME_STEPS = info.time_steps;
	nifti_4d_path = cell2str(fullfile(subdir, [num2str(series_number), NIF_EXT]));
	nifti_4d_vol = load_untouch_nii_eb(nifti_4d_path);
	n_freqs = numel(info.driving_frequencies);
	for f = 1:n_freqs
		for c = 1:3
			index = TIME_STEPS*3*(f-1) + TIME_STEPS*(c-1) + 1;
			sub_vol = nifti_4d_vol;
			sub_vol.hdr.dime.dim(5) = TIME_STEPS;
			sub_vol.img = sub_vol.img(:,:,:,index:index+TIME_STEPS-1);
			component_dir = cell2mat(fullfile(subdir, num2str(info.driving_frequencies(f)), num2str(c)));
			if ~exist(component_dir, 'dir')
				mkdir(component_dir);
			end
			save_untouch_nii(sub_vol, fullfile(component_dir, mredge_filename(info.driving_frequencies(f), c, NIF_EXT)));
		end
	end
end
    
