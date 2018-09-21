

%% Settings
gridSize = 100;
sz = [gridSize,gridSize];

rho = 1;
freqVec = [2, 3];
numofFreq = length(freqVec);

%%% Design Mu
mu = 0.5 + phantom('Shepp-Logan', gridSize);
%imagesc(mu);

%% Calculate u's
boundaryU = get_boundary(sz);

tic
u = invert_for_u_2d(mu, boundaryU, freqVec, sz);
toc



%% Noisy u's

sigma = reshape(sqrt(sum(reshape(u.^2, [2*prod(sz), numofFreq]), 1)/(2*prod(sz))), [1,1,1,numofFreq]);

uNoise = u + sigma.*randn(size(u))/20;

MIJ = Miji;
%  openImage(reshape(u./sigma, [sz, 2*numofFreq])  , MIJ, 'u');
% openImage(reshape(uNoise./sigma, [sz, 2*numofFreq])  , MIJ, 'uNoise');
% 

%% Denoising

uDenoised = denoise_u_2d(uNoise);

% openImage(reshape(uDenoised./sigma, [sz, 2*numofFreq])  , MIJ, 'udenoised');

%% Recalculate Mu

muCorners = [mu(1,1); mu(1,end); mu(end,1); mu(end,end)];

tic
muRec = invert_for_mu_2d(uDenoised, freqVec, muCorners);
toc

muRec = reshape(muRec, sz);

%imagesc(muRec);

figure;
subplot(1,2,1), imagesc(mu);
colorbar;
%caxis([0 max(mu(:))]);
subplot(1,2,2), imagesc(muRec);
colorbar
caxis([0 max(mu(:))]);
% mu
% muRec

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% dim.x = 1; dim.y = 2;
% 
% [sz(1), sz(2), ~, numofFreq] = size(u);
% gridSize = max(sz);
% 
% diff_x = @(v) convn(v, diff_kernel_2(dim.x, dim.y), 'valid');
% diff_y = @(v) convn(v, diff_kernel_2(dim.y, dim.x), 'valid');
% diff_xx = @(v) convn(v, diff_kernel_2([dim.x, dim.x], dim.y), 'valid');
% diff_xy = @(v) convn(v, diff_kernel_2([dim.x, dim.y], []), 'valid');
% diff_yy = @(v) convn(v, diff_kernel_2([dim.y, dim.y], dim.x), 'valid');
% 
% %%% D_u mu = (Nabla mu)*E + mu Nabla*E = - omega^2 * u
% 
% Op = [];
% rhside = [];
% 
% %%% Nabla
% 
% Nabla = nabla(sz);
% P_inner = speye(prod(sz));
% P_inner(bound(sz),:) = [];
% P_corners = speye(prod(sz));
% P_corners = P_corners(corners(sz),:);
% 
% freq = 1;
% 
% %%% shear tensor E
% 
% u_x = u(:,:,dim.x, freq);
% u_y = u(:,:,dim.y, freq);
% 
% E{1,1} = 2*diff_x(u_x); E{1,2} = diff_x(u_y) + diff_y(u_x); 
% E{2,1} = diff_y(u_x) + diff_x(u_y); E{2,2} = 2*diff_y(u_y);
% 
% %%% Nabla*E
% 
% Nabla_E{1,1} = 2*diff_xx(u_x) + diff_yy(u_x) + diff_xy(u_y);
% Nabla_E{2,1} = 2*diff_yy(u_y) + diff_xx(u_y) + diff_xy(u_x);
% 
% %%% D_u mu
% 
% D_u_x = sparse(E{1,1}(:)).*Nabla{1} + sparse(E{1,2}(:)).*Nabla{2} + sparse(Nabla_E{1,1}(:)).*P_inner;
% D_u_y = sparse(E{2,1}(:)).*Nabla{1} + sparse(E{2,2}(:)).*Nabla{2} + sparse(Nabla_E{2,1}(:)).*P_inner;
% % D_u_x = sparse(Nabla_E{1,1}(:)).*P_inner;
% % D_u_y = sparse(Nabla_E{2,1}(:)).*P_inner;
% 
% A = D_u_x*mu(:);
% 
% reshape(A, sz-2)
% 
% 
% % D_u = [D_u_x; D_u_y];    
% % Op = [Op; D_u];
% 
% %$%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% u = u(:,:,:,1);
% 
% dirMat = cell(2,2);
% 
% for dirIn = 1:2  
%     for dirOut = 1:2
%         dirMat{dirOut, dirIn} = sparse(prod(sz), prod(sz));
%     end
% end
% 
% boundaryId = boundary_id_2d(sz);
% innerId = speye(prod(sz)) - boundaryId;
% 
% for dirIn = 1:2
% 
%     %dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn} + innerId;
%     %dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn} + boundaryId;
%     
%     
%     for dirOut = 1:2
%         
%         dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn}  + dmu_dxi_d_dxj(mu, sz, dirOut, dirOut);
%         dirMat{dirIn, dirIn}  = dirMat{dirIn, dirIn}  + mu_d_dxidxj(mu, sz, dirOut, dirOut);
%         
%         dirMat{dirOut, dirIn} = dirMat{dirOut, dirIn} + dmu_dxi_d_dxj(mu, sz, dirIn, dirOut);
%         dirMat{dirOut, dirIn} = dirMat{dirOut, dirIn} + mu_d_dxidxj(mu, sz, dirIn, dirOut);
%         
%     end
% end
% 
% % dirMat{1,1}
% 
% diffOp = sparse(cell2mat(dirMat(1,:)));
% 
% B = diffOp*u(:);
% 
% reshape(B, sz)
% 
% 
% function [muDDxiDxj] = mu_d_dxidxj(mu, lx, i, j)
% 
% id = ndSparse(speye(prod(lx)), [lx, lx]);
% kernel = diff_kernel([i,j], [1,2], [3,4]);
% 
% diffOp = red_convn(id, kernel, [1,2]);
% diffOp = sparse(reshape(diffOp, [prod(lx), prod(lx)]));
% 
% muDDxiDxj = mu(:).*diffOp;
% 
% end
% 
% function [dMuDxiDxj] = dmu_dxi_d_dxj(mu, lx, i, j)
% 
% kernel = diff_kernel(i, [1,2], []);
% dMuDxi = red_convn(mu, kernel, [1,2]);
% 
% id = ndSparse(speye(prod(lx)), [lx, lx]);
% kernel = diff_kernel(j, [1,2], [3,4]);
% diffOp = red_convn(id, kernel, [1,2]);
% diffOp = sparse(reshape(diffOp, [prod(lx), prod(lx)]));
% 
% dMuDxiDxj = dMuDxi(:).*diffOp;
% 
% end