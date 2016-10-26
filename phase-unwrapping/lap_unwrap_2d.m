function [unw] = lap_unwrap_2d(image)

U6D = ESP.Unwrapper6D(4);
sz = size(image);
quarter = round(sz/4);
unw = zeros(size(image));
for m = 1:sz(3)
    for n = 1:sz(4)
        for p = 1:sz(5)
            for q = 1:sz(6)
                unwrap_temp = U6D.unwrapNoCorrect(image(:,:,m,n,p,q));
                sample = unwrap_temp(quarter(1):end-quarter(1),quarter(2):end-quarter(2));
                unwrap_temp = unwrap_temp - mean2(sample);
                unw(:,:,m,n,p,q) = unwrap_temp;
            end
        end
    end
end
%unw = fft(unw, [], 4);
%unw = squeeze(unw(:,:,:,2,:,:));