function mredge_dicom_to_nifti(info)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Organizes DICOM slices into NIfTI objects. Option for FD import.
%
% INPUTS:
%
% info - an acquisition info structure created by make_acquisition_info
%
% OUTPUTS:
%
% none

%% collect series numbers

disp('Organizing Acquisition Folder...');
system([getenv('NIFTI_CONVERT_COMMAND'), info.path]);

if (info.fd_import) 
    evalc('mredge_fd_import(info)');
end
