function [B] = cdwtInterpPhaseSpin(A, xShiftMax, yShiftMax)

if (nargin == 1)
    xShiftMax = 16;
    yShiftMax = 16;
    zShiftMax = 16;
end

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;

B = zeros(size(A).*2);

for m = 0:yShiftMax
    for n = 0:xShiftMax
        shftA = circshift(A,[m n]);
        w = cplxdual2Dinterp(shftA);
        shftB = icplxdual2D(w, 1, Fsf, sf);
        B = B + circshift(shftB, -2*[m n]);
    end
end

B = B./((xShiftMax+1)*(yShiftMax+1));
        