%% function filename = mredge_filename(series, component)
%
% Part of the MREdge software package
% Created 2016 at Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
% USAGE:
%
% Ensures consistent NIfTI file nomenclature.
%
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

function filename = mredge_filename(series, component, extension, descriptor)
    
    if nargin < 4
      descriptor = '';
    else
      descriptor = ['_', descriptor];
    end
    if isreal(series)
      freq_str = num2str(series);
    elseif iscell(series)
      freq_str = num2str(cell2mat(series));
    elseif ischar(series)
      freq_str = series;
    else
      display('MREdge ERROR: invalid series field');
      return;
    end
    
    if isreal(component)
      comp_str = num2str(component);
    elseif iscell(component)
      comp_str = num2str(cell2mat(component));
    elseif ischar(component)
      comp_str = component;
    else
      display('MREdge ERROR: invalid motion component field');
      return;
    end
    
    filename = [freq_str, '_', comp_str, descriptor, extension];    
    
end
