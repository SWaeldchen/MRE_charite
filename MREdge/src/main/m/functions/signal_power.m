function p = signal_power(signal, mask)

if nargin == 1
    mask = ones(size(signal));
end

p = sum(abs(signal(mask==1)).^2)/length(signal(mask==1));
