function [G_s_comb, G_sp_comb, G_s_sep, G_sp_sep] = fv_invert_2(U, freqvec, spacing)

EPSILON = .01;
RHO = 1000;
dot4d = @(x,y) squeeze(sum(conj(x).*y,4));
dot5d = @(x,y) squeeze(sum(conj(x).*y,5));
%crop = @(x) x(2:end-1, 2:end-1, 2:end-1,:,:);

sz = size(U);
[b, p, q] = voxel_terms_5d(U, spacing);
b = simplepad(b, sz(1:3));
p = simplepad(p, sz(1:3));
q = simplepad(q, sz(1:3));
%w_ = squeeze(sum(crop(w_),4));
%w = zeros(sz_adj(1), sz_adj(2), sz_adj(3), 1, sz(5));
%w(:) = w_(:);
%w = repmat(w, [1 1 1 3 1]);
%w = resh(w, 4);
om_5d = ones(1, 1, 1, numel(freqvec));
om_5d(:) = (2*pi*freqvec).^2;
om_rep_5d = repmat(om_5d, [sz(1), sz(2), sz(3) 1 3]);
G_s_sep = (-1/dot5d(b,b)).*dot5d(b,RHO*om_rep_5d.*p);
G_sp_sep = (-1/dot5d(b,b)).*( dot5d(b, RHO*om_rep_5d.*p) + dot5d( (1/EPSILON) * q, b) );

om_rep_4d = resh(om_rep_5d, 4);
%FAC = 2;
b = resh(b, 4);
p = resh(p, 4);
q = resh(q, 4);
G_s_comb = (-1/dot4d(b,b)) .* dot4d(b,RHO*om_rep_4d.*p);
G_sp_comb = (-1/dot4d(b,b)) .* ( dot4d(b,RHO*om_rep_4d.*p)  + dot4d( (1/EPSILON) * q, b) );
