function [longname] = FullpathSub(prefix, shortname)
% input: appends path to all files (if required)
nsessions = length(shortname(:,1));
longname = cell(nsessions,1);
for s = 1 : nsessions
    [pth,nam,ext,vol] = spm_fileparts(strvcat(deblank(shortname(s,:))) );
    if isempty(pth); pth=pwd; end;
    sname = fullfile(pth,[prefix, nam, ext]);
    if exist(sname)~=2; fprintf('Warning: unable to find image %s - cd to approrpiate working directory.\n',sname); end;
    sname = fullfile(pth,[prefix, nam, ext,vol]);
    longname(s,1) = {sname};
end;
end %%END subfunction FullpathSub