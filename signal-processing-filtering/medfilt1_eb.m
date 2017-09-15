function v = medfilt1_eb(u, rad)

[u_resh,n_vecs] = resh(u,2);

v_resh = zeros(size(u_resh));
for i = 1:n_vecs
    for n = rad+1:size(u,1)-rad
        v_resh(n,i) = median(u_resh(n-rad:n+rad,i));
    end
    for n = 1:1:rad
        v_resh(n,i) = median(u(1:n+rad,i));
        v_resh(end-n+1,i) = median(u_resh(end-n-rad+1:end,i));
    end
end

v = reshape(v_resh, size(u));