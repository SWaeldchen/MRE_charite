function c = get_rgb_color(ind, max)

cm = colormap(hsv(round(max*1.25)));

c = cm(ind, :);