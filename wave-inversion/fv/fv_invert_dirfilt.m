function G = fv_invert_dirfilt(U, freqvec, spacing)

RHO = 1000;
WEIGHTING_ORDER = 2;

dot4d = @(x,y) squeeze(sum(conj(x).*y,4));
add_to_dot = @(x, y, z) x + dot4d(y, z);
crop = @(x) x(2:end-1, 2:end-1, 2:end-1,:,:);
U = single(U);
sz = size(U);
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end
sz_adj = sz - 3;

[U_resh, n_vols] = resh(U, 4);
om_vec = (2*pi*(permute(repmat(freqvec, [1 3]), [2 1]))).^2;
om = zeros(1, 1, 1, numel(om_vec));
om(:) = om_vec;
om = repmat(om, [sz_adj(1), sz_adj(2), sz_adj(3), 1]);
b_dot = zeros(sz_adj(1), sz_adj(2), sz_adj(3));
bp_dot = zeros(size(b_dot));
for n = 1:d5
    U_filt = lg_dirfilt(U_resh(:,:,:,:,n), freqvec);
    [b, p, ~] = voxel_terms_5d(U_filt, spacing);
    [~, w_] = gradestim_nd(abs(crop(U_filt)), spacing); %ignore derivatives, just get shifted displacements
    w_ = squeeze(sum(w_,4));
    w = cat(w, 6, w_, w_, w_);
    b = squeeze(b).*(w.^WEIGHTING_ORDER);
    p = RHO*squeeze(p).*om.*(w.^WEIGHTING_ORDER);
    b_dot = add_to_dot(b_dot, b, b);
    bp_dot = add_to_dot(bp_dot, b, p);
end

G = (-1/b_dot) .* bp_dot;
G = double(G);