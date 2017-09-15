%% function info = mredge_make_acquisition_info(varargin);
%%
% Create structure containing acquisition information (paths, series indices, etc.)
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
% organize_acquistion(info)
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
% none
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
%	.voxel_spacing: enter vector of voxel spacing. If left empty, MREdge
%		will try to determine from the DICOMs
%
%	
function info = make_acquisition_info(varargin);

	info = initialize_info;
	has_phase = 0;

	if ~ischar(varargin{1})
		display('MREdge ERROR: make_acquisition_info: First entry must be path to files');
		return;
	else
		info.path = varargin{1};
	end
	for n = 2:2:numel(varargin)
		if strcmp(varargin{n}, 'phase') == 1
			info.phase = varargin{n+1};
			has_phase = 1;
		elseif strcmp(varargin{n}, 'magnitude') == 1
			info.magnitude = varargin{n+1};
		elseif strcmp(varargin{n}, 't1') == 1
			info.t1 = varargin{n+1};
		elseif strcmp(varargin{n}, 't2') == 1
			info.t2 = varargin{n+1};
		elseif strcmp(varargin{n}, 'localizer') == 1
			info.localizer = varargin{n+1};
		elseif strcmp(varargin{n}, 'fieldmap') == 1
			info.fieldmap = varargin{n+1};
		elseif strcmp(varargin{n}, 'dti') == 1;
			info.dti = varargin{n+1};
		elseif strcmp(varargin{n}, 'other') == 1;
			info.other = varargin{n+1};
		elseif strcmp(varargin{n}, 'file_extension') == 1;
			info.file_extension = varargin{n+1};
		elseif strcmp(varargin{n}, 'driving_frequencies') == 1;
			info.driving_frequencies = varargin{n+1};
		elseif strcmp(varargin{n}, 'voxel_spacing') == 1;
			info.voxel_spacing = varargin{n+1};
		else
			display(['MREdge ERROR: Invalid field: ', varargin{n}]);
			display('Valid options are: phase, magnitude, t1, t2, localizer, fieldmap, dti, file_extension, or other.');
			return; 
		end
		if has_phase == 0
			display('MREdge ERROR: Acquisition must have at least one phase series');
			return;
		end
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
	info_voxel_spacing = 0;
end
