function [res, ests] = pca_sigma_test(slice)

res = zeros(10,20);
sigma = 0.005:0.005:0.1;
ests = zeros(20,1);

for s = 1:20
        slice_noise = randn(size(slice))*sigma(s) + slice;
        est = NLEstimate(slice_noise);
        ests(s) = est;
end
        