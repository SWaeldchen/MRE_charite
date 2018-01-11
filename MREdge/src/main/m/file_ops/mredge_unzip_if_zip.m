function unzip = mredge_unzip_if_zip(zip)
% Unzips nifti if it is zipped. For navigation between SPM, FSL and other packages
%
% INPUTS:
%
%   zip - zipped file path
%
% OUTPUTS:
%
%   unzip - unzipped file path
%
% SEE ALSO:
%
%   mredge_zip_if_unzip
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
if strcmp(zip(end-1:end), 'gz') == 1 && exist(zip, 'file')
    unzip = zip(1:end-3);
	gunzip(zip);
    delete(zip);
else
    unzip = zip;
    if exist([zip,'.gz'], 'file')
        gunzip([zip,'.gz']);
        delete([zip,'.gz']);
    end
end
