function absg = helm_inv_rg(U, freqvec, spacing)
% frequencies in Hertz
RHO = 1000;
if nargin < 4
    ndims = 3;
end

sz = size(U);
if numel(sz) < 5
    d5 = 1;
else
    d5 = sz(5);
end
if numel(sz) < 4
    d4 = 1;
else
    d4 = sz(4);
end       
numerator = zeros(sz(1:3)-2);
denominator = zeros(sz(1:3)-2);

for m = 1:d4
    for n = 1:d5
        U_temp = U(:,:,:,m,n);
        [U_temp, U_lap] = get_laplacian_image(U_temp, spacing);
        % use field magnitudes -- much better behaved than complex fields
        numerator = numerator + abs(U_temp).*RHO.*(2*pi*freqvec(n)).^2;
        denominator = denominator + abs(U_lap);
    end
end

absg = numerator ./ denominator;

end


function [U, laplacian_image] = get_laplacian_image(U, spacing)
    [dU, ~] = gradestim4d(U,spacing);
    [dUx2, ~] = gradestim4d(dU(:,:,:,2), spacing);
    [dUy2, ~] = gradestim4d(dU(:,:,:,3), spacing);
    [dUz2, ~] = gradestim4d(dU(:,:,:,1), spacing);
    Uxx = dUx2(:,:,:,2);
    Uyy = dUy2(:,:,:,1);
    Uzz = dUz2(:,:,:,3);
    laplacian_image = Uxx + Uyy + Uzz;
    U = U(2:end-1, 2:end-1, 2:end-1);
end