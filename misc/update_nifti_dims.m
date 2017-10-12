function nii = update_nifti_dims(nii)

sz = size(nii.img);

if numel(sz) < 6
    d6 = 1;
    if numel(sz) < 5
        d5 = 1;
        if numel(sz) < 4
            d4 = 1;
            if numel(sz) < 3
                d3 = 1;
            else
                d3 = sz(3);
            end
        else
            d4 = sz(4);
        end
    else
        d5 = sz(5);
    end
else
    g6 = sz(6);
end
        
nii.hdr.dime.dim = [numel(sz) sz(1) sz(2) d3 d4 d5 d6 1];