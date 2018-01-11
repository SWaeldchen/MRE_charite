function mredge_dicom_to_nifti(info, prefs)
% Converts raw DICOM files into NIfTI objects, which are used for all MREdge processing
%
% INPUTS:
%
%   info - MREdge info object
%
% OUTPUTS:
%
%   none
%
% SEE ALSO:
%
%   mredge_organize_acquisition, mredge_fd_import
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
%% collect series numbers
tic
disp('DICOM to NIfTI...');
system([getenv('NIFTI_CONVERT_COMMAND'), info.path]);
currd = pwd;
cd(info.path);
d = dir(pwd);
%stupid kludge for dcm2niix at 7T
for n = 1:numel(d)
    filename = d(n).name;
    spl = strsplit(filename, '_');
    if numel(filename) >= 4
        if strcmpi(filename(end-3:end), '.nii')
            if ~strcmpi(spl(1), filename)
                movefile(filename, [cell2str(spl(1)), '.nii']);
            end
        end
    end
end
cd(currd);
toc
if (info.fd_import) 
    %to suppress Florian's output use evalc('mredge_fd_import(info)');
    mredge_fd_import(info, prefs);
end
