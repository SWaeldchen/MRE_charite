function [w] = subband_OGS_2D(w, lam, J)
if (nargin==1)
	lam = 0.25;
end
if (nargin < 3)
	J = 2;
end

% loop thru scales:
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:3
            C = w{j}{1}{s1}{s2} + 1i*w{j}{2}{s1}{s2};
			% ogs2d
            C = ogs2(C, 3, 3, lam, 'atan', 1, 5);
            w{j}{1}{s1}{s2} = real(C);
            w{j}{2}{s1}{s2} = imag(C);
        end
    end
end

