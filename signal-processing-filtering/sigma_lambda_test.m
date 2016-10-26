function [res] = sigma_lambda_test(slice)

res = zeros(10,20);
sigma = 0:0.005:0.1;
lambda = 0:0.05:1;

for s = 1:21
    for l = 1:21
        slice_noise = randn(size(slice))*sigma(s) + slice;
        est = NLEstimate(slice_noise);
        display(['sigma ', num2str(sigma(s)), ' enl ',num2str(est)]);
        slice_denoise = DT_2D(slice_noise, lambda(l)*sigma(s));
        res(s, l) = NLEstimate(slice_denoise);
    end
end
        