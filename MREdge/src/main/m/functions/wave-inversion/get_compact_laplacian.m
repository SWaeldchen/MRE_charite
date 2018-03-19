
function U_laplacian = get_compact_laplacian(U, spacing, twoD)

if ndims(U) == 5
    U_laplacian = get_compact_laplacian_5d(U, spacing, twoD);
elseif ndims(U) == 4
    U_laplacian = get_compact_laplacian_4d(U, spacing, twoD);
elseif ndims(U) == 3
    U_laplacian = get_compact_laplacian_3d(U, spacing, twoD);
else
    display('5d max for this function');
end

end

function U_laplacian = get_compact_laplacian_5d(U, spacing, twoD) 
        U_laplacian = zeros(size(U));
        for n = 1:size(U, 5)
            temp = get_compact_laplacian_4d(U(:,:,:,:,n), spacing, twoD);
            U_laplacian(:,:,:,:,n) = temp;
        end
end


function U_laplacian = get_compact_laplacian_4d(U, spacing, twoD)
    U_laplacian = zeros(size(U));
    if (nargin < 3)
        twoD = 0;
    end
    if (twoD == 0)
        lap1 = [1 -2 1];
        lap2 = [1 -2 1]';
        lap3 = zeros(3,3,3);
        lap3(2,2,:) = [1 -2 1];
        for n = 1:size(U,4)
            vol = U(:,:,:,n);
            U_lap1 = convn(vol, lap1, 'same') / spacing(1).^2;
            U_lap2 = convn(vol, lap2, 'same') / spacing(2).^2;
            U_lap3 = convn(vol, lap3, 'same') / spacing(3).^2;
            U_laplacian(:,:,:,n) = U_lap1+U_lap2+U_lap3;
        end
    else 
        lap = [0 1 0; 1 -4 1; 0 1 0] / (spacing(1)*spacing(2));
        for n = 1:size(U,4)
            vol = U(:,:,:,n);
            U_lap = convn(vol, lap, 'same');
            U_laplacian(:,:,:,n) = U_lap;
        end
    end
end

function U_laplacian = get_compact_laplacian_3d(U, spacing, twoD)
    if (nargin < 3)
        twoD = 0;
    end
    if (twoD == 0)
        lap1 = [1 -2 1];
        lap2 = [1 -2 1]';
        lap3 = zeros(3,3,3);
        lap3(2,2,:) = [1 -2 1];
        U_lap1 = convn(U, lap1, 'same') / spacing(1).^2;
        U_lap2 = convn(U, lap2, 'same') / spacing(2).^2;
        U_lap3 = convn(U, lap3, 'same') / spacing(3).^2;
        U_laplacian = U_lap1+U_lap2+U_lap3;
    else 
        lap = [0 1 0; 1 -4 1; 0 1 0] / (spacing(1)*spacing(2));
            U_laplacian = convn(U, lap, 'same');
    end
end


