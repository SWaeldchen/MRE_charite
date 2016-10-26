
function v = simplepad(w, paddims)
	if ndims(w) == 1
		v = zeros(paddims(1),1);
		v(1:numel(w)) = w;
	elseif ndims(w) == 2
		v = zeros(paddims(1),paddims(2));
		v(1:size(w,1), 1:size(w,2)) = w;
	elseif ndims(w) == 3
		v = zeros(paddims(1),paddims(2),paddims(3));
		v(1:size(w,1), 1:size(w,2), 1:size(w,3)) = w;
    elseif ndims(w) == 4
    	v = zeros(paddims(1),paddims(2),paddims(3),paddims(4));
    	v(1:size(w,1), 1:size(w,2), 1:size(w,3), 1:size(w,4)) = w;
	end
end
