function e = evaluate_objective_function(y,x,tv_weight,smoothing_param)
    e = 0.5*L2_norm(x - y).^2 + tv_weight*TV(y, smoothing_param);
end