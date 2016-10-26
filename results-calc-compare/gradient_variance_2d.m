function y = gradient_variance_2d(x)

val = x(2:end-1, 2:end-1);
grad1 = ( x(2:end-1, 2:end-1) - x(1:end-2, 2:end-1) ) ./ val;
grad2 = ( x(2:end-1, 2:end-1) - x(3:end, 2:end-1) ) ./ val;
grad3 = ( x(2:end-1, 2:end-1) - x(2:end-1, 1:end-2) ) ./ val;
grad4 = ( x(2:end-1, 2:end-1) - x(2:end-1, 3:end) ) ./ val;

y = sqrt(grad1.^2 + grad2.^2 + grad3.^2 + grad4.^2);
