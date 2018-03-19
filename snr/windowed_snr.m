function maps = windowed_snr(imgs, window_dims)
%%
% produces quality maps based on windowed SNR calculations
% using noise estimation method of Donoho 1995
%
% Assumes channels to be calculated together are along dim 3
% if not please reshape or permute your data before calling
%
% (c) Eric Barnhill 2018 for Charite Medical University Berlin
% GNU Public License
%
%%
% one window_dim means square
if numel(window_dims) == 1
    window_dims = [window_dims window_dims];
end
% deal with singletons
sz = size(imgs);
[d3, d4, d5, ~] = sort_singletons(sz);

sz_img  = prod(sz(1:2));
% window_dims is a 2d vector with the 2d window dimensions
%
% try to speed up with some unrolling
img_indices = zeros(window_dims);
for i = 1:window_dims(1)
    for j = 1:window_dims(2)
        img_indices(i,j) = (i-1)*sz(1) + j;
    end
end
img_indices = img_indices(:);
max_index = max(img_indices(:));
max_conv = sz_img - max_index;

maps = zeros(sz(1), sz(2), d3, d4, d5);
for p = 1:d5
    for n = 1:d4
        %bar = waitbar(0, ['SNR map for image ', num2str(n), ' ', num2str(p)]);
        disp(['SNR map for image ', num2str(n), ' ', num2str(p)]);
        for m = 1:d3
            %waitbar(m/d3, bar);
            img_slc = imgs(:,:,m,n,p);
            map_slc = zeros(sz_img, 1);
            % take vectorial SNR along dim 3
            for c = 1:sz_img
                indices = img_indices + c;
                ind_over = find(indices > sz_img);
                indices(ind_over) = indices(ind_over) - sz_img;
                vec_window = img_slc(indices);
                if numel(vec_window) >= 8
                    wind = real(reshape(vec_window, window_dims));
                    map_slc(c) = donoho_method_snr_multichannel_img(wind);
                else
                    map_slc(c) = nan;
                end
            end
            map_slc = reshape(map_slc, sz(1:2));
            maps(:,:,m,n,p) = map_slc;
        end
        %close(bar)
    end
end   
                    
% shift to account for "time" delay
maps = circshift(maps, window_dims/2);
