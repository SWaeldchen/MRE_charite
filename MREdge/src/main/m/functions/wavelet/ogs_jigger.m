function [v] = ogs_jigger(u, param, shifts)

n = shifts.^3;
v = zeros(size(u));
for i = 1:shifts
    for j = 1:shifts
        for k = shifts
            v = v + DT_OGS(u, param);
        end
    end
end
v = v ./ n;