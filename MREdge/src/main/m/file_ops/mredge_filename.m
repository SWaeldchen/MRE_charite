function filename = mredge_filename(series, component, extension, descriptor)
% Ensures consistent NIfTI file nomenclature
%
% INPUTS:
%
% series - experimental driving series
% component - component of motion (1, 2, or 3)
% extension - file extension
% descriptor - optional. adds additional string at end. frequently used for temporary files
%
% OUTPUTS:
%
% none
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.
%
    
    if nargin < 4
      descriptor = '';
    else
      descriptor = ['_', descriptor];
    end
    if nargin < 3
        extension = getenv('NIFTI_EXTENSION');
    end
    if isreal(series)
      freq_str = num2str(series);
    elseif iscell(series)
      freq_str = num2str(cell2mat(series));
    elseif ischar(series)
      freq_str = series;
    else
      disp('MREdge ERROR: invalid series field');
      return;
    end
    
    if isreal(component)
      comp_str = num2str(component);
    elseif iscell(component)
      comp_str = num2str(cell2mat(component));
    elseif ischar(component)
      comp_str = component;
    else
      disp('MREdge ERROR: invalid motion component field');
      return;
    end
    
    filename = [freq_str, '_', comp_str, descriptor, extension];    
    
end
