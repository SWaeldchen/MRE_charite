function lg = loggabor_2d(dims, w0, t0, sig_r, sig_t, CUT, ORD)
if nargin < 7
    ORD = 8;
    if nargin < 6
        CUT = 0.65;
        if nargin < 5
            sig_t = 0.5;
            if nargin < 4
                sig_r = 0.5;
                if nargin < 3
                    t0 = -1;
                end
            end
        end
    end
end

I = dims(1);
J = dims(2);
I2 = floor(I/2);
J2 = floor(J/2);
I_LO = -I2;
J_LO = -J2;
if mod(I,2) == 0
    I_HI = I2-1;
else
    I_HI = I2;
end
if mod(I,2) == 0
    J_HI = J2-1;
else
    J_HI = J2;
end
[ux, uy] = meshgrid([J_LO:J_HI]/J,...
                   [I_LO:I_HI]/I);
r = sqrt(ux.^2 + uy.^2);
r(I2+1, J2+1) = 1;
lg = exp( -(log(r/w0).^2) ./ (2*log(sig_r)^2) );

if t0 >= 0
    t = atan2(-uy, ux);
    dt = abs(atan2(sin(t)*cos(t0)-cos(t)*sin(t0), cos(t)*cos(t0) + sin(t)*sin(t0)));
    rf = exp((-dt.^2) / (2*sig_t.^2));
    lg = lg .* rf;
end
lg(I2+1, J2+1) = 0;
[~, f] = butter_2d(ORD, CUT, lg);
lg = lg.*f;
    