function y = z_MAD(x)

sz = size(x);
mids = round(sz/2);
if (numel(sz)<4) 
    d4 = 1;
else
    d4 = sz(4);
end
y = zeros(d4);
for m = 1:d4
        x_temp = real(x(:,:,:,m));
        x_norm = x_temp - repmat(mean(x_temp, 3), [1 1 sz(3)]); 
        x_norm_abs = abs(x_norm);
        x_MAD = median(x_norm_abs, 3);
        x_MAD_sample = x_MAD(mids(1)-mids(1)/2:mids(1)+mids(1)/2, mids(2)-mids(2)/2:mids(2)+mids(2)/2);
        y(m) = squeeze(median(median(x_MAD_sample)));
end
