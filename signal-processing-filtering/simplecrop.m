
function v = simplecrop(w, cropdims)
	if ndims(w) == 1
		v = w(1:cropdims(1));
	elseif ndims(w) == 2
		v = w(1:cropdims(1), 1:cropdims(2));
	elseif ndims(w) == 3
		v = w(1:cropdims(1), 1:cropdims(2), 1:cropdims(3));
    elseif ndims(w) == 4
    	v = w(1:cropdims(1), 1:cropdims(2), 1:cropdims(3), 1:cropdims(4));
	end
end
