wavelet_montage = [];

wavelet_mad = zeros(5, 6);
for i = 1:1
    row = [];
    for j = 1:3
        slice = results_2{2}(:,:,i,j);
        row = cat(2, row, slice);
        wavelet_mad(i,j) = mad_eb(slice(:));
    end
    wavelet_montage = cat(1, wavelet_montage, row);
end