% filtering the complex MR signal in 2D
% 
% [MRsignalSmoothed] = smoothMRsignal( MRsignal, inplaneResolution, sigma )
% 
% filtering is done by a in-plane radial gaussian funtion with the parameter sigma
% 
% input:
% MRsignal              6D complex MR signal
%                       - 1st and 2nd dimensions correspond to the in-plane matrix
%                         size(number of rows and columns)
% inplaneResolution     pixel spaceing in meters, correspond to the 1st and
%                       2nd dimensions in MRsignal, respectively
% sigma                 filter stength of 2D-gauss smooth in m
% 
% output:
% MRsignalSmoothed      smoothed complex MR signal
%                       MRsignalSmoothed has the same size like MRsignal

% edit by Heiko Tzsch�tzsch, Carit� - Universit�tsmedizin Berlin, Berlin, Germany
% edit: 2015/04/01
% last change: 2015/11/06

function MRsignalSmoothed = smoothMRsignal_BM3D( MRsignal)

% get the dimensions
n1 = size(MRsignal,1);% number of rows
n2 = size(MRsignal,2);% number of columns
nSlice = size(MRsignal,3);% number of slices
nTimestep = size(MRsignal,4);% number of time steps
nComponent = size(MRsignal,5);% number of components
nFrequency = size(MRsignal,6);% number of frequencies


MRsignalSmoothed = zeros( size(MRsignal) );
for iFrequency = 1 : nFrequency
    for iComponent = 1 : nComponent
        for iTimestep = 1 : nTimestep
            for iSlice = 1 : nSlice
                
                tmpMRSignal = MRsignal(:, :, iSlice, iTimestep, iComponent, iFrequency);
				tmpReal = real(tmpMRSignal);
				tmpImag = imag(tmpMRSignal);
				[norm_real, realmax, realmin] = normalize(tmpReal);
				[norm_imag, imagmax, imagmin] = normalize(tmpImag);
                sigma = NLEstimate(norm_real);
				[~, sigSmooth_real_norm] = BM3D(1, dctmask(norm_real), sigma, 'lc');
				[~, sigSmooth_imag_norm] = BM3D(1, dctmask(norm_imag), sigma, 'lc');    
				sigSmooth_real = denormalize(sigSmooth_real_norm, realmax, realmin);
          		sigSmooth_imag = denormalize(sigSmooth_imag_norm, imagmax, imagmin);
                MRsignalSmoothed(:, :, iSlice, iTimestep, iComponent, iFrequency) = sigSmooth_real + 1i*sigSmooth_imag;
            end
        end
    end
end

end

function [normImg, imgMax, imgMin] = normalize(img)
	imgMax = max(img(:));
	imgMin = min(img(:));
	normImg = (img - imgMin) / (imgMax - imgMin) .* 255;
end

function [img] = denormalize(normImg, imgMax, imgMin)
	range = imgMax - imgMin;
	img = normImg * range;
	img = img + imgMin;
end

function [y] = dctmask(x)
    szx = size(x);
    %
    gauss_length = round(szx(1)/3);
    sigma = gauss_length*0.33;
    gauss_vec = exp(-(1:gauss_length).^2 ./ (2*sigma.^2))';
    gauss_mask_1 = repmat(gauss_vec, [1 szx(2)]);
    mask_top = ones(szx(1)-gauss_length, szx(2));
    mask1 = [mask_top; gauss_mask_1];
    %
    gauss_width = round(szx(2)/3);
    sigma = gauss_width*0.33;
    gauss_vec = exp(-(1:gauss_width).^2 ./ (2*sigma.^2));
    gauss_mask_2 = repmat(gauss_vec, [szx(1) 1]);
    mask_left = ones(szx(1), szx(2)-gauss_width);
    mask2 = [mask_left, gauss_mask_2];
    mask = mask1.*mask2;
    x_dct = dct2(x).*mask;
    y = idct2(x_dct);
end
