function [u_den, u_x, u_y, u_z] = DT_OGS_u(u, K, lambda, J)

% Dualtree complex denoising 
% with overlapping group sparsity thresholding

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
if nargin < 4
	J = 3;
end
w = cplxdual3D_u(u,J,Faf,af);
% loop thru scales
for j = 1:J
    % loop thru subbands
    for s1 = 1:2
        for s2 = 1:2
            for s3 = 1:7
                a = w{j}{1}{s1}{s2}{s3};
                b = w{j}{2}{s1}{s2}{s3};
                C = a + 1i*b;
                %c = javaMethod('threshold', OGSJava, real(C), imag(C));
                %C = c(:,:,:,1) + 1i*c(:,:,:,2);
                C = ogs3(C, K, lambda, 'atan', 1, 5);
                w{j}{1}{s1}{s2}{s3} = real(C);
                w{j}{2}{s1}{s2}{s3} = imag(C);
            end
        end
    end
end

w_x = w;
w_y = w;
w_z = w;
for s1 = 1:2
    for s2 = 1:2
        for s3 = 1:2
            w_x_lo = w_x{J+1}{s1}{s2}{s3};
            w_y_lo = w_y{J+1}{s1}{s2}{s3};
            w_z_lo = w_z{J+1}{s1}{s2}{s3};
            diff_y = diff(w_y_lo, 1, 1);
            diff_y = cat(1, diff_y, diff_y(end,:,:));
            diff_x = diff(w_x_lo, 1, 2);
            diff_x = cat(2, diff_x, diff_x(:,end,:));
            diff_z = diff(w_z_lo, 1, 3);
            diff_z = cat(3, diff_z, diff_z(:,:,end));
            w_x{J+1}{s1}{s2}{s3} = diff_x;
            w_y{J+1}{s1}{s2}{s3} = diff_y;
            w_z{J+1}{s1}{s2}{s3} = diff_z;
        end
    end
end
u_den = icplxdual3D_u(w,J,Fsf,sf);
u_x = icplxdual3D_u(w_x,J,Fsf,sf);
u_y = icplxdual3D_u(w_y,J,Fsf,sf);
u_z = icplxdual3D_u(w_z,J,Fsf,sf);

