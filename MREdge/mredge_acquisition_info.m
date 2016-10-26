%% function info = mredge_acquisition_info(varargin);
%%
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% This function will organize the acquisition into relevantly labelled folders
% for the post-processing pipeline to parse
%
% USAGE:
%
% Create structure containing information for MRE acquisition
%
% INPUTS:
%
% A series of text-value pairs to set values in the acquisition information
% structure
%
% OUTPUTS:
%
% info - an acquisition info structure for use with MREdge
%
% Accepted fields for acquisition info structures:
%
%	.path : Required. This path will be called as-is, whether it should be
%			absolute or relative is left to the user
%
%	.phase : Required. Vector of series numbers for the phase image acquisitions
%
%	.magnitude : Vector of series numbers for the magnitude image acquisitions
%
%	.t1 : Vector of series numbers for any accompanying T1 images
%
%	.t2 : Vector of series numbers for any accompanying T2 images
%
%	.localizer : Vector of series numbers for any accompanying localizer images
%
%	.fieldmap: Two-value vector for RL fieldmap (entry 1) and LR fieldmap (entry 2).
%
%	.dti : Vector of series numbers for any acompanying DTI acquisitions
%
%	.other : Vector of series numbers for any other acquisitions
%
%	.extension : Default extension is Siemens DICOM or '.ima' Set this field
% 		to change to for example '.dcm'
%
%	.driving_frequencies: enter vector of experimental driving freqencies
%
%	.voxel_spacing: enter vector of voxel spacing in mm. If left empty, MREdge
%		will try to determine from the DICOMs
%
%	.time_steps: enter number of time steps. Default is 8
%
%	.all_freqs_one_series: processes data differently if all frequencies are
%	captured in one series number. set to 1 if true. Default: 0
%	
%
%	
function info = mredge_acquisition_info(varargin)

	info = initialize_info;
	has_phase = 0;

	if ~ischar(varargin{1})
		display('MREdge ERROR: make_acquisition_info: First entry must be path to files');
		return;
	else
		info.path = varargin{1};
	end
	for n = 2:2:numel(varargin)
        arg_lower = lower(varargin{n});
		if strcmp(arg_lower, 'phase') == 1
			info.phase = varargin{n+1};
			has_phase = 1;
		elseif strcmp(arg_lower, 'magnitude') == 1
			info.magnitude = varargin{n+1};
		elseif strcmp(arg_lower, 't1') == 1
			info.t1 = varargin{n+1};
		elseif strcmp(arg_lower, 't2') == 1
			info.t2 = varargin{n+1};
		elseif strcmp(arg_lower, 'localizer') == 1
			info.localizer = varargin{n+1};
		elseif strcmp(arg_lower, 'fieldmap') == 1
			info.fieldmap = varargin{n+1};
		elseif strcmp(arg_lower, 'dti') == 1
			info.dti = varargin{n+1};
		elseif strcmp(arg_lower, 'other') == 1
			info.other = varargin{n+1};
		elseif strcmp(arg_lower, 'file_extension') == 1
			info.file_extension = varargin{n+1};
		elseif strcmp(arg_lower, 'driving_frequencies') == 1
			info.driving_frequencies = varargin{n+1};
		elseif strcmp(arg_lower, 'voxel_spacing') == 1
			info.voxel_spacing = varargin{n+1};
		elseif strcmp(arg_lower, 'time_steps') == 1
			info.time_steps = varargin{n+1};
        elseif strcmp(arg_lower, 'all_freqs_one_series') == 1
            info.all_freqs_one_series = varargin{n+1};
		else
			display(['MREdge ERROR: Invalid field: ', arg_lower]);
			display('Valid options are: phase, magnitude, t1, t2, localizer, fieldmap, dti, file_extension, driving_frequencies, voxel_spacing, time_steps, all_freqs_one_series, or other.');
			return; 
		end
	end
    if has_phase == 0
        display('MREdge ERROR: Acquisition must have at least one phase series');
        return;
    end
end

function info = initialize_info
	% ensures that later methods can analyze the acquisition content with isempty()
	info.path = '';
	info.phase = [];
	info.magnitude = [];
	info.t1 = [];
	info.t2 = [];
	info.localizer = [];
	info.fieldmap = [];
	info.dti = [];
	info.other = [];
	info.file_extension = '.ima';
	info.driving_frequencies = 0;
	info.voxel_spacing = [.002 .002 .002];
    info.time_steps = 8;
    info.all_freqs_one_series = 0;
end
