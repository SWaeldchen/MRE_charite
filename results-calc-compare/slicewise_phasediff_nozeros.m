function z = slicewise_phasediff_nozeros(x, y, mask)
x_cplx = exp(-1i*x);
y_cplx = exp(-1i*y);
diffs = abs(angle(x_cplx ./ y_cplx));
[diff_resh, n_slcs] = resh(diffs, 3);
z = zeros(n_slcs, 1);
for n = 1:n_slcs
    slc = diff_resh(:,:,n).*mask;
    z(n) = mean(slc(slc~=0));
end