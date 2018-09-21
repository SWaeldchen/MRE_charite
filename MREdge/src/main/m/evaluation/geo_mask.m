function [mask] = geo_mask(l_x, l_y, start_x, stop_x, start_y, stop_y, shape)

mask = zeros(l_x, l_y);

if strcmp(shape, "rectangle")
    
    mask(round(start_x):round(stop_x), round(start_y):round(stop_y)) = 1;
    
elseif strcmp(shape, "ellipse")
    
    x = (1:l_x)';
    y = 1:l_y;
    
    c_x = ceil((stop_x + start_x)/2);
    c_y = ceil((stop_y + start_y)/2);
    
    w_x = ceil((stop_x - start_x)/2);
    w_y = ceil((stop_y - start_y)/2);

    mask( (x-c_x).^2/w_x.^2 + (y-c_y).^2/w_y.^2 <= 1) = 1;
end
    
    
end

