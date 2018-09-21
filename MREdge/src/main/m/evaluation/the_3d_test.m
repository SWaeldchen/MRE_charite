
%% Settings
gridSizeX = 50;
gridSizeY = gridSizeX;
gridSizeZ = 5;

sz = [gridSizeX,gridSizeY,gridSizeZ];

rho = 1;
freqVec = [2, 2.5];
numofFreq = length(freqVec);

%%% Design Mu
mu = repmat(0.5 + phantom('Shepp-Logan', gridSizeX), [1,1,gridSizeZ]);
%mu = mu + rand(size(mu));

%imagesc(mu);

%% Calculate u's
boundaryU = get_boundary_3d(sz);

tic
u = invert_for_u_3d(mu, boundaryU, freqVec, sz);
toc
% return

%% Noisy u's

sigma = reshape(sqrt(sum(reshape(u.^2, [3*prod(sz), numofFreq]), 1)/(3*prod(sz))), [1,1,1,1,numofFreq]);

uNoise = u + sigma.*randn(size(u))/20;

% MIJ = Miji;
% openImage(reshape(u./sigma, [sz(1:2), sz(3)*3*numofFreq])  , MIJ, 'u');
% openImage(reshape(uNoise./sigma, [sz(1:2), sz(3)*3*numofFreq])  , MIJ, 'uNoise');


%% Denoising

uDenoised = denoise_u_3d(uNoise);

% openImage(reshape(uDenoised./sigma, [sz, 2*numofFreq])  , MIJ, 'udenoised');

%% Recalculate Mu

muCorners = mu(corners(sz));

tic
muRec = invert_for_mu_3d(uDenoised, freqVec, muCorners);
toc

muRec = reshape(muRec, sz);

norm(muRec(:) - mu(:))

%imagesc(muRec);

figure;
subplot(1,2,1), imagesc(mu(:,:,1));
colorbar;
caxis([0 max(mu(:))]);
subplot(1,2,2), imagesc(muRec(:,:,1));
colorbar
caxis([0 max(mu(:))]);
% mu
% muRec

return