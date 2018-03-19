function [z_noise, z_noise_circ] = z_noise_est(x)

% estimates z noise levels of an MRE complex wave field, real or imag
% separately


if (~isreal(x))
    display('for real data only');
    z_noise = [];
    z_noise_circ = [];
    return;
end


mid_circ = middle_circle(x);
z_grad = zeros(1,1,2);
z_grad(:) = [1 -1];
z_noise_circ = sum(convn(mid_circ, z_grad, 'valid').^2,3);

z_noise = median(z_noise_circ(~isnan(z_noise_circ))) / median(mid_circ(~isnan(mid_circ)));

