function [C1 C2 C3 XX YY ZZ]=curl_wrapped(X,Y,Z,dx,dy,dz,filt)
%
% [C1 C2 C3]=curl_wrapped(X,Y,Z,dx,dy,dz,filt)
% filt ='' no filter, matlab gradients
% filt =[5 5 5] smooth3-filter, gaussian with [5 5 5]-kernel
% filt = 'anderssen1' multi-dimensional gradient-scheme of anderssen et al. with +-1 pixel neighborhood 
% filt = 'anderssen2' multi-dimensional gradient-scheme of anderssen et al. with +-2 pixel neighborhood 
% ...
%
% last modified: 31.05.2012 by is


if nargin < 7
    filt = 'no';
end

if ~ischar(filt)
    filt_size=filt;
    filt='smooth3';
end

for ks=1:size(X,4)

    switch filt
        case 'no'
        fprintf('.')

        phasX=angle(exp(i*X(:,:,:,ks)));
        phasY=angle(exp(i*Y(:,:,:,ks)));
        phasZ=angle(exp(i*Z(:,:,:,ks)));

        case 'smooth3'
        fprintf('f')
        phasX=angle(smooth3(exp(i*X(:,:,:,ks)),'gaussian',filt_size));
        phasY=angle(smooth3(exp(i*Y(:,:,:,ks)),'gaussian',filt_size));
        phasZ=angle(smooth3(exp(i*Z(:,:,:,ks)),'gaussian',filt_size));
    end

    if isempty(findstr(filt,'anderssen'))

        [XX(:,:,:,ks) XY XZ]=gradient(exp(i*phasX),dx,dy,dz);
        [YX YY(:,:,:,ks) YZ]=gradient(exp(i*phasY),dx,dy,dz);
        [ZX ZY ZZ(:,:,:,ks)]=gradient(exp(i*phasZ),dx,dy,dz);

    else

        filt_size=str2num(strrep(filt,'anderssen',''));
        fprintf(num2str(filt_size))

        phasX=angle(exp(i*X(:,:,:,ks)));
        phasY=angle(exp(i*Y(:,:,:,ks)));
        phasZ=angle(exp(i*Z(:,:,:,ks)));

        [XX(:,:,:,ks) XY XZ]=gradient_anderssen(exp(i*phasX),filt_size,'mean',dx,dy,dz);
        [YX YY(:,:,:,ks) YZ]=gradient_anderssen(exp(i*phasY),filt_size,'mean',dx,dy,dz);
        [ZX ZY ZZ(:,:,:,ks)]=gradient_anderssen(exp(i*phasZ),filt_size,'mean',dx,dy,dz);
    end

    C1(:,:,:,ks)=imag(exp(-i*phasZ).*ZY)-imag(exp(-i*phasY).*YZ);
    C2(:,:,:,ks)=imag(exp(-i*phasX).*XZ)-imag(exp(-i*phasZ).*ZX);
    C3(:,:,:,ks)=imag(exp(-i*phasY).*YX)-imag(exp(-i*phasX).*XY);

    XX(:,:,:,ks)=imag(exp(-i*phasX).*XX(:,:,:,ks));
    YY(:,:,:,ks)=imag(exp(-i*phasY).*YY(:,:,:,ks));
    ZZ(:,:,:,ks)=imag(exp(-i*phasZ).*ZZ(:,:,:,ks));

end