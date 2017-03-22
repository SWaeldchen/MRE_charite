function open_image_octave(image, mij_instance, title)
if nargin < 3
    title = 'Image from Octave';
end
[image_resh, n_slcs] = resh(real(double(image)), 3);
size_vector = size(image_resh);
mij_instance.createImage(image_resh(:), size_vector, title);


