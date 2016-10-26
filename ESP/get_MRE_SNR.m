function [res, res_db] = get_MRE_SNR(FFT, ref)
% gets snr of acquisition from middle 20:20:10 window of temporally Fourier
% transformed MRE acquisition: as is, grad operator, laplace operator
sz = size(FFT);
res = zeros(3, sz(4)*sz(5));
mids = round(size(FFT)/2);
zTop = max(1, mids(3)-4);
zBottom = min(mids(3)+4, sz(3));
window = 20;
for n = 1:sz(5)
    for m = 1:sz(4)
        display(['Image ', num2str(n), ' component ', num2str(m)]);
        s = FFT(mids(1)-window:mids(1)+window, mids(2)-window:mids(2)+window, zTop:zBottom, m, n); 
        s1 = grad3(s);
        s2 = lap3(s);
        index = 3*(n-1) + (m-1) +1;
        res(:,index) = [snr3(abs(s)) snr3(abs(s1)) snr3(abs(s2))];
    end
end
res_db = res(2:end,:);
if (nargin == 2)
    res_db(1,:) = 10*log10(res(2,:)./ref(1,:));
    res_db(2,:) = 10*log10(res(3,:)./ref(1,:));
else 
    res_db(1,:) = 10*log10(res(2,:)./res(1,:));
    res_db(2,:) = 10*log10(res(3,:)./res(1,:));
end