function db = pct_to_db(pct, type)
    if nargin < 2
        type = 'field';
    end
    if strcmpi(type, 'power')
        db = 10.*log(1./pct)./log(10);
    elseif strcmpi(type, 'field')
        db = 20.*log(1./pct)./log(10);
    else
        disp('ERROR: pct_to_db: type must be field or power');
    end