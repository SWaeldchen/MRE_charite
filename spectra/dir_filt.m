function [U_filt] = dir_filt(U)

sz = size(U);
% filters need to be in your MATLAB / Octave path
filts = load('dir_filters.mat', 'dir_filters');
temp_slc = U(:,:,1,1,1);
[~, mask] = lowpass_butter_2d(temp_slc, 4, 0.4);
sz_filt = ones(1, 5);
if numel(sz) == 4
    d5 = 1;
    sz_filt(1:4) = sz;
else
    d5 = sz(5);
    sz_filt = sz;
end
sz_filt(5) = 8*d5; % expand fifth dimension
U_filt = zeros(sz_filt);

for n = 1:d5
	for p = 1:8
		index = (n-1)*8 + p;
		for m = 1:sz(4)
			for k = 1:sz(3)
				U_temp = U(:,:,k,m,n);
				U_temp(isnan(U_temp)) = 0; % just in case
				U_temp_fft = fftshift(fft2(U_temp));
                filt_temp = imresize(filts.dir_filters(:,:,p), [sz(1) sz(2)]) .* mask;
				U_temp_fft_filt = U_temp_fft .* filt_temp;
				U_temp_filt = ifft2(ifftshift(U_temp_fft_filt)); 
				%U_filt(:,:,k,m,index) = lowpass_butter_2d(U_temp_filt, 4, 0.4);
				U_filt(:,:,k,m,index) = U_temp_filt;
			end
		end
	end
end

end

