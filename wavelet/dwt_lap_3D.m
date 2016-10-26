function [v_lap] = dwt_diff_3D(v,J)

%[af, sf] = farras;
[LoD,HiD,LoR,HiR] = wfilters('bior3.5');
af = [LoD' HiD'];
sf = [LoR' HiR'];

sz = size(v);
padmax = max(nextpwr2(sz(1)), max(nextpwr2(sz(2)), nextpwr2(sz(3))));

[v_ex, order_vector] = extendZ2(v, padmax);

padmax_vec = [padmax padmax padmax];
v_pad = simplepad(v_ex, padmax_vec);


w = dwt3D(v_pad, J, af);
w_lap = w;
lap = get3dLaplacian();
w_lap{J+1} = convn(w_lap{J+1}, lap, 'same');

v_lap = idwt3D(w_lap, J, sf);

firsts = find(order_vector==1);
index1 = firsts(1);
index2 = index1 + sz(3) - 1;
v_lap = v_lap(1:sz(1),1:sz(2),index1:index2);

end
