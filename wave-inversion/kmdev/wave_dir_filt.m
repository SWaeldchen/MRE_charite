
function filteredWaveField = wave_dir_filt( waveField, mask, res, freqvec, rho, theta, J)

%MAG_THRESH = 75;
%mag_mean = mean(resh(magnitude,4),4);
%mask = double(mag_mean > MAG_THRESH);

% get the dimensions
n1 = size(waveField,1);% number of rows
n2 = size(waveField,2);% number of columns

nSlice = size(waveField,3);% number of slices
nComponent = size(waveField,4);% number of components
nFrequency = size(waveField,5);% number of frequencies

%-- WAVELETS
[h0, h1, g0, g1] = daubf(3);
WAVELET_LENGTH = size(h0,1);
n1_img = n1;
n2_img = n2;
for j = 1:J
    n1_img = n1_img + (WAVELET_LENGTH-1)*2^(j-1);
    n2_img = n2_img + (WAVELET_LENGTH-1)*2^(j-1);
end
if isempty(mask)
    mask = zeros(size(waveField,1), size(waveField,2), size(waveField,3));
    for z = 1:size(mask,3)
        mask(:,:,z) = middle_circle(mask(:,:,z));
    end
    mask = double(mask);
end

% calculate the wavenumber for k-space filtering
k1 = -( (0:n1_img-1)-fix(n1_img/2) ) / (n1_img*res(1)) * 2*pi;%[rad/m] wavenumber in 1st direction
k2 =  ( (0:n2_img-1)-fix(n2_img/2) ) / (n2_img*res(2)) * 2*pi;%[rad/m] wavenumber in 2nd direction
[t, r] = cart2pol( ones(n1_img,1)*k2, k1'*ones(1,n2_img) );% transform to polar coordinates



% calculate directional filter
switch theta.flag
    case 'on'
        
        nTheta = round( 2*pi / theta.sigma );% number of directions
        if nTheta > 1 % at least two directions
            
            % calculate the angles of directions
            thetaValue= 2*pi * linspace( 0, 1-1/nTheta, nTheta);%[rad] 
            
            filterFunctTheta = zeros( n1_img ,n2_img , nTheta );
            for iTheta = 1 : nTheta % loop over directions
                currentThetaValue = thetaValue( iTheta );%[rad] selected theta value
                currentTheta = imag(log( exp( 1i * (t-currentThetaValue) ) ));%[rad] rotated theta
                filterFunctTheta(:,:,iTheta) = exp( -1/2 * ( currentTheta/theta.sigma ).^2 );% gaussian function with selected theta
            end
            
        else % no directional filtering
            nTheta = 1;% number of directions set to 1
            filterFunctTheta = ones( n1, n2 );% directional filter are isotropic
        end
        
    otherwise % no directional filtering
        nTheta = 1;% number of directions set to 1
        filterFunctTheta = ones( n1, n2 );% directional filter are isotropic
end



filteredWaveField = zeros( n1 ,n2 , nSlice, nTheta, nComponent, nFrequency );
for iFrequency = 1 : nFrequency % loop over frequencies
    disp(iFrequency)
    currentFrequency=freqvec(iFrequency);%[Hz] selected frequency
    
    % calculate radial filter
    switch rho.method
        case 'diff'% linear high pass (equivalent to gradient in space)
            filterRho = rho;
        case 'gauss'% gauss filter in k-space
            filterRho = exp( -1/2 * (rho.value*rho).^2 );
        case 'gaussC'% gauss filter in c-space
            sigmaHP = rho.valueHP/(2*pi*currentFrequency);%[m] hight pass value for constant shear wave speed filter
            filterRho = exp( -1/2 *( 1./(rho*sigmaHP)).^2);% gaussian filter in c-space
            filterRho( rho==0 ) = 0;% replace the inf in the center to 0
       	case 'fermi'% fermi filter in k-space
            kBT = currentFrequency / rho.value;%[1/m] hight pass value in k-space
            filterRho = 2 ./ ( exp(-2*rho/kBT) + 1) - 1;
        case 'diffgauss'% function: derivative of gauss with constant k
            filterRho = rho.value * rho .* exp( 1/2 * (1-(rho.value*rho).^2) );
        case 'symetric'% symetric gauss filter for k and c-space
            sigmaLP = rho.valueLP;%[m] low pass value in k-space
            sigmaHP = rho.valueHP/(2*pi*currentFrequency);%[m] hight pass value for constant shear wave speed filter
            filterRho = exp( -1/2 * (rho*sigmaLP).^2) .* exp( -1/2 *( 1./(rho*sigmaHP)).^2);% symetric filter for k and c
            filterRho( rho==0 ) = 0;% replace the inf in the center to 0
        case 'butter'
            cut = 15;
            filterRho = 1./(  1+( rho ./ (rho + cut) ).^8  );
            filterRho = 1 - filterRho;
        otherwise
            filterRho = ones( n1_img, n2_img );% radial filter constant
    end
    
    
    
    % create the combined filter
    filter = repmat(filterRho,[1 1 nTheta]) .* filterFunctTheta;
    
  
    assignin('base', 'dir_filters', filter);
    
    
    
    % main filter process
    
   parfor iComponent = 1 : nComponent
        disp(iComponent)
        for iTheta = 1 : nTheta % for all directions
            for iSlice = 1 : nSlice
                slice = waveField(:, :, iSlice, iComponent, iFrequency) ;% complex wave field for the current frequency
                slc_mask = mask(:,:,iSlice);
                noise_est = mad_est_2d(slice, slc_mask);
                %LAMBDA_COEFF = 0.25;
                %lambda = LAMBDA_COEFF*noise_est;
                % DIRECTIONAL FILTER OF SCALING COEFFICIENTS
                f = filter(:,:,iTheta);
                f(f == 0) = eps;
                w = udwt2D(slice, J, h0, h1);
                fourierWF = fftshift( fft2(w{J+1}) );% in-plane fourier transformation
                filteredFourierWF = fourierWF .* normalize_image(f);% filtering
                w{J+1} = ifft2(ifftshift(filteredFourierWF));
                % SPARSITY PROMOTION OF WAVELET COEFFICIENTS
                NOISE_FAC = sqrt(2);
                for j = 1:J
                    for n = 1:3
                        %w{j}{n} = ogs2(w{j}{n}, 3, 3, lambda, 'atan', 1, 40);
                        w{j}{n} = nng(w{j}{n}, NOISE_FAC*noise_est);
                    end
                end
                v = iudwt2D(w, J, g0, g1);
                filteredWaveField(:, :, iSlice, iTheta, iComponent, iFrequency) = v;% inverse fft
            end
        end % loop over components
    end % loop over slices
    
end % loop over frequencies

end
