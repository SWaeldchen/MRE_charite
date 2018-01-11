function v = medfilt1_eb(u, rad)

if size(u,1) == 1
    u = permute(u,[2 1]);
end

[u_resh,n_vecs] = resh(u,2);

v_resh = zeros(size(u_resh));
for i = 1:n_vecs
    for n = rad+1:size(u,2)-rad
        v_resh(n,i) = median(u_resh((n-rad):(n+rad),1));
    end
    for n = 1:1:rad
        v_resh(n,i) = median(u_resh(1:(n+rad),i));
        v_resh(end-n+1,i) = median(u_resh((end-n-rad+1):end,i));
    end
end

v = reshape(v_resh, size(u));