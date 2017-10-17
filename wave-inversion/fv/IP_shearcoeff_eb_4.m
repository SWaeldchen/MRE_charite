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

b = zeros(nx, ny, nz, nf,3);
b_x = zeros(nx, ny, nz, nf,3);
b_y = zeros(nx, ny, nz, nf,3);
b_z = zeros(nx, ny, nz, nf,3);

p = zeros(nx, ny, nz, nf,3);
p_x = zeros(nx, ny, nz, nf,3);
p_y = zeros(nx, ny, nz, nf,3);
p_z = zeros(nx, ny, nz, nf*3);

%{
for i=2:nx-1
    for j=2:ny-1
        for k=2:nz-1
            for f = 1:nf
                Uxxy = DUdxdy(squeeze(Ux(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uyxy = DUdxdy(squeeze(Uy(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uzxy = DUdxdy(squeeze(Uz(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uxxz = DUdxdz(squeeze(Ux(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uyxz = DUdxdz(squeeze(Uy(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uzxz = DUdxdz(squeeze(Uz(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uxyz = DUdydz(squeeze(Ux(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uyyz = DUdydz(squeeze(Uy(:,:,:,f)),[dx,dy,dz],i,j,k);
                Uzyz = DUdydz(squeeze(Uz(:,:,:,f)),[dx,dy,dz],i,j,k);

                b_x(i,j,k,f,:) = [Uxyz(1);0.5*(Uxyz(2)+Uyyz(1));0.5*(Uxyz(3)+Uzyz(1))];
                b_y(i,j,k,f,:) = [0.5*(Uxxz(2)+Uyxz(1));Uyxz(2);0.5*(Uyxz(3)+Uzxz(2))];
                b_z(i,j,k,f,:) = [0.5*(Uxxy(3)+Uzxy(1));0.5*(Uyxy(3)+Uzxy(2));Uzxy(3)];

                % This is an equivalent formula 
                %G2(i,j,k,f) = -rho*(2*pi*freq(f))^2/dot(b,p)*dot(p,p);
            end

        end
    end
end
%}
    U_xy = DUdxdy_eb(Uc, spacing);
    Uxxy = squeeze(U_xy(:,:,:,2,:,:));
    Uyxy = squeeze(U_xy(:,:,:,1,:,:));
    Uzxy = squeeze(U_xy(:,:,:,3,:,:));
    U_xz = DUdxdz_eb(Uc, spacing);
    Uxxz = squeeze(U_xz(:,:,:,2,:,:));
    Uyxz = squeeze(U_xz(:,:,:,1,:,:));
    Uzxz = squeeze(U_xz(:,:,:,3,:,:));
    U_yz = DUdydz_eb(Uc, spacing);
    Uxyz = squeeze(U_yz(:,:,:,2,:,:));
    Uyyz = squeeze(U_yz(:,:,:,1,:,:));
    Uzyz = squeeze(U_yz(:,:,:,3,:,:));

    b_x = cat(5, ...
        Uxyz(:,:,:,:,1), ...
        0.5*(Uxyz(:,:,:,:,2)+Uyyz(:,:,:,:,1)), ...
        0.5*(Uxyz(:,:,:,:,3)+Uzyz(:,:,:,:,1)));
    b_y = cat(5, ...
        0.5*(Uxxz(:,:,:,:,2)+Uyxz(:,:,:,:,1)), ...
        Uyxz(:,:,:,:,2), ...
        0.5*(Uyxz(:,:,:,:,3)+Uzxz(:,:,:,:,2)));
    b_z = cat(5, ...
        0.5*(Uxxy(:,:,:,:,3)+Uzxy(:,:,:,:,1)), ...
        0.5*(Uyxy(:,:,:,:,3)+Uzxy(:,:,:,:,2)), ...
        Uzxy(:,:,:,:,3));


b = b_x + b_y + b_z;
p = cat(5, crop(Ux)*dx*dy*dz, crop(Uy)*dx*dy*dz, crop(Uz)*dx*dy*dz);
sz_adj = sz-2;

freqvec = repmat(1:nf,[3 1]);
freqvec = freqvec(:);
om_sq = (2*pi*freq(freqvec)).^2';
om_4d = ones(1,1,1, numel(freqvec));
om_4d(:) = freqvec;
om_rep = repmat(om_4d, [sz_adj(1) sz_adj(2) sz_adj(3) 1]);
% Evaluation of shear modulus
b = resh(b, 4);
p = resh(p, 4);
dot4d = @(x,y) sum(conj(x).*y,4);

G = (-1/dot4d(b,b)) .* dot4d(b,rho*om_rep.*p);
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


