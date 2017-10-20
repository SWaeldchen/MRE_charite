
function U_den = dtdenoise_xy(U, J, snr, curlFlag) 
    sz = size(U);
    denR = zeros(size(U));
    denI = zeros(size(U));
    if (numel(sz) < 4)
		d4 = 1;
	else 
		d4 = sz(4);
    end
    pad1 = nextpwr2(sz(1));
    pad2 = nextpwr2(sz(2));
    padMax = max(pad1, pad2);
    for m = 1:d4
        for k = 1:size(U,3)
            for jiggerY = 0:3
                for jiggerX = 0:3
                    U_temp = circshift(simplepad(U(:,:,k,m), [padMax, padMax]), [jiggerY jiggerX]);
                    snr_temp = circshift(simplepad(snr(:,:,k,m), [padMax, padMax]), [jiggerY jiggerX]);
                    %denR_temp = DT_2D_snr(real(U_temp), snr_temp, J);
                    %denI_temp = DT_2D_snr(imag(U_temp), snr_temp, J);
                    denR_temp = DT_2D(real(U_temp), J);
                    denI_temp = DT_2D(imag(U_temp), J);
                    denR_temp = circshift(denR_temp, [-jiggerY -jiggerX]);
                    denI_temp = circshift(denI_temp, [-jiggerY -jiggerX]);
                    denR(:,:,k,m) = denR(:,:,k,m) + denR_temp(1:sz(1), 1:sz(2), :);
                    denI(:,:,k,m) = denI(:,:,k,m) + denI_temp(1:sz(1), 1:sz(2), :);
                end
            end
        end
    end
    U_den = (denR + 1i*denI) ./ 16;
end


function U_den = dtdenoise_xy_lam(U) 
    sz = size(U);
    denR = zeros(size(U));
    denI = zeros(size(U));
    midpts = sz ./ 2;
    for m = 1:sz(4)
        nl_est = 0;
        for k = 1:size(U,3)
            sample_square = U(midpts(1)-20:midpts(1)+20,midpts(2)-20:midpts(2)+20,k,m);
            sample_square = sample_square - min(sample_square(:));
            nl_est = nl_est + NLEstimate(sample_square);
        end
        nl_est = nl_est / size(U,3);
        for k = 1:size(U,3)
            lambda = 0.3*nl_est;
            for jiggerY = 0:3
                for jiggerX = 0:3
                    U_temp = circshift(U(:,:,k,m), [jiggerY jiggerX]);
					size(U_temp)
                    denR_temp = DT_2D(real(U_temp), lambda);
                    denI_temp = DT_2D(imag(U_temp), lambda);
                    denR_temp = circshift(denR_temp, [-jiggerY -jiggerX]);
                    denI_temp = circshift(denI_temp, [-jiggerY -jiggerX]);
                    denR(:,:,k,m) = denR(:,:,k,m) + denR_temp;
                    denI(:,:,k,m) = denI(:,:,k,m) + denI_temp;
                end
            end
        end
    end
    U_den = (denR + 1i*denI) ./ 16;
end


