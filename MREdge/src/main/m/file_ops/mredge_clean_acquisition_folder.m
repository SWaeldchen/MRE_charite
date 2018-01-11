function mredge_clean_acquisition_folder(info)
% Cleans all processing files from local acquisition folder, leaving only DICOMs.
%
% USAGE:
%
%   mredge_clean_acquisition_folder(info)
%
% INPUTS:
%
%   info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
%   none
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.

mredge_set_environment;
NIF_EXT = getenv('NIFTI_EXTENSION');
if strcmpi(NIF_EXT, '.nii')  || strcmpi(NIFTI_EXTENSION, '.nii.gz') 
   delete(fullfile(info.path, ['*',NIF_EXT]));
end
   

dir_names = {'Phase', 'Magnitude', 'T1', 'T2', 'Localizer', 'Fieldmap', 'DTI', 'Other', 'Real', 'Imaginary', 'FT'};

for n = dir_names
	full_dir = fullfile(info.path, cell2mat(n));
	if exist(full_dir, 'dir')
		rmdir(full_dir, 's');
	end
end

