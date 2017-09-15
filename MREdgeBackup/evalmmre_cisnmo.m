function [ABSG,PHI,ABSG_orig,PHI_orig,AMP] = evalmmref(W_wrap,freqs,pixel_spacing)
% function [ABSG,PHI,ABSG_orig,PHI_orig,AMP,varmapX, varmapY, offsetX, offsetY] = evalmmre(W_wrap,freqs)

filt = 100;
SFloworder = 1;

Nf=size(W_wrap,6);
Nc=size(W_wrap,5);
Nt=size(W_wrap,4);

varmapX = zeros([size(W_wrap, 1), size(W_wrap, 2), size(W_wrap, 3), Nc, Nf]);
varmapY = zeros([size(W_wrap, 1), size(W_wrap, 2), size(W_wrap, 3), Nc, Nf]);
offsetX = varmapX;
offsetY = varmapX;

%pixel_spacing = [1.9 1.9]/1000;

om=freqs*2*pi;
numer_phi=0;
denom_phi=0;
numer_phi_noise=0;
denom_phi_noise=0;
numer_G=0;
denom_G=0;
numer_G_orig=0;
denom_G_orig=0;

AMP=0;

inc=0;
for kf=1:Nf
    for kc=1:Nc
        for kt=1:Nt
            inc=inc+1;
            
            PHI = angle(smooth3(exp(1i*W_wrap(:,:,:,kt,kc,kf)),'gaussian',[5 5 1]));
            [PHIX PHIY]=gradient(exp(1i*PHI));
            
            UX(:,:,:,kt) = imag(PHIX.*exp(-1i*PHI));
            UY(:,:,:,kt) = imag(PHIY.*exp(-1i*PHI));
            
        end
        
        fUX = fft(UX,[],4);
        fUY = fft(UY,[],4);

%         [fUX,vfUX] = sinfit(UX);
%         [fUY,vfUY] = sinfit(UY);
%         
%         varmapX(:,:,:,kc,kf) = squeeze(vfUX(:,:,:,1));
%         varmapY(:,:,:,kc,kf) = squeeze(vfUY(:,:,:,1));
%         offsetX(:,:,:,kc,kf) = squeeze(fUX(:,:,:,1));
%         offsetY(:,:,:,kc,kf) = squeeze(fUY(:,:,:,1));
        
        %%%%%% inversion %%%%%%%%%%%%%
        
        for k_filter=1:size(fUX,3)
            U(:,:,k_filter) = uh_filtspatio2d(fUX(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],filt,SFloworder,0,5,'bwlow',0);
        end
        
        [wx wy]   = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        
        DU=wxx+wyy;
        
        %%%%%%% for noise correction
        N=smooth3(U,'gaussian',[3 3 1])-U;
        [wx wy]   = gradient(N,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        
        DN=wxx+wyy;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        numer_phi = numer_phi + real(DU).*real(U) + imag(DU).*imag(U);
        denom_phi = denom_phi + abs(DU).*abs(U);
        
        numer_phi_noise = numer_phi_noise + real(DN).*real(N)+imag(DN).*imag(N);
        denom_phi_noise = denom_phi_noise + abs(DN).*abs(N);
        
        numer_G = numer_G + 1000*om(kf).^2.*(abs(U)-abs(N));
        denom_G = denom_G + abs(DU) - abs(DN);
        
        AMP=AMP+abs(U);
        
        for k_filter = 1:size(fUY,3)
            U(:,:,k_filter) = uh_filtspatio2d(fUY(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],filt,SFloworder,0,5,'bwlow',0);
        end
        
        [wx wy]   = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        
        DU=wxx+wyy;
        
        %%%%%% for noise correction
        N=smooth3(U,'gaussian',[3 3 1])-U;
        [wx wy]   = gradient(N,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        
        DN=wxx+wyy;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        numer_phi = numer_phi+real(DU).*real(U)+imag(DU).*imag(U);
        denom_phi = denom_phi+abs(DU).*abs(U);
        
        numer_phi_noise = numer_phi_noise+ real(DN).*real(N)+imag(DN).*imag(N);
        denom_phi_noise = denom_phi_noise+ abs(DN).*abs(N);
        
        numer_G = numer_G + 1000*om(kf).^2.*(abs(U)-abs(N));
        denom_G = denom_G + abs(DU) - abs(DN);
        
        numer_G_orig = numer_G_orig + 1000*om(kf).^2.*abs(U);
        denom_G_orig = denom_G_orig + abs(DU);
        
        AMP=AMP+abs(U);
        
    end
end

denom_phi(denom_phi == 0) = eps;
denom_phi_noise(denom_phi_noise == 0) = eps;
denom_G(denom_G == 0) = eps;

PHIN = acos(-numer_phi_noise./denom_phi_noise);
corr_phi=mean(PHIN(PHIN < 0.4));

PHI = acos(-numer_phi./denom_phi) - corr_phi;
ABSG = numer_G./denom_G;

PHI_orig = acos(-numer_phi./denom_phi);
ABSG_orig = numer_G_orig./denom_G_orig;

end
