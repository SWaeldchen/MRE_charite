function [u_den] = zden_3D_DWT(u, J, mask, debug)
if nargin < 5
    debug = 0;
end
if nargin < 4
    mask = ones(size(u,1), size(u,2), size(u,3));
end
% Dualtree complex denoising 
% with overlapping group sparsity thresholding

[h0, h1, g0, g1] = daubf(3);

[u_resh, n_vols] = resh(u, 4);
u_den = zeros(size(u_resh));

for n = 1:n_vols
    mask = mir(mask);
    w = udwt3D(mir(u_resh(:,:,:,n)),J,h0,h1);
    % loop thru scales
    for j = 1:J
        % ---
        % reverse thresholding method 
        %{
        % loop thru subbands
        MADs = zeros(6,1);
        for s = 2:7
            vol_crop = simplecrop(w{j}{s}, [size(u,1), size(u,2), size(u,3)]);
            MADs(s-1) = get_mad(vol_crop, mask);
        end
        MAD = mean(MADs);
        FAC = 2;
        disp(['Threshing above ', num2str(FAC*MAD)]);
        pct_removed = numel(w{j}{1}(abs(w{j}{1}) > FAC*MAD)) / numel(cell2cat(w{j}));
        w{j}{1}(abs(w{j}{1}) > FAC*MAD) = 0;
        disp(['PCT of coefficients removed: ', num2str(pct_removed)]);
        %}
        % ---
        % sledgehammer version
        % w{j}{1} = zeros(size(w{j}{1}));
        %}
        % ---
        % hipass version
        w{j}{1} = butter_2d(4, 0.25, w{j}{1}, 1);
        %
    end

    u_den(:,:,:,n) = mircrop(iudwt3D(w,J,g0,g1));
end

u_den = reshape(u_den, size(u));

