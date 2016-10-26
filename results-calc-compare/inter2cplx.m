function y = inter2cplx(x)

sz = size(x);
sz_interp = sz;
sz_interp(end) = sz_interp(end)/2;

y = zeros(sz_interp);
d = ndims(x);
switch d
    case 1
        y = x(1:2:end) + 1i*x(2:2:end);
    case 2
        y = x(:,1:2:end) + 1i*x(:,2:2:end);
    case 3
        y = x(:,:,1:2:end) + 1i*x(:,:,2:2:end);
    case 4
        y = x(:,:,:,1:2:end) + 1i*x(:,:,:,2:2:end);
    case 5
        y = x(:,:,:,:,1:2:end) + 1i*x(:,:,:,:,2:2:end);
end

end