function G = fv_invert_dirfilt(U, freqvec, spacing)

RHO = 1000;
WEIGHTING_ORDER = 2;

crop = @(x) x(2:end-1, 2:end-1, 2:end-1,:,:);
U = single(U);
sz = size(U);
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end
sz_adj = sz - 3;

%om_vec = (2*pi*(permute(repmat(freqvec, [1 3]), [2 1]))).^2;
%om = zeros(1, 1, 1, numel(om_vec));
%om(:) = om_vec;
%om = repmat(om, [sz_adj(1), sz_adj(2), sz_adj(3), 1]);
b_dot = zeros(sz_adj(1), sz_adj(2), sz_adj(3));
bp_dot = zeros(size(b_dot));
for n = 1:d5
    U_filt = lg_dirfilt(U(:,:,:,:,n), freqvec);
    %U_filt = U(:,:,:,:,n);
    tic
    [b, p, ~] = voxel_terms_5d(U_filt, spacing);
    toc
    [~, w_] = gradestim_nd(abs(crop(U_filt)), spacing); %ignore derivatives, just get shifted displacements
    w_ = squeeze(sum(w_,4));
    w = cat(5, w_, w_, w_);
    om = repmat((2*pi*freqvec(n)).^2, size(w)); 
    b = b.*(w.^WEIGHTING_ORDER);
    p = RHO*p.*om.*(w.^WEIGHTING_ORDER);
    b_dot = add_to_dot(b_dot, b, b);
    bp_dot = add_to_dot(bp_dot, b, p);
end

G = (-1/resh(b_dot,4)) .* resh(bp_dot,4);
G = double(G);

function v_dot = add_to_dot(v_dot, a, b)

a = resh(a,4);
b = resh(b,4);

v_dot = v_dot + squeeze(sum(conj(a).*b, 4));
