function [x_d] = ogs_test_1d
waves1 = sinVec(256, 64);
waves2 = sinVec(256, 64, 3*pi/4);
waves = cat(2, waves1, waves2);%, waves1, waves2);
waves = waves + 0.05*randn(size(waves));
J = 3;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w = dualtree(waves, J, Faf, af);
for m = 1:J
        c = w{m}{1} + 1i*w{m}{2};
        C = ogs1(c, 3, 0.1, 'atan', 1, 10);
        w{m}{1} = real(C);
        w{m}{2} = imag(C);
end
x_d = idualtree(w, J, Fsf, sf);
