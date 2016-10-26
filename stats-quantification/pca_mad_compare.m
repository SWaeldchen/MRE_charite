function pca_mad_compare(slice)

pca_est = NLEstimate(middle_square(slice));
mad_est = squeeze(median(median(abs(slice(~isnan(slice)) - median(slice(~isnan(slice)))))));

display(['pca est ',num2str(pca_est), ' mad est ', num2str(mad_est), ' ratio ', num2str(pca_est ./ mad_est)]);