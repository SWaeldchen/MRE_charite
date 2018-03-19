function [vdx, vdy, vdz] = dwt_diff_3D(v,J)

% center
v = v - median(v(:));

%[af, sf] = farras;
[LoD,HiD,LoR,HiR] = wfilters('bior3.5');
af = [LoD' HiD'];
sf = [LoR' HiR'];

sz = size(v);
padmax = max(nextpwr2(sz(1)), max(nextpwr2(sz(2)), nextpwr2(sz(3))));

%[v_pad, order_vector] = extendZ2(v, padmax);
v_pad = simplepad(v, [padmax padmax padmax]);
shiftfac = 2^J;
v_pad = circshift(v_pad, [0 0 shiftfac]);
assignin('base', 'v_pad', v_pad);

w = dwt3D(v_pad, J, af);

T = 0.08;
meth = 2;


assignin('base', 'sample_hipass_nothresh', w{1}{1});

w = subband_thresh_dwt_3D(w, T, J, meth);

assignin('base', 'sample_hipass', w{1}{1});

v_diff = idwt3D(w, J, sf);

assignin('base', 'v_pad', v_pad);
assignin('base', 'v_diff', v_diff);
assignin('base', 'diff_image', abs(v_pad-v_diff) ./ abs(v_pad + eps));

w_x = w;
w_y = w;
w_z = w;
x_grad = [1 -1] / (2^J);
y_grad = [1; -1] / (2^J);
z_grad = zeros(1,1,2);
z_grad(:) = [1, -1] / (2^J);
w_x{J+1} = convn(w_x{J+1}, x_grad, 'same');
w_y{J+1} = convn(w_y{J+1}, y_grad, 'same');
w_z{J+1} = convn(w_z{J+1}, z_grad, 'same');


vdx = simplecrop(circshift(idwt3D(w_x, J, sf), [0 0 -shiftfac]), sz);
vdy = simplecrop(circshift(idwt3D(w_y, J, sf), [0 0 -shiftfac]), sz);
vdz = simplecrop(circshift(idwt3D(w_z, J, sf), [0 0 -shiftfac]), sz);

%firsts = find(order_vector==1);
%index1 = firsts(1);
%index2 = index1 + sz(3) - 1;
%vdx = vdx(1:sz(1),1:sz(2),index1:index2);
%vdy = vdy(1:sz(1),1:sz(2),index1:index2);
%vdz = vdz(1:sz(1),1:sz(2),index1:index2);
end
