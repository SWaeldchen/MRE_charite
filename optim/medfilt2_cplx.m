function x = medfilt2_cplx(x, dim)

x_r = medfilt2(real(x), [dim dim]);
x_i = medfilt2(imag(x), [dim dim]);

x = x_r + 1i*x_i;

