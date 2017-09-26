function absg = helm_inv(U, freqvec, spacing, ndims)
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
numerator = zeros(sz);
denominator = zeros(sz);
k = get_kernel(ndims, spacing);

for m = 1:d4
    for n = 1:d5
        U_temp = U(:,:,:,m,n);
        U_lap = get_laplacian_image(U_temp, k, ndims);
        % use field magnitudes -- much better behaved than complex fields
        numerator = numerator + abs(U_temp).*RHO.*(2*pi*freqvec(n)).^2;
        denominator = denominator + abs(U_lap);
    end
end

absg = numerator ./ denominator;

end

function k = get_kernel(ndims, spacing)
    switch ndims
        case 2
            k{1} = [1 -2 1];
            k{2} = k{1}';
            k{1} = k{1} / spacing(1)^2;
            k{2} = k{2} / spacing(2)^2;
        case 3
            k{1} = [1 -2 1];
            k{2} = k{1}';
            k{3} = zeros(1, 1, 3);
            k{3}(:) = k{1};
            k{1} = k{1} / spacing(1)^2;
            k{2} = k{2} / spacing(2)^2;
            k{3} = k{3} / spacing(3)^2;
    end
end

function laplacian_image = get_laplacian_image(U, k, ndims)
% split into three convolutions to handle anisotropy
    U_lap_1 = convn(U, k{1}, 'same');
    U_lap_2 = convn(U, k{2}, 'same');
    if ndims == 3
        U_lap_3 = convn(U, k{3}, 'same');
    else
        U_lap_3 = zeros(size(U_lap_2));
    end
    laplacian_image = U_lap_1 + U_lap_2 + U_lap_3;
end