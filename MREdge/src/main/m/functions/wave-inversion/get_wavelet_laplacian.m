
function U_laplacian = get_wavelet_laplacian(U, spacing, twoD, J)

sz = size(U);
new_3d = prod(sz(3:end));
U_resh = reshape(U, [sz(1) sz(2) new_3d]);
[h0, h1, g0, g1] = daubf(3);

U_laplacian = zeros(size(U_resh));

for n = 1:new_3dexit
    slice = U_resh(:,:,n);
    w = udwt2D(slice, J, h0, h1);
    w{4} = lap(w{4});
    slice_lap = iudwt2D(w, J, g0, g1);
    slice_lap = slice_lap ./ spacing(1).^2;
    U_laplacian(:,:,n) = slice_lap;
end

U_laplaciah = reshape(U_laplacian, sz);

end
    

