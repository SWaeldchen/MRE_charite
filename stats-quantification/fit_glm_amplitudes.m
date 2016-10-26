function [r2, p] = fit_glm_amplitudes(means, amps)

mdl = fitglm(means, amps);
p = mdl.Coefficients.pValue(2);
r2 = mdl.Rsquared.Ordinary;