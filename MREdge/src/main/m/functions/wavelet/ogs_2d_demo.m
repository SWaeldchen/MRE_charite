function [waves_d] = ogs_2d_demo(T, x)
close all;
x = real(x);
a = figure(1); subplot(3, 2, 1); imagesc(x); colormap(gray(128)); title('Original Acquisition'); freezeColors;
set(a, 'Position', [100, 100, 800, 800]);
J = 3;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
w = cplxdual2D(x,J,Faf,af);
I = sqrt(-1);
% loop thru scales:
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:3
            C = w{j}{1}{s1}{s2} + I*w{j}{2}{s1}{s2};
            %C = ( C - T^2 ./ C ) .* (abs(C) > T);  SOFT
            C = ogs2_for_demo(C, 3, 3, T, 'atan', 1, 15, j, s1, s2);
            w{j}{1}{s1}{s2} = real(C);
            w{j}{2}{s1}{s2} = imag(C);
        end
    end
end
y = icplxdual2D(w,J,Fsf,sf);
 subplot(3, 2, 6); imagesc(y); colormap(gray(128)); title('Denoise');
