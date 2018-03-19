function db = pct_to_db(pct, type)
    if nargin < 2
        type = 'field';
    end
    if strcmp(type, 'power')
    db = 