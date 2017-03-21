function y = DT_2D_u(x, T, J, meth)
if (nargin == 1)
	T = 0.08;
end
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
if nargin < 4
    meth = 4;
    if nargin < 3
        J = 3;
    end
end
w = cplxdual2D_u(x,J,Faf,af);
I = sqrt(-1);
% loop thru scales:
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:3
            C = w{j}{1}{s1}{s2} + I*w{j}{2}{s1}{s2};
            switch meth
                case 1
                     C = C.*(abs(C) > T);  %HARD
                case 2
                     C = max(abs(C) - T, 0);  %SOFT
                case 3
                     C = ( C - T^2 ./ C ) .* (abs(C) > T);  %NNG
                case 4       
                     C = ogs2(C, 3, 3, T, 'atan', 1, 5); % OGS
                case 5
                     %C = C;
            end
            C(isnan(C)) = 0;
            w{j}{1}{s1}{s2} = real(C);
            w{j}{2}{s1}{s2} = imag(C);
        end
    end
end
y = icplxdual2D_u(w,J,Fsf,sf);
