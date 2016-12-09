function [diff_x, diff_y, diff_z] = get_diffs(vol, spacing)
if nargin < 2
    spacing = [1 1 1];
end
diff_y = diff(vol, 1, 1) ./ spacing(1);
diff_y = cat(1, diff_y, diff_y(end,:,:));
diff_x = diff(vol, 1, 2) ./ spacing(2);
diff_x = cat(2, diff_x, diff_x(:,end,:));
diff_z = diff(vol, 1, 3) ./ spacing(3);
diff_z = cat(3, diff_z, diff_z(:,:,end));

end