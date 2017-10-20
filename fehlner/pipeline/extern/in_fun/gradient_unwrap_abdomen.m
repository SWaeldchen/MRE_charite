function gradient_unwrap_abdomen(W_wrap,pixel_spacing)
%
%  gradient_unwrap_abdomen(W_wrap)
%  gradient_unwrap_abdomen(W_wrap,pixel_spacing)
%  pixel_spacing in m!
%  W_wrap(:,:,:,time,comps: 1SS2PE[Y]RO[X], freqs)
%  from import_wrap_3Dfield
%i.s. 18.2.2013

filt = '2';

if nargin < 2
load dxdy
load dz
pixel_spacing=[dxdy(1) dxdy(2) dz]/1000;
end



for k1=1:size(W_wrap,6)
 

    [C1 C2 C3 XX YY ZZ]=curl_wrapped(-W_wrap(:,:,:,:,3,k1),W_wrap(:,:,:,:,2,k1),W_wrap(:,:,:,:,1,k1),pixel_spacing(1),pixel_spacing(2),-pixel_spacing(3),['anderssen' filt]);
    
    fC1=fft(C1,[],4);
    fC2=fft(C2,[],4);
    fC3=fft(C3,[],4);
    fDIV=fft(XX+YY+ZZ,[],4);
    
    tmp=animate(w3D2w2D(fC1(:,:,:,2)),16);
    close all
    ca=[-1 1]*max(abs(tmp(:)))/4;
    for kt=1:16
        plot2dwaves(tmp(:,:,kt));
        colormap gray
        caxis(ca)
    end
    openfigs2gif(0.1,['C1_' num2str(k1) '.gif'])
  
    
    tmp=animate(w3D2w2D(fC2(:,:,:,2)),16);
    close all
    ca=[-1 1]*max(abs(tmp(:)))/4;
    for kt=1:16
        plot2dwaves(tmp(:,:,kt));
        colormap gray
        caxis(ca)
    end
    openfigs2gif(0.1,['C2_' num2str(k1) '.gif'])
    
    tmp=animate(w3D2w2D(fC3(:,:,:,2)),16);
    close all
    ca=[-1 1]*max(abs(tmp(:)))/4;
    for kt=1:16
        plot2dwaves(tmp(:,:,kt));
        colormap gray
        caxis(ca)
    end
    openfigs2gif(0.1,['C3_' num2str(k1) '.gif'])    
    
    tmp=animate(w3D2w2D(fDIV(:,:,:,2)),16);
    close all
    ca=[-1 1]*max(abs(tmp(:)))/4;
    for kt=1:16
        plot2dwaves(tmp(:,:,kt));
        colormap gray
        caxis(ca)
    end
    
    openfigs2gif(0.1,['DIV_' num2str(k1) '.gif'])    
    
    
    
    close all
    
    
    CURLDIV(:,:,:,1,k1)=fC1(:,:,:,2);
    CURLDIV(:,:,:,2,k1)=fC2(:,:,:,2);
    CURLDIV(:,:,:,3,k1)=fC3(:,:,:,2);
    CURLDIV(:,:,:,4,k1)=fDIV(:,:,:,2);

    save('CURLDIV','CURLDIV')
end


    
    