
function U_laplacian = laplacian_image(U, spacing, ndims, ord, iso)

if nargin < 5
    if unique(spacing) == 1
        iso = 1;
    else
        iso = 0;
    end
    if nargin < 4
        ord = 4;
    end
end

if unique(spacing) > 1 & iso == 1
   disp('Laplacian image ERROR: with isotropic spacing, laplacian must be separable not isotropic');
   return;
end

if ~ismember(ndims, [2 3])
    disp('Laplacian image ERROR: only 2 or 3 dimensional Laplacians are supported');
    return;
end

if ~ismember(ord, [2 4])
    disp('Laplacian image ERROR: 2nd or 4th order Laplacians are supported');
    return;
end

c = get_kernel(ndims, ord, iso);

if iso
    U_laplacian = convn(U, c{1}, 'same') ./ spacing(1)^2;
else
    U_lap_1 = convn(U, c{1}, 'same') ./ spacing(1)^2;
    U_lap_2 = convn(U, c{2}, 'same') ./ spacing(2)^2;
    if ndims == 3
        U_lap_3 = convn(U, c{3}, 'same') ./ spacing(3)^2;
    else
        U_lap_3 = zeros(size(U_lap_2));
    end
    U_laplacian = U_lap_1 + U_lap_2 + U_lap_3;
end
    

end

function c= get_kernel(ndims, ord, iso)
    switch ndims
        case 2
            switch ord
                case 2
                    switch iso
                        case 0
                            c{1} = [1 -2 1];
                            c{2} = c{1}';
                        case 1
                            c1 = 1/6; c2 = 2/3; c3 = -10/3;
                            c{1} = [c1 c2 c1; c2 c3 c2; c1 c2 c1];
                    end
                case 4
                    switch iso
                        case 0
                            c{1} = [-1/12 4/3 -5/2 4/3 -1/12];
                            c{2} = c{1};
                        case 1
                            c1 = 0; c2 = -1/30; c3 = -1/60; c4 = 4/15; c5 = 13/15; c6 = -21/5; 
                            c{1} = [c1 c2 c3 c2 c1; ...
                                    c2 c4 c5 c4 c2; ...
                                    c3 c5 c6 c5 c3; ...
                                    c2 c4 c5 c4 c2; ...
                                    c1 c2 c3 c2 c1];
                    end
            end
        case 3
            switch ord
                case 2
                    switch iso
                        case 0
                            c{1} = [1 -2 1];
                            c{2} = c{1}';
                            c{3} = zeros(1, 1, 3);
                            c{3}(:) = c{1};
                        case 1
                            c1 = 0; c2 = 1/6; c3 = 1/3; c4 = -4;
                            c{1} = cat(3, [c1 c2 c1; c2 c3 c2; c1 c2 c1], ...
                                          [c2 c3 c2; c3 c4 c3; c2 c3 c2], ...
                                          [c1 c2 c1; c2 c3 c2; c1 c2 c1] );
                    end
                case 4
                    switch iso
                        case 0
                            c{1} = [-1/12 4/3 -5/2 4/3 -1/12];
                            c{2} = c{1};
                            c{3} = c{1};
                        case 1
                            % technically 6th order:
                             c1 = 1/33.333; c2 = 3/33.333; c3 = 14/33.333; c4 = -128/33.333;
                            % exactly 4th order:
                            % c1 = 0; c2 = 1/6; c3 = 2/6; c4 = -24/6; 
                            c{1} = cat(3, [c1 c2 c1; c2 c3 c2; c1 c2 c1], ...
                                          [c2 c3 c2; c3 c4 c3; c2 c3 c2], ...
                                          [c1 c2 c1; c2 c3 c2; c1 c2 c1]);
                    end
            end
    end
end
                  
                        







