function significant_coin_flips

NUMBER_OF_TESTS = 1000;
NUMBER_OF_FLIPS = 5000;
p_vals = zeros(NUMBER_OF_TESTS, 1);
h_vals = zeros(NUMBER_OF_TESTS, 1);
for n = 1:NUMBER_OF_TESTS
    if mod(n,100) == 0
        disp(n)
    end
    cf1 = ceil(rand(NUMBER_OF_FLIPS,1)*2);
    cf2 = ceil(rand(NUMBER_OF_FLIPS,1)*2);
    [h_vals(n), p_vals(n)] = ttest2(cf1, cf2);
end
pct_pos_results = numel(find(h_vals == 1)) / numel(h_vals);
disp([num2str(pct_pos_results), '% of your coin flipping tests returned a statistically significant difference']);
histogram(p_vals);