function [ABSG PHI AMP AMPN WtoN A ABSG_WITHOUTNOISE PHI_WITHOUTNOISE] = evalmmre_mat_test_2(W_wrap,freqs,Nf,Nc,pixel_spacing,QC_flag,BW,animatedwaves,lowpassthreshold)

%[ABSG PHI AMP AMPN]=evalmmre_mat(W_wrap,freqs,Nf,Nc,pixel_spacing,[animatedwaves])
% W_wrap(rows,columns,slices,time,comps,freqs)
% [ABSG PHI]=evalmmre_mat(W_wrap,[70 80 70 60 90 100],2:4,1:3,[3 3]/1000);
% [ABSG PHI]=evalmmre_mat(W_wrap,[70 80 70 60 90 100],2:4,1:3,[3 3]/1000,1);
% i.s. 26.11.13

if nargin < 8
    animatedwaves = 0;
end

%lowpassthreshold=100;

Nt=size(W_wrap,4);

om=freqs*2*pi;
numer_phi = 0;
denom_phi = 0;
numer_phi_noise = 0;
denom_phi_noise = 0;

numer_G_withoutnoisecorr = 0;
denom_G_withoutnoisecorr = 0;
numer_G = 0;
denom_G = 0;


AMP=0;
AMPN=0;
A_Ux=zeros(length(Nc),length(Nf));
A_Uy=zeros(length(Nc),length(Nf));
WtoN_freq_Ux=zeros(length(Nc),length(Nf));
WtoN_freq_Uy=zeros(length(Nc),length(Nf));

%h = waitbar(0,['eval MMRE: ' num2str(length(find(Nf))) ' freqs, ' num2str(length(find(Nc))) ' comps']);
inc=0;
for kf=Nf
    for kc=Nc
        for kt=1:Nt
            inc=inc+1;
            %       waitbar(inc/(length(Nf)*Nt*length(Nc)),h)
            
            PHI=angle(smooth3(exp(1i*W_wrap(:,:,:,kt,kc,kf)),'gaussian',[5 5 1]));
            
            [PHIX PHIY]=gradient(exp(1i*PHI));
            
            UX(:,:,:,kt)=imag(PHIX.*exp(-1i*PHI));
            UY(:,:,:,kt)=imag(PHIY.*exp(-1i*PHI));
            
        end
        
        fUX=fft(UX,[],4);
        fUY=fft(UY,[],4);
        
        %%%%%%animation of waves%%%%%%%%%%%%%%%%%%%%%%%
        if animatedwaves
            tmp=animate(w3D2w2D(fUX(:,:,:,2)-fUY(:,:,:,2)),16);
            close all
            ca=[-1 1]*max(abs(tmp(:)))/4;
            for kt=1:16
                plot2dwaves(tmp(:,:,kt));
                colormap gray
                caxis(ca)
            end
            openfigs2gif(0.1,['Nf_' num2str(kf) '_Nc' num2str(kc) '.gif'])
            close all
        end
        
        %%%%%%%Quality control%%%%%%%%%%%%%%%%%%%%%%%
        switch QC_flag
            case 'QC_on'
                
                WtoN_Ux=squeeze(abs(fUX(:,:,:,2))./abs(fUX(:,:,:,4)));
                WtoN_freq_Ux(kc,kf)=mean(WtoN_Ux(logical(BW)));
                
                WtoN_Uy=squeeze(abs(fUY(:,:,:,2))./abs(fUY(:,:,:,4)));
                WtoN_freq_Uy(kc,kf)=mean(WtoN_Uy(logical(BW)));
                
                A_Ux=WtoN_freq_Ux;
                A_Ux(A_Ux>3)=1;
                A_Ux(A_Ux~=1)=0;
                
                A_Uy=WtoN_freq_Uy;
                A_Uy(A_Uy>3)=1;
                A_Uy(A_Uy~=1)=0;
                
                fUX=fUX.*A_Ux(kc,kf);
                fUY=fUY.*A_Uy(kc,kf);
                
            case 'QC_off'
        end
        
        %%%%%% Inversion %%%%%%%%%%%%%
        %%% Teil 1, x-Richtung
        
        for k_filter = 1:size(fUX,3)
            U(:,:,k_filter) = uh_filtspatio2d(fUX(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],lowpassthreshold,1,0,5,'bwlow', 0);
        end
        
        [wx wy]   = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        
        DU = wxx + wyy;
        
        %%%%%%% for noise correction
        N = smooth3(U,'gaussian',[3 3 1]) - U;
        [wx wy]   = gradient(N,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        DN = wxx + wyy;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        numer_phi = numer_phi + real(DU).*real(U) + imag(DU).*imag(U);
        denom_phi = denom_phi + abs(DU).*abs(U);
        numer_phi_noise = numer_phi_noise + real(DN).*real(N) + imag(DN).*imag(N);
        denom_phi_noise = denom_phi_noise + abs(DN).*abs(N);
        
        % ABSG
        % 1) Noise correction
        numer_G = numer_G + 1000*om(kf).^2.*(abs(U)-abs(N));
        denom_G = denom_G + abs(DU) - abs(DN);
        % 2) Without Noise correction
        numer_G_withoutnoisecorr = numer_G_withoutnoisecorr + 1000*om(kf).^2.*abs(U); % AF
        denom_G_withoutnoisecorr = denom_G_withoutnoisecorr + abs(DU);                % AF
        
        AMP = AMP + abs(U);
        AMPN = AMPN + abs(N);
        
        %%% Teil 2, y-Richtung
        for k_filter=1:size(fUY,3)
            U(:,:,k_filter) = uh_filtspatio2d(fUY(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],lowpassthreshold,1,0,5,'bwlow', 0);
        end
        
        [wx wy]   = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        
        DU = wxx + wyy;
        
        %  %%%%%% for noise correction
        N = smooth3(U,'gaussian',[3 3 1])-U;
        [wx wy]   = gradient(N,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp] = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy] = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
        
        DN = wxx + wyy;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        numer_phi = numer_phi+ real(DU).*real(U)+imag(DU).*imag(U);
        denom_phi = denom_phi+ abs(DU).*abs(U);
        numer_phi_noise = numer_phi_noise + real(DN).*real(N)+imag(DN).*imag(N);
        denom_phi_noise = denom_phi_noise + abs(DN).*abs(N);
        
        % ABSG
        % 1) Noise correction
        numer_G = numer_G + 1000*om(kf).^2.*(abs(U)-abs(N));
        denom_G = denom_G + abs(DU) - abs(DN);
        % 1) Without Noise correction
        numer_G_withoutnoisecorr = numer_G_withoutnoisecorr + 1000*om(kf).^2.*abs(U); % AF
        denom_G_withoutnoisecorr = denom_G_withoutnoisecorr + abs(DU);                % AF
        
        AMP=AMP+abs(U);
        AMPN=AMPN+abs(N);
        
    end
end

%delete(h)
%close(h)

denom_phi(denom_phi == 0) = eps;
denom_phi_noise(denom_phi_noise == 0) = eps;
denom_G(denom_G == 0) = eps;

PHIN = acos(-numer_phi_noise./denom_phi_noise);
corr_phi=mean(PHIN(PHIN < 0.4));

PHI = acos(-numer_phi./denom_phi)-corr_phi;
ABSG = numer_G./denom_G;
WtoN=cat(1,WtoN_freq_Ux,WtoN_freq_Uy);
A=cat(1,A_Ux,A_Uy);

PHI_WITHOUTNOISE = acos(-numer_phi./denom_phi);
ABSG_WITHOUTNOISE = numer_G_withoutnoisecorr./denom_G_withoutnoisecorr;

end