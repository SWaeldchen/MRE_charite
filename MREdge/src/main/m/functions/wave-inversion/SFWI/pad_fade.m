function U_fade = pad_fade(U)

sz = size(U);
U_pad = cat(3, U(:,:,end:-1:1,:,:), U, U(:,:,end:-1:1,:,:));
fade_multiples = linspace(0, 1, sz(3));
fade_line = [fade_multiples, ones(1, numel(fade_multiples)), fade_multiples(end:-1:1)]';
fade_case = ones(1, 1, numel(fade_line), 1, 1);
fade_case(:) = fade_line;
fade_matrix = repmat(fade_case, [sz(1) sz(2) 1 sz(4) sz(5)]);

U_fade = U_pad .* fade_matrix;
end