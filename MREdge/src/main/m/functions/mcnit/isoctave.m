function x = is_octave
	x = exist('OCTAVE_VERSION', 'builtin') ~= 0;
end
