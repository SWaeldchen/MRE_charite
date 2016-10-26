function c = get_plot_colors(n)

firebrick = [178,34,34] / 255;
goldenrod = [218, 165, 32] / 255;
olivedrab = [107, 142, 35] / 255;
steelblue = [70, 130, 180] / 255;
darkmagenta = [139, 0, 139] / 255;

switch n
    case 1
        c = {firebrick};
    case 2 
        c = {firebrick, steelblue};
    case 3
        c = {firebrick, olivedrab, steelblue};
    case 4
        c = {firebrick, goldenrod, olivedrab, steelblue};
    case 5
        c = {firebrick, goldenrod, olivedrab, steelblue, darkmagenta};
    otherwise
        c = colormap(jet(n));
end