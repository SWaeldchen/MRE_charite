%
% Test for shear modulus estimation using inner displacements
%
% We consider the simplified elasticity model for a given displacement
% field 'u' :
%
% -rho*w^2*u - div(G*grad(u)) = 0   at each voxel
%
% Then, after integration over each voxel and, assuming that
% G is piecewise constant and rho=1 [gr/cm^3], we obtain the vectorial
% system for each G(voxel) as follows:
% 
% G = -rho*w^2 * dot(b,p)/dot(b,b)  at each voxel
%
% where
%
% b = int_{voxel boundary} e(u)*nds   (integration on the surface)
% p = int_{voxel} u dx                (integration in the voxel)
%  
% with e(u) = 1/2 (grad(u) + grad(u)^T) is the linear strain tensor.
%
%
% Joaquin Mura (2017)
%

%close all;
load('sim.mat');

% some physical parameters
dx  = 1e-3; % 1 mm
dy  = 1e-3;
dz  = 1e-3;
rho = 1e+3; % 1 g/cm^3

% Color axis limits
Gmin = 2.5e3; %  2.5 KPa
Gmax = 1.05e4;% 10.5 KPa

% The data is 6D: y, x, z, time steps, encoding direction, frequency
[ny,nx,nz,nt,~,nf] = size(U);

[X,Y,Z] = meshgrid(linspace(0,nx*dx,nx),linspace(0,ny*dy,ny),linspace(0,nz*dz,nz));

% Find the amplitude at each frequency
U_fft = fft(U,[],4);
Uc    = squeeze(U_fft(:,:,:,2,:,:));

%% The matrices below represent the displacements over a time loop for a given frequency
Ux = squeeze(Uc(:,:,:,2,:));
Uy = squeeze(Uc(:,:,:,1,:));
Uz = squeeze(Uc(:,:,:,3,:));

%clear U Uc U_fft; % to release some memory, just in case

% frequencies: 50Hz, 60Hz, 70Hz and 80Hz
freq = [50,60,70,80];

%% Collecting terms
G = zeros(size(Ux,1), size(Ux, 2), size(Ux, 3));
%G2 = G;
%parpool(4)
%parfor f = 1:nf
sz = size(Uc);
sz_adj = sz-2;
crop = @(x) x(2:end-1, 2:end-1, 2:end-1,:,:);

b = zeros(sz_adj(1), sz_adj(2), sz_adj(3), nf*3);
p = zeros(sz_adj(1), sz_adj(2), sz_adj(3), nf*3);



            for f = 1:nf
                Uxxy = squeeze(DUdxdy_eb(squeeze(Ux(:,:,:,f)),[dx,dy,dz]));
                Uyxy = squeeze(DUdxdy_eb(squeeze(Uy(:,:,:,f)),[dx,dy,dz]));
                Uzxy = squeeze(DUdxdy_eb(squeeze(Uz(:,:,:,f)),[dx,dy,dz]));
                Uxxz = squeeze(DUdxdz_eb(squeeze(Ux(:,:,:,f)),[dx,dy,dz]));
                Uyxz = squeeze(DUdxdz_eb(squeeze(Uy(:,:,:,f)),[dx,dy,dz]));
                Uzxz = squeeze(DUdxdz_eb(squeeze(Uz(:,:,:,f)),[dx,dy,dz]));
                Uxyz = squeeze(DUdydz_eb(squeeze(Ux(:,:,:,f)),[dx,dy,dz]));
                Uyyz = squeeze(DUdydz_eb(squeeze(Uy(:,:,:,f)),[dx,dy,dz]));
                Uzyz = squeeze(DUdydz_eb(squeeze(Uz(:,:,:,f)),[dx,dy,dz]));

                bx = cat(4, Uxyz(:,:,:,1),0.5*(Uxyz(:,:,:,2)+Uyyz(:,:,:,1)),0.5*(Uxyz(:,:,:,3)+Uzyz(:,:,:,1)));
                by = cat(4, 0.5*(Uxxz(:,:,:,2)+Uyxz(:,:,:,1)),Uyxz(:,:,:,2),0.5*(Uyxz(:,:,:,3)+Uzxz(:,:,:,2)));
                bz = cat(4, 0.5*(Uxxy(:,:,:,3)+Uzxy(:,:,:,1)),0.5*(Uyxy(:,:,:,3)+Uzxy(:,:,:,2)),Uzxy(:,:,:,3));

                % direct vectors
                ind = (f-1)*3 +1;


                b(:,:,:,ind:ind+2) = bx + by + bz;

                p(:,:,:,ind:ind+2) = cat(4, crop(Ux(:,:,:,f))*dx*dy*dz, crop(Uy(:,:,:,f))*dx*dy*dz, crop(Uz(:,:,:,f))*dx*dy*dz);
                


                %[b, p, q] = voxel_terms(i, j, k, f, [dx dy dz]);

                % perpendicular vectors: sum(b.*bperp)/3 = O(10^{-26})
                %bperp = [b(2)+b(3);-b(1)+b(3);-b(1)-b(2)];
                %pperp = [p(2)+p(3);-p(1)+p(3);-p(1)-p(2)];

                % This is an equivalent formula 
                %G2(i,j,k,f) = -rho*(2*pi*freq(f))^2/dot(b,p)*dot(p,p);
            end

            dot5d = @(x,y) sum(conj(x).*y,5);
            G_sep = (-1/dot5d(b,b)).*dot5d(b,rho.*p);
            freqvec = repmat(1:nf,[3 1]);
            freqvec = freqvec(:);
            om_sq = (2*pi*freq(freqvec)).^2';
            % Evaluation of shear modulus
            %G = (-1/dot(vec(b(i,j,k,:)),vec(b(i,j,k,:)))) * dot(vec(b(i,j,k,:)),rho*om_sq.*vec(p(i,j,k,:)));
      
%delete(gcp); % closes parallel pool

%% Save output
%save('solution_MRE.mat','G','Ux','Uy','Uz','X','Y','Z');


%% Figures for each frequency

z0 = 4; % slice selection in Z

% Absolute value
figure(1); clf;
subplot(2,2,1);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(abs(G(:,:,z0,1)))); shading interp;
%surf(squeeze(abs(G(:,:,4,1)))); shading interp;
%axis off;
view(0,90);
title(['|G| (',num2str(freq(1)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,2);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(abs(G(:,:,z0,2)))); shading interp;
%axis off;
view(0,90);
title(['|G| (',num2str(freq(2)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,3);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(abs(G(:,:,z0,3)))); shading interp;
%axis off;
view(0,90);
title(['|G| (',num2str(freq(3)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,4);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(abs(G(:,:,z0,4)))); shading interp;
%axis off;
view(0,90);
title(['|G| (',num2str(freq(4)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

% Phase
figure(2); clf;
subplot(2,2,1);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(angle(G(:,:,z0,1)))); shading interp;
%axis off;
view(0,90);
title(['angle(G) (',num2str(freq(1)),' Hz)']); caxis([-pi,pi]);
colorbar;

subplot(2,2,2);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(angle(G(:,:,z0,2)))); shading interp;
%axis off;
view(0,90);
title(['angle(G) (',num2str(freq(2)),' Hz)']); caxis([-pi,pi]);
colorbar;

subplot(2,2,3);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(angle(G(:,:,z0,3)))); shading interp;
%axis off;
view(0,90);
title(['angle(G) (',num2str(freq(3)),' Hz)']); caxis([-pi,pi]);
colorbar;

subplot(2,2,4);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(angle(G(:,:,z0,4)))); shading interp;
axis off;
view(0,90);
title(['angle(G) (',num2str(freq(4)),' Hz)']); caxis([-pi,pi]);
colorbar;

% Real part
figure(3); clf;
subplot(2,2,1);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(real(G(:,:,z0,1)))); shading interp;
%axis off;
view(0,90);
title(['re(G) (',num2str(freq(1)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,2);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(real(G(:,:,z0,2)))); shading interp;
%axis off;
view(0,90);
title(['re(G) (',num2str(freq(2)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,3);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(real(G(:,:,z0,3)))); shading interp;
%axis off;
view(0,90);
title(['re(G) (',num2str(freq(3)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,4);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(real(G(:,:,z0,4)))); shading interp;
%axis off;
view(0,90);
title(['re(G) (',num2str(freq(4)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

% Imaginary part
figure(4); clf;
subplot(2,2,1);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(imag(G(:,:,z0,1)))); shading interp;
%axis off;
view(0,90);
title(['im(G) (',num2str(freq(1)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,2);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(imag(G(:,:,z0,2)))); shading interp;
view(0,90);
title(['im(G) (',num2str(freq(2)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,3);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(imag(G(:,:,z0,3)))); shading interp;
%axis off;
view(0,90);
title(['im(G) (',num2str(freq(3)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;

subplot(2,2,4);
surf(squeeze(X(:,:,z0)),squeeze(Y(:,:,z0)),squeeze(Z(:,:,z0)),squeeze(imag(G(:,:,z0,4)))); shading interp;
%axis off;
view(0,90);
title(['im(G) (',num2str(freq(4)),' Hz)']); caxis([Gmin,Gmax]);
colorbar;


