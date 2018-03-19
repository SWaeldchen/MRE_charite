function [waves_d] = ogs_1d_demo(lambda)
close all;
waves1 = sinVec(256, 256);
waves2 = sinVec(256, 256, 3*pi/4);
waves = cat(2, waves1, waves2);%, waves1, waves2);
waves = waves + 0.1*randn(size(waves));
a = figure(1); subplot(6, 1, 1); plot(waves); title('Orig'); xlim([0 numel(waves)]);
set(a, 'Position', [100, 100, 700, 700]);
J = 3;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w = dualtree(waves, J, Faf, af);
for m = 1:J
        c = w{m}{1} + 1i*w{m}{2};
        C = ogs1_for_demo(c, 3, lambda, 'atan', 1, 20, m);
        w{m}{1} = real(C)';
        w{m}{2} = imag(C)';
end
waves_d = idualtree(w, J, Fsf, sf);
subplot(6, 1, 6); plot(waves_d); title('Denoise'); xlim([0 numel(waves)]);
