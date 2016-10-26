function [ABSG, PHI, AMP, alpha, mu]=MDEV_springpot(W_wrap,freqs,Nf,Nc,pixel_spacing)

%[ABSG PHI AMP AMPN]=evalmmre_mat(W_wrap,freqs,Nf,Nc,pixel_spacing)
% W_wrap(rows,columns,slices,time,comps,freqs)
% [ABSG PHI]=evalmmre_mat(W_wrap,[70 80 70 60 90 100],2:4,1:3,[3 3]/1000);
% i.s. 2.11.13 

% +EB - springpot variables
sz = size(W_wrap);
U_by_freq = zeros(sz(1), sz(2), sz(3), numel(Nc), numel(Nf));
DU_by_freq = zeros(sz(1), sz(2), sz(3), numel(Nc), numel(Nf));
eta = 1;
% -EB

lowpassthreshold=50;
Nt=size(W_wrap,4);              
om=freqs*2*pi;
numer_phi=0;
denom_phi=0;
numer_G=0;
denom_G=0;
AMP=0;

if max(W_wrap(:))-min(W_wrap(:)) > 2*pi
    W_wrap = 2*pi*( W_wrap-min(W_wrap(:)) ) / ( max(W_wrap(:)) - min(W_wrap(:)) );
end

%h = waitbar(0,['eval MMRE: ' num2str(length(find(Nf))) ' freqs, ' num2str(length(find(Nc))) ' comps']);
 for kf=Nf
     for kc=Nc
        W = LBEUnwrap4DSliceIndependent(W_wrap(:,:,:,:,kc,kf));
        fU=fft(W,[],4);        

%%%%%% inversion %%%%%%%%%%%%%
        
        for k_filter=1:size(fU,3)
           U(:,:,k_filter) = uh_filtspatio2d(fU(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],lowpassthreshold,1,0,5, 'bwlow', 0);
           %U(:,:,k_filter) = fU(:,:,k_filter,2);
        end        
        
        [wx, wy]     = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
        [wxx, ~]   = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [~, wyy]   = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    
        DU=wxx+wyy;
        
        numer_phi=numer_phi+ real(DU).*real(U)+imag(DU).*imag(U);
        denom_phi=denom_phi+ abs(DU).*abs(U);
         
         numer_G=numer_G + 1000*om(kf).^2.*abs(U);
         denom_G=denom_G + abs(DU);
         
         U_by_freq(:,:,:,kc, kf) = U;
         DU_by_freq(:,:,:,kc,kf) = DU;
        
        AMP=AMP+abs(U);
       
     end
 end
 
denom_phi(denom_phi == 0) = eps;
denom_G(denom_G == 0) = eps;

PHI = acos(-numer_phi./denom_phi);
ABSG = numer_G./denom_G;


% EB - springpot
LSQ_inv =  -1000*(  U_by_freq(:,:,:,1,:).*DU_by_freq(:,:,:,1,:) + U_by_freq(:,:,:,2,:).*DU_by_freq(:,:,:,2,:) + ...
    U_by_freq(:,:,:,3,:).*DU_by_freq(:,:,:,3,:)  ) ./ ...
    (  abs(DU_by_freq(:,:,:,1,:)).^2 + abs(DU_by_freq(:,:,:,2,:)).^2 + abs(DU_by_freq(:,:,:,3,:)).^2  );
LSQ_inv = squeeze(LSQ_inv);

mag = 1000.*(  abs(U_by_freq(:,:,:,1,:)) + abs(U_by_freq(:,:,:,2,:)) + abs(U_by_freq(:,:,:,3,:)) ) ./ ...
    ( abs(DU_by_freq(:,:,:,1,:)) + abs(DU_by_freq(:,:,:,2,:)) + abs(DU_by_freq(:,:,:,3,:)) );
LSQ_2b = real(U_by_freq(:,:,:,1,:)).*real(DU_by_freq(:,:,:,1,:)) + real(U_by_freq(:,:,:,2,:)).*real(DU_by_freq(:,:,:,2,:)) + ...
    real(U_by_freq(:,:,:,3,:)).*real(DU_by_freq(:,:,:,3,:)) + imag(U_by_freq(:,:,:,1,:)).*imag(DU_by_freq(:,:,:,1,:)) + ...
    imag(U_by_freq(:,:,:,2,:)).*imag(DU_by_freq(:,:,:,2,:)) + imag(U_by_freq(:,:,:,3,:)).*imag(DU_by_freq(:,:,:,3,:));
LSQ_2c = abs(U_by_freq(:,:,:,1,:)).*abs(DU_by_freq(:,:,:,1,:)) + abs(U_by_freq(:,:,:,2,:)).*abs(DU_by_freq(:,:,:,2,:)) + ...
    abs(U_by_freq(:,:,:,3,:)).*abs(DU_by_freq(:,:,:,3,:));
phi = LSQ_2b ./ LSQ_2c;
LSQ_2 = squeeze(mag.*cos(phi) + 1i*mag.*sin(phi));
for n = 1:kf
    LSQ_inv(:,:,:,n) = LSQ_inv(:,:,:,n) .* om(n).^2;
    LSQ_2(:,:,:,n) = LSQ_2(:,:,:,n) .* om(n).^2;
end
assignin('base', 'LSQ_inv', LSQ_inv);
assignin('base', 'LSQ_2', LSQ_2);
%for testing
%mu = 3.9; alf = 0.6; eta = 2.7;
%Gvec = mu^(1-alf)*eta^alf*(1i*om).^alf;
%Gvec = mu.^(1-alf).*(1i*wvec).^alf;
%Gvec_4 = ones(1, 1, 1, 4);
%Gvec_4(1,1,1,1:4) = Gvec;
%Gvec = Gvec_4;
%LSQ_inv = repmat(Gvec, [32, 32, 4]);
%sz = size(LSQ_inv);
total_voxels = sz(1)*sz(2)*sz(3);
%G_vecs = reshape(LSQ_inv, total_voxels, kf);
G_vecs = reshape(LSQ_inv, total_voxels, kf);
G_log = log(abs(G_vecs));
f_log = log(om);
f_sum = sum(f_log);
f_sumsq = sum(f_log.^2);
f_num = numel(f_log);
block = [f_sumsq, f_sum; f_sum, f_num];
f_logs = repmat(f_log, [total_voxels, 1]);
oms = repmat(om, [total_voxels, 1]);
A = kron(speye(total_voxels), block);

b = zeros(total_voxels*2, 1);
b(1:2:end,1) = sum(G_log.*f_logs,2);
b(2:2:end,1) = sum(G_log,2);

x = A\b;
alpha = x(1:2:end,1);
alphas = repmat(alpha, [1 f_num]);
alpha = reshape(alpha, sz(1), sz(2), sz(3));
muvec = (  G_vecs ./ ( (eta.^alphas).*(1i*oms).^alphas )  ).^( 1./(1-alphas) );
mu = reshape(muvec(:,1), sz(1), sz(2), sz(3));