function [ info ] = getDicomInfoCellArrayFromDataObject( dataCube,selector )
%GETDICOMINFOCELLARRAYFROMDATAOBJECT Returns the dicom header object of the
% data cube
%   If dataCube is complex, tha phase dicom header is returned. With the
%   'selector' parameter dataCube.info.(selector) can be accessed, e.g.
%   dataCube.info.magn


if nargin<2
    selector='phase';
end

help=dataCube.info;
if isstruct(dataCube.info)
    if isfield(help,selector)
        help=dataCube.info.(selector);
    end
end
if iscell(help)
    info=help;
else
    info={help};
end

end

