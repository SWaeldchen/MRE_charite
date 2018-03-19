function [b, p, q] = voxel_terms_5d(U, spacing)

sz = size(U);
if numel(sz) < 5
    nf = 1;
else
    nf = sz(5);
end
for n = 1:nf
    [b(:,:,:,n,:) p(:,:,:,n,:) q(:,:,:,n,:)] = voxel_terms_eb_2(U(:,:,:,:,n), spacing); %#ok<AGROW,NCOMMA>
end
        