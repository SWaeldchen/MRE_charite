
function W = uw_trend(W,BW)

% Assumption: Mittelungsmaske BW ist eine 2D Maske (2D-Schnittmenge der 3D Mittelungsmaske)
% W: 4D (x,y,z,t)

BW3 = logical(repmat(BW,[1 1 size(W,3)]));



% 2pi-Trend abziehen entlang Ort
sz = size(W);
for v = 1:sz(4),
    x = 0*(1:sz(3));
    for n = 1:sz(3),
        tmp = W(:,:,n,v);
        x(n) = mean(tmp(BW));
    end
    dx = x - unwrap(x);
    dx = reshape(ones(sz(1)*sz(2),1)*dx,sz(1),sz(2),sz(3));
    W(:,:,:,v) = W(:,:,:,v) - dx;
end
                
% 2pi-Trend abziehen entlang Zeit
dt = 0*(1:sz(4));
for v = 1:sz(4),
    tmp = W(:,:,:,v);
    t(v) = mean(tmp(BW3));
end
dt = t - unwrap(t);
dt = reshape(ones(sz(1)*sz(2)*sz(3),1)*dt,sz);
W = W - dt;
