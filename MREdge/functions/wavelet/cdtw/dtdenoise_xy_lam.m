
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

