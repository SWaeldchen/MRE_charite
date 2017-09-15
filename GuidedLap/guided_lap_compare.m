sz = size(u);
u_lap = zeros(size(u));
u_lap_guided = zeros(size(u));
for m = 1:sz(4)
    for n = 1:sz(5)
        u_lap(:,:,:,m,n) = laplacian_image(u(:,:,:,m,n), spacing, 3, 4, 1);
        u_lap_guided(:,:,:,m,n) = GuidedLap(u(:,:,:,m,n), guides_rep(:,:,:,m,n), spacing);
    end
end