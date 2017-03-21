function v = align_phase(u)
v = u;
sz = size(u);
u = resh(u,3);
for n = 1:size(u,3)
    unwrap_slc = u(:,:,n);
%    mc = middle_circle(unwrap_slc);
    mc = unwrap_slc;
    md = median(median(mc(~isnan(mc))));
    distance = round(abs(md)/(2*pi))*sign(md);
    v(:,:,n) = unwrap_slc - 2*pi*distance;
end
u = reshape(u, sz);