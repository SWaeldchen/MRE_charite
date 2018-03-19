function [grad, U] = gradestim_nd(U,d)
% 4D-Regression method for gradient estimation in cartesian grids
%
% [grad_resh(:,:,:,n),U_resh(:,:,:,n)] = gradestim4d(F,[dx,dy,dz])
% grad_resh(:,:,:,n): Gradient estimation at staggered nodes
% U_resh(:,:,:,n)   : F evaluated at staggered nodes
% 
% Note that size(U_resh(:,:,:,n)) = size(F)-[1,1,1] and size(grad_resh(:,:,:,n)) = [size(U_resh(:,:,:,n)),3].
%
% Example:
% [x,y,z] = meshgrid(0:0.05:1,0:0.05:1,0:0.05:1);
% w = sin(2*pi*x); dwdx_exact = 2*pi*cos(2*pi*x);
% [gradw,wstag] = gradestim4d(w,[0.05,0.05,0.05]);
% xs = 0.5*(x(1:end-1,1:end-1,1:end-1)+x(2:end,2:end,2:end)); % staggered coords
% ys = 0.5*(y(1:end-1,1:end-1,1:end-1)+y(2:end,2:end,2:end));
% zs = 0.5*(z(1:end-1,1:end-1,1:end-1)+z(2:end,2:end,2:end));
% figure(1);clf
% subplot(2,1,1);
% surf(squeeze(xs(:,:,1)),squeeze(ys(:,:,1)),squeeze(gradw(:,:,1,1))); 
% xlabel('x'); ylabel('y'); zlabel('z'); title('numerical');
% subplot(2,1,2);
% surf(squeeze(x(:,:,1)),squeeze(y(:,:,1)),squeeze(dwdx_exact(:,:,1)));
% xlabel('x'); ylabel('y'); zlabel('z'); title('exact');
%

% Following: 
% 'Gradient estimation in volume data using 4D Linear Regression'
% Neumann et al., Comput.Graph Forum, vol.19, no.3, pp.351-358 (2000)
%
% J.Mura (2017).

sz = size(U);

[U_resh, n_vols] = resh(U,4);
resh_sz = size(U_resh);
resh_sz_adj = [resh_sz(1)-1, resh_sz(2)-1, resh_sz(3)-1, n_vols];
U_shifts = zeros(resh_sz_adj);
grads = zeros([resh_sz_adj, 3]);

parfor n = 1:n_vols
    U_temp = U_resh(:,:,:,n);
    U_shift = zeros(resh_sz_adj(1:3));
    grad = zeros([resh_sz_adj(1:3),3]);
    dx=d(1); dy=d(2); dz=d(3);
    [ny,nx,nz] = size(U_temp);
    
    % array with relative shifts
    X = 0.5*[...
        -dx,-dy,-dz,2;...
        dx,-dy,-dz,2;...
        -dx,dy,-dz,2;...
        dx,dy,-dz,2;...
        -dx,-dy,dz,2;...
        dx,-dy,dz,2;...
        -dx,dy,dz,2;...
        dx,dy,dz,2];

    %XtX = (X'*X);
    pX = pinv(X);

    % for evaluation at index i=I+indI, j=J+indJ and k=K+indK, resp.
    indI = [0,1,0,1,0,1,0,1];
    indJ = [0,0,1,1,0,0,1,1];
    indK = [0,0,0,0,1,1,1,1];


    %% slow form
    for I = 1:nx-1
        for J = 1:ny-1
            for K = 1:nz-1
                b = transpose(U_temp(sub2ind(size(U_temp),J+indJ,I+indI,K+indK)));
                %x = pinv(X)*b; % Moore-Penrose pseudoinverse
                %x = XtX\(X'*b); 
                x = pX*b;

                %grad_resh(:,:,:,n)(J,I,K,:) = transpose(x(1:3));
                grad(J,I,K,:) = [x(2);x(1);x(3)];
                U_shift(J,I,K) = x(4);
            end
        end
    end
    U_shifts(:,:,:,n) = U_shift;
    grads(:,:,:,n,:) = grad;
end


U = reshape(U_shifts, [resh_sz_adj(1:3) sz(4:end)]);
grad = reshape(grads, [resh_sz_adj(1:3) sz(4:end) 3]);

return;