function vol_filt = hipass_butter_3d_mirror(ord, cut, vol)

vol_filt = zeros(size(vol));
sz = size(vol);
if numel(sz) < 5
    d5 = 1;
    if numel(sz) < 4
        d4 = 1;
    else
        d4 = sz(4);
    end
else
    d4 = sz(4);
    d5 = sz(5);
end

pwr2_y = nextpwr2(sz(1));
pwr2_x = nextpwr2(sz(2));
pwr2_z = nextpwr2(sz(3));

pwrmax = max(pwr2_y, max(pwr2_x, pwr2_z));
pad_vec = [pwrmax, pwrmax, pwrmax];





filt = butterworth_3d(ord, cut, pad_vec, 1);
assignin('base', 'filt', filt);


for n = 1:d5
    for m = 1:d4
        vol_temp = vol(:,:,:,m,n);
		[vol_ex, order_vector] = extendZ2(vol_temp, pwrmax);
        vol_pad = simplepad(vol_ex, pad_vec);
        vol_ft = fftshift(fftn(vol_pad));
        vol_ft_filt = vol_ft.*filt;
		vol_filt_pad = ifftn(ifftshift(vol_ft_filt));
		vol_filt_ex = vol_filt_pad(1:sz(1), 1:sz(2), :);
		firsts = find(order_vector==1);
		index1 = firsts(1);
		index2 = index1 + sz(3) - 1;
        vol_filt(:,:,:,m,n) = vol_filt_ex(:,:,index1:index2);
    end
end

