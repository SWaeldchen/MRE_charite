function [alpha, mu, rss] = lsq_springpot_fit(wvec, Gvec)

m = length(wvec);
if (length(Gvec) ~= m), end

v = log(wvec);
Z = log(abs(Gvec));
S = sum(v);

A(1,1) = sum(v.^2);
A(2,1) = S;
A(1,2) = S;
A(2,2) = m;

b(1,1) = sum(Z.*v);
b(2,1) = sum(Z);

x = A\b;

alpha = x(1);
mu = (Gvec ./ (wvec.^alpha)).^(1 ./ (1-alpha));
model_Gvec = mu.^(1-alpha).*(wvec).^(alpha);
rss = sum((Gvec - model_Gvec).^2);








