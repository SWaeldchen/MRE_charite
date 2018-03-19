function y = denC3D_EB_OGS(x, K, lam)

% % Example
% s1 = double(imread('st.tif'));
% s = s1(:,:,3);
% x = s + 20*randn(size(s));
% lam = 40;
% y = denC2D(x,T);
% imagesc(y)
% colormap(gray)
% axis image
% sqrt(mean(mean((y-s).^2)))

%TC = TripleConv;
[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 4;
%display('Wavelet transform');
w = cplxdual3D(x,J,Faf,af);
I = sqrt(-1);
% loop thru scales

for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C = a + I*b;
%                C = soft(C,T);
               C = ogs3(C, K, lam, 'atan', 1, 5); % OGS replace soft thresholding
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
end

%display('Wavelet inverse transform');

y = icplxdual3D(w,J,Fsf,sf);
szx = size(x);
depth = szx(3);
if depth > 5
    depth = 5;
end

%clear TC;
