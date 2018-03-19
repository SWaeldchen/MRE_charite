function [w] = subband_thresh_2D(w, T, J, meth)
if nargin < 4
	meth = 1;
	if nargin < 3
		J = 2;
		if nargin < 2
			T = 0.25
		end
	end
end


% loop thru scales:
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:3
            C = w{j}{1}{s1}{s2} + 1i*w{j}{2}{s1}{s2};
			switch meth
				case 1
            		C = ogs2(C, 3, 3, lam, 'atan', 1, 5);
				case 2
					c = max(abs(C) - T, 0);
		   			C = c./(c+T) .* C;
				case 3
					C = ( C - T^2 ./ C ) .* (abs(C) > T);
			end
            w{j}{1}{s1}{s2} = real(C);
            w{j}{2}{s1}{s2} = imag(C);
        end
    end
end

