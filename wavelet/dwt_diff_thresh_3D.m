function [vdx, vdy, vdz] = dwt_diff_thresh_3D(v,J)

%[af, sf] = farras;
[LoD,HiD,LoR,HiR] = wfilters('bior3.5');
af = [LoD' HiD'];
sf = [LoR' HiR'];

sz = size(v);
padmax = max(nextpwr2(sz(1)), max(nextpwr2(sz(2)), nextpwr2(sz(3))));

[v_pad, order_vector] = extendZ2(v, padmax);
assignin('base', 'v_pad', v_pad);

w = dwt3D(v_pad, J, af);
%thresh
for j = 1:J
    for n = 1:3
        



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


vdx = idwt3D(w_x, J, sf);
vdy = idwt3D(w_y, J, sf);
vdz = idwt3D(w_z, J, sf);

firsts = find(order_vector==1);
index1 = firsts(1);
index2 = index1 + sz(3) - 1;
vdx = vdx(1:sz(1),1:sz(2),index1:index2);
vdy = vdy(1:sz(1),1:sz(2),index1:index2);
vdz = vdz(1:sz(1),1:sz(2),index1:index2);
end
