function y = jigger_2d(x, jigs)

y = zeros(size(x));

for x_jig = 0:jigs
    for y_jig = 0:jigs
        y = y + circshift(x, [x_jig, y_jig]);
    end
end

y = y / jigs.^2;