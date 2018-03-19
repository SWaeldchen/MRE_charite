function y = cdwt_cat_3d_thresh(w)

y = [];
for s1 = 1:2
	for s2 = 1:2
		y_row = [];
	    for s3 = 1:7
	        y_row = cat(2, y_row,w{1}{1}{s1}{s2}{s3});
	    end
		y = cat(1, y, y_row);
	end
end
