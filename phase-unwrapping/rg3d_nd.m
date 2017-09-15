function uw = rg3d_nd(u, m)

rg3d = com.ericbarnhill.phaseTools.RG3D;

[u_resh, n_vols] = resh(u, 4);
[m_resh] = resh(m, 4);
for n = 1:n_vols
    disp(n)
    u_resh(:,:,:,n) = rg3d.unwrapPhase(u_resh(:,:,:,n), m_resh(:,:,:,n));
end

uw = reshape(u_resh, size(u));

end