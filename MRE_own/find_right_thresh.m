function [bestMu, acc, bestThresh] = find_right_thresh( u1, u2, D1, D2, gridSize, muVec, level )
%FIND_RIGHT_THRESH Summary of this function goes here
%   Detailed explanation goes here

bestMu = zeros(size(muVec));
bestThresh = 0;
bestAcc = 10000000000;

for thresh = 0:0.0005:0.05
    
    u1Denoised = wlet_denoise(u1, level, 'db10', 0, thresh, 0);
    u2Denoised = wlet_denoise(u2, level, 'db10', 0, thresh, 0);
    
    muRec = invert_for_mu(D1, D2, u1Denoised, u2Denoised, gridSize);
    
    acc = norm(muVec-muRec)/norm(muVec);
    
    if acc<bestAcc
        bestAcc = acc;
        bestMu = muRec;
        bestThresh = thresh;
    end
end

end

