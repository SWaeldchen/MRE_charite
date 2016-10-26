function [val_obj] = map_keys_to_values(key_obj, lookup_vec)

sz = size(key_obj);
key_obj_vec = key_obj(:);
val_obj_vec = zeros(size(key_obj_vec));
num_objs = numel(key_obj_vec);
for n = 1:num_objs
	val_obj_vec(n) = lookup_vec(key_obj_vec(n));
end
val_obj = reshape(val_obj_vec, sz);



