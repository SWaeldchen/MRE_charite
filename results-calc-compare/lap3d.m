function [ output ] = lap3( input )

laplacian = getLap();
output = convn(input, laplacian, 'same');

end

