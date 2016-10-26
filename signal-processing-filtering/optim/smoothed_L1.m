function u_eps = smoothed_L1(gradx, grady, smoothing_param)
    u_eps = sqrt(smoothing_param^2 + gradx.^2 + grady .^2);
end