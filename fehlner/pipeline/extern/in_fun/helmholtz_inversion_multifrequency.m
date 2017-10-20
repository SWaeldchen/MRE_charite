function [WAVES MODUL gr gi]=helmholtz_inversion_multifrequency(complex_waves,BW)

% [WAVES MODUL gr gi]=helmholtz_inversion_multifrequency(complex_waves,BW)

% pixel spacing

dx=192/128/1000;

% filter brain

f2=[0.02 0.015 0.011 0.01];
f1=[0.18 0.12   0.1   0.1];

WAVES=[];
MODUL=[];

% Grenzwerte zur Mittelung
    clim1=0.1;
    clim2=200;
    glim1=0.1;
    glim2=200;

    
    
    omega=[25 37.5 50 62.5]*2*pi;
    rho=1000;
    W=complex_waves;
    
    BW_filt=imdilate(BW,strel('disk',5));
    BW_filt=imfill(BW_filt,'holes');
    
    for K=1:4
        
     
    Wf = uh_filtspatio2d(W(:,:,K).*BW_filt,[dx; dx],1/f2(K),5,1/f1(K),5, 'bwbwband', 0);
    WAVES(:,:,K)=Wf; 
    
    [wx, wy]   = gradient(Wf,dx,dx);
    [wxx, wxy] = gradient(wx,dx,dx);
    [wyx, wyy] = gradient(wy,dx,dx);

    DW = wxx + wyy;

    warning('off')
    
    G = -rho*omega(K)^2*Wf./DW;
    MODUL(:,:,K)=G;

    G(find(real(G)<0))=NaN;
    G(find(imag(G)<0))=conj(G(find(imag(G)<0)));

    Gr=real(G);
    Gi=imag(G);

    Gr(isnan(Gr))=0;
    Gi(isnan(Gi))=0;
     
    c_helm = sqrt(1/rho)*1./real(1./sqrt(G));
    gam_helm = abs(omega(K)*sqrt(rho)*imag(1./sqrt(G)));

    c_helm(isnan(c_helm))=0;
    gam_helm(isnan(gam_helm))=0;
    
 
     cm=median(c_helm(BW & c_helm > clim1 & c_helm < clim2));
     gm=median(gam_helm(BW & gam_helm > glim1 & gam_helm < glim2));
    
    G = rho*omega(K)^2/((omega(K)/cm - i * gm)^2);
    gr(K)=real(G);
    gi(K)=imag(G);
   
    
    end
    
  
