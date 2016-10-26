function [y, order_vector, sz] = pad_for_3d_wavelet(x, dim)

sz = size(x);
pwr2y = nextpwr2(sz(1));
pwr2x = nextpwr2(sz(2));
pwr2z = nextpwr2(sz(3));

pwrMax = max(pwr2x, max(pwr2y, pwr2z));
y = zeros(pwrMax, pwrMax, pwrMax);
origDepth = sz(3);
tile = origDepth*2-2;
order_vector = zeros(pwrMax,1);
for n = 1 :	pwrMax
    m = n-1;
    index =  mod((m), tile)+1;
    if index < origDepth
        curSlc = origDepth - index + 1;
    end
    
    if index >= origDepth 
        curSlc = index - origDepth + 1;
    end
    y(1:sz(1),1:sz(2),n) = x(:,:,curSlc);
    order_vector(n) = curSlc;
end

y_diff = max(pwrMax - sz(1), 0);
x_diff = max(pwrMax - sz(2), 0);

for n = 1 :	pwrMax
    y(
end
