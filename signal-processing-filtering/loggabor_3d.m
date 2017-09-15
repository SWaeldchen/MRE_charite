function lg = loggabor_3d(dims, w0, t0, p0, sig_r, sig_ang, CUT, ORD)
if nargin < 8
    ORD = 8;
    if nargin < 7
        CUT = 0.65;
        if nargin < 6
            sig_ang = 0.5;
            if nargin < 5
                sig_r = 0.5;
                if nargin < 4
                    p0 = -1;
                    if nargin < 3
                        t0 = -1;
                    end
                end
            end
        end
    end
end

I = dims(1);
J = dims(2);
K = dims(3);
I2 = floor(I/2);
J2 = floor(J/2);
K2 = floor(K/2);
I_LO = -I2;
J_LO = -J2;
K_LO = -K2;
if mod(I,2) == 0
    I_HI = I2-1;
else
    I_HI = I2;
end
if mod(J,2) == 0
    J_HI = J2-1;
else
    J_HI = J2;
end
if mod(K,2) == 0
    K_HI = K2-1;
else
    K_HI = K2;
end
[ux, uy, uz] = meshgrid((J_LO:J_HI)/J, (I_LO:I_HI)/I, (K_LO:K_HI)/K);
r = sqrt(ux.^2 + uy.^2 + uz.^2);
r(I2+1, J2+1, K2+1) = 1;

lg = exp( -(log(r/w0).^2) ./ (2*log(sig_r)^2) );

if t0 >= 0 && p0 >= 0
    dt =  acos( -(cos(t0)*cos(p0)*ux + sin(t0)*cos(p0)*uy + sin(p0)*uz) ./ sqrt(ux.^2 + uy.^2 + uz.^2));
    rf = exp((-dt.^2) / (2*sig_ang.^2));
    lg = lg .* rf;
end
lg(I2+1, J2+1, K2+1) = 0;
%[~, f] = butter_3d(ORD, CUT, lg);
%lg = lg.*f;

    