butter_montage = [];
butter_mad = zeros(5,4);
for i = 1:1
    row = [];
    for j = 1:3
        slice = results{1}(:,:,i,j);
        row = cat(2, row, slice);
        butter_mad(j,i) = mad_eb(slice(:));
    end
    butter_montage = cat(1, butter_montage, row);
end