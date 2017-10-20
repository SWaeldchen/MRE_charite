
function U_den = dtdenoise_xy_elasto(U, lambda)
    if nargin < 2
        %lambda = 0.01*mean(U(U>1000));
		lambda = 100;
    end
    sz = size(U);
    denR = zeros(size(U));
    denI = zeros(size(U));
	midpts = sz ./ 2;
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
                    denR_temp = DT_2D(real(U_temp), lambda);
                    denI_temp = DT_2D(imag(U_temp), lambda);
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


