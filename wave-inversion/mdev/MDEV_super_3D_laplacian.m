function [ABSG, PHI, AMP]=MDEV_super(W_wrap,freqs,Nf,Nc,pixel_spacing, super_factor)

%[ABSG PHI AMP AMPN]=MDEV(W_wrap,freqs,Nf,Nc,pixel_spacing)
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
pixel_spacing = pixel_spacing / super_factor;
laplacian = zeros(3,3,3);
   laplacian(:,:,1) = [0 0 0; 0 1 0; 0 0 0];
   laplacian(:,:,2) = [0 1 0; 1 -6 1; 0 1 0];
   laplacian(:,:,3) = laplacian(:,:,1);
lap1 = [1 -2 1];
lap2 = lap1';
lap3 = zeros(1,1,3);
lap3(1,1,:) = [1 -2 1];
gz = zeros(1,1,3);
gz(1,1,:) = [1 1 1];


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
        %U = convn(U, gz, 'same');
        
        % Upsample
        U_sup = zeros(size(U,1)*super_factor, size(U,2)*super_factor, size(U,3));
        for n=1:size(U,3)
           U_sup(:,:,n)=imresize(U(:,:,n), super_factor, 'bicubic');
        end
        
        % Remove spurious high frequencies
        s = fspecial('gaussian', [super_factor+1 super_factor+1], super_factor*0.65);
        for n=1:size(U,3)
           U_sup(:,:,n)=conv2(U_sup(:,:,n), s, 'same');
        end
        
        %[wx wy]     = gradient(U_sup,pixel_spacing(1),pixel_spacing(2),1);
        %[wxx tmp]   = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        %[tmp wyy]   = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
       
        %DU=wxx+wyy;
        %DU = convn(U_sup, laplacian, 'same') / (pixel_spacing(1)^2);
        DU1 = convn(U_sup, lap1, 'same') / (pixel_spacing(1)^2);
        DU2 = convn(U_sup, lap2, 'same') / (pixel_spacing(1)^2);
        DU3 = convn(U_sup, lap3, 'same') / ((pixel_spacing(1)*super_factor)^2);
        DU = DU1 + DU2 + DU3;
        numer_phi=numer_phi+ real(DU).*real(U_sup)+imag(DU).*imag(U_sup);
        denom_phi=denom_phi+ abs(DU).*abs(U_sup);

         
         numer_G=numer_G + 1000*om(kf).^2.*abs(U_sup);
         denom_G=denom_G + abs(DU);
        
        AMP=AMP+abs(U_sup);
       

        for k_filter=1:size(fUY,3)
           U(:,:,k_filter) = uh_filtspatio2d(fUY(:,:,k_filter,2),[pixel_spacing(1); pixel_spacing(2)],lowpassthreshold,1,0,5, 'bwlow', 0);
        end
        %U = convn(U, gz, 'same');
        
        % Upsample
        U_sup = zeros(size(U,1)*super_factor, size(U,2)*super_factor, size(U,3));
        for n=1:size(U,3)
           U_sup(:,:,n)=imresize(U(:,:,n), super_factor, 'bicubic');
        end
        
        % Remove spurious high frequencies
        s = fspecial('gaussian', [super_factor+1 super_factor+1], super_factor*0.65);
        for n=1:size(U,3)
           U_sup(:,:,n)=conv2(U_sup(:,:,n), s, 'same');
        end
          
        %[wx wy]     = gradient(U_sup,pixel_spacing(1),pixel_spacing(2),1);
        %[wxx tmp]   = gradient(wx,pixel_spacing(1),pixel_spacing(2),1);
        %[tmp wyy]   = gradient(wy,pixel_spacing(1),pixel_spacing(2),1);
    
        %DU=wxx+wyy;
        %DU = convn(U_sup, laplacian, 'same') / (pixel_spacing(1)^2);
        DU1 = convn(U_sup, lap1, 'same') / (pixel_spacing(1)^2);
        DU2 = convn(U_sup, lap2, 'same') / (pixel_spacing(1)^2);
        DU3 = convn(U_sup, lap3, 'same') / ((pixel_spacing(1)*super_factor)^2);
        DU = DU1 + DU2 + DU3;

        numer_phi=numer_phi+ real(DU).*real(U_sup)+imag(DU).*imag(U_sup);
        denom_phi=denom_phi+ abs(DU).*abs(U_sup);
 
  
         numer_G=numer_G + 1000*om(kf).^2.*abs(U_sup);
         denom_G=denom_G + abs(DU);
        
        AMP=AMP+abs(U_sup);
     

     end
 end
 
delete(h)
 
denom_phi(denom_phi == 0) = eps;
denom_G(denom_G == 0) = eps;

PHI = acos(-numer_phi./denom_phi);
ABSG = numer_G./denom_G;
