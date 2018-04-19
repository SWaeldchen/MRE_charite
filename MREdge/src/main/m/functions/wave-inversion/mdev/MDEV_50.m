function [ABSG PHI AMP]=MDEV(W_wrap,freqs,Nf,Nc,pixel_spacing)

%[ABSG PHI AMP AMPN]=evalmmre_mat(W_wrap,freqs,Nf,Nc,pixel_spacing)
% W_wrap(rows,columns,slices,time,comps,freqs)
% [ABSG PHI]=evalmmre_mat(W_wrap,[70 80 70 60 90 100],2:4,1:3,[3 3]/1000);
% i.s. 26.11.13 


lowpassthreshold=50;

Nt=size(W_wrap,4);
                
om=freqs*2*pi;
numer_phi=0;
denom_phi=0;
numer_G=0;
denom_G=0;
AMP=0;


h = waitbar(0,['eval MMRE: ' num2str(length(find(Nf))) ' freqs, ' num2str(length(find(Nc))) ' comps']);
inc=0;
 for kf=Nf
     for kc=Nc
        for kt=1:Nt
        inc=inc+1; 
        waitbar(inc/(length(Nf)*Nt*length(Nc)),h)
    
        PHI=angle(smooth3(exp(1i*W_wrap(:,:,:,kt,kc,kf)),'gaussian',[5 5 1]));
 
        [PHIX PHIY]=gradient(exp(1i*PHI));
  
        UX(:,:,:,kt)=imag(PHIX.*exp(-1i*PHI));
        UY(:,:,:,kt)=imag(PHIY.*exp(-1i*PHI));
 
        end
        
        fUX=fft(UX,[],4);
        fUY=fft(UY,[],4); 
        

%%%%%% inversion %%%%%%%%%%%%%
 
        
        for k_filter=1:size(fUX,3)
           U(:,:,k_filter) = uh_filtspatio2d(fUX(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],lowpassthreshold,1,0,5, 'bwlow', 0);
        end
        
        
        
        
        [wx wy]     = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp]   = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy]   = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    
        DU=wxx+wyy;

        
        numer_phi=numer_phi+ real(DU).*real(U)+imag(DU).*imag(U);
        denom_phi=denom_phi+ abs(DU).*abs(U);

         
         numer_G=numer_G + 1000*om(kf).^2.*abs(U);
         denom_G=denom_G + abs(DU);
        
        AMP=AMP+abs(U);
       

         for k_filter=1:size(fUY,3)
           U(:,:,k_filter) = uh_filtspatio2d(fUY(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],lowpassthreshold,1,0,5, 'bwlow', 0);
         end
          
        [wx wy]     = gradient(U,pixel_spacing(1),pixel_spacing(2),1);
        [wxx tmp]   = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        [tmp wyy]   = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    
        DU=wxx+wyy;


        numer_phi=numer_phi+ real(DU).*real(U)+imag(DU).*imag(U);
        denom_phi=denom_phi+ abs(DU).*abs(U);
 
  
         numer_G=numer_G + 1000*om(kf).^2.*abs(U);
         denom_G=denom_G + abs(DU);
        
        AMP=AMP+abs(U);
     

     end
 end
 
delete(h)
 
denom_phi(denom_phi == 0) = eps;
denom_G(denom_G == 0) = eps;

PHI = acos(-numer_phi./denom_phi);
ABSG = numer_G./denom_G;
