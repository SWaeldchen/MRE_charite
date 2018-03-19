function y = DT_2D_snr(x, snr, J)
if (nargin == 1)
	T = 0.08;
end
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
if (nargin < 3)
    J = 4;
end
w = cplxdual2D(x,J,Faf,af);
I = sqrt(-1);
% loop thru scales:
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:3
            C = w{j}{1}{s1}{s2} + I*w{j}{2}{s1}{s2};
            %C = ( C - T^2 ./ C ) .* (abs(C) > T);  SOFT
            snr_temp = imresize(snr, 1/(2^j));
            C = ogs2_snr(C, 3, 3, snr_temp, 'atan', 1, 5);
            w{j}{1}{s1}{s2} = real(C);
            w{j}{2}{s1}{s2} = imag(C);
        end
    end
end
y = icplxdual2D(w,J,Fsf,sf);
