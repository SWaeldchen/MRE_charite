function [wdecMat, wrecMat] = gen_wave_mat(N, level, wName )
%GEN_WAVE_MAT Summary of this function goes here
%   Detailed explanation goes here


x = zeros(N,1);
[wx, L] = wavedec(x, level, wName);

wDim = length(wx);

wdecMat = sparse(wDim, N);
wrecMat = sparse(N, wDim);

for k=1:N
    x = zeros(N,1);
    x(k) = 1;
    
    [wx, L] = wavedec(x, level, wName);
    
    wdecMat(:, k) = wx;
    
end

for k=1:wDim
    x = zeros(wDim,1);
    x(k) = 1;
    
    vx = waverec(x, L, wName);
    
    wrecMat(:, k) = vx;
    
end



end

