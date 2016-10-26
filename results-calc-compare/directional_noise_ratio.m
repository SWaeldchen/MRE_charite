function [v] = directional_noise_ratio(u);

noiseX_kern = [1 -1];
noiseY_kern = [1; -1];
noiseZ_kern = zeros(1, 1, 2);
noiseZ_kern(1,1,1:2) = [1 -1];

noiseX = abs(convn(u, noiseX_kern, 'same'));
noiseY = abs(convn(u, noiseY_kern, 'same'));
noiseZ = abs(convn(u, noiseZ_kern, 'same'));

v = noiseZ ./ (noiseX + noiseY);
