function [ result ] = idctNDim( cube )
%IDCTNDIM Summary of this function goes here
%   Detailed explanation goes here


si=size(cube);
nDim=ndims(cube);


switch nDim
    case 1
        result=dct(cube);
    case 2
        result=dct2(cube);
    otherwise
        result=cube;
        for dim=1:nDim
            % 1) reshape cube to two-dimensional matrix 
            % 2) run idct columnwise
            % 3) reshape cube back
            result=reshape(idct(reshape(result,si(1),[])),si);
            
            % circular dimension shift
            si=[si(2:end) si(1)];
            result=shiftdim(result,1);
        end
end

end

