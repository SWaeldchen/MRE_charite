function prefs = mredge_prefs(varargin)
% Creates preferences object for MREdge
%
% INPUTS:
%
%   key-value pairs to set preferences
%
% OUTPUTS:
%
%   MREdge preferences struct object
%
% EXAMPLE USAGE:
%
%   prefs  = mredge_prefs('hipass', 0, 'inversion_strategy', 'SFWI');
%
% SEE ALSO:
%   
%   mredge, mredge_default_prefs, mredge_info
%
% Part of the MREdge software package
% Copyright (c) 2018 Eric Barnhill. All Rights Reserved
% So that we can vouch for results, 
% this code is source-available but not open source.
% Please contact Eric Barnhill at ericbarnhill@protonmail.ch 
% for permission to make modifications.

prefs = mredge_default_prefs;
for n = 1:2:nargin
    field_is_valid = 1;
    field_break = strfind(varargin{n}, '.');
    if ~isempty(field_break)
        fields = cell(2,1);
        fields{1} = varargin{n}(1:field_break-1);
        fields{2} = varargin{n}( (field_break+1):end );
    else
        fields{1} = varargin{n};
    end
    if isfield(prefs, fields{1})
        if numel(fields) == 1
            prefs.(fields{1}) = varargin{n+1};
        else
            if isfield(prefs.(fields{1}), fields{2})
                prefs.(fields{1}).(fields{2}) = varargin{n+1};
            else
                field_is_valid = 0;
            end
        end
    else
        field_is_valid = 0;
    end
    if field_is_valid == 0
        display(['MREdge ERROR: Invalid preferences field ', varargin{n}]);
        prefs = [];
        return
    end
end
prefs = mredge_validate_prefs(prefs);
end



