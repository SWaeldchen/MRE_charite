function c = get_jet_color(ind, max)

cm = colormap(jet(max));

c = cm(ind, :);