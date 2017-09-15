function lg = loggabor_eb(dims, w0, t0, sig_r, sig_t)
if nargin < 4
    sig_t = 0.5;
    if nargin < 3
        sig_r = 0.5;
        if nargin < 2
            t0 = -1;
        end
    end
end

I = dims(1);
J = dims(2);
[ux, uy] = meshgrid([-J/2:(J/2-1)]/J,...
                   [-I/2:(I/2-1)]/I);
r = sqrt(ux.^2 + uy.^2);
r(I/2+1, J/2+1) = 1;
lg = exp( -(log(r/w0).^2) ./ (2*log(sig_r)^2) );

if t0 >= 0
    t = atan2(-uy, ux);
    dt = abs(atan2(sin(t)*cos(t0)-cos(t)*sin(t0), cos(t)*cos(t0) + sin(t)*sin(t0)));
    rf = exp((-dt.^2) / (2*sig_t.^2));
    lg = lg .* rf;
end
lg(I/2+1, J/2+1) = 0;
    