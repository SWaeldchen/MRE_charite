function x_pad = z_pad_6d(x)

sz = size(x);
x_pad = cat(3, x(:,:,end:-1:1,:,:,:),x,x(:,:,end:-1:1,:,:,:));
