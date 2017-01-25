# mcnit

the m-code-complex-nd-imaging-toolbox
Syntactic sugar and convenience methods for processing of >= 3D and complex valued images in Matlab or GNU Octave.

Toolbox contains:

butter_2d and butter_3d : high or lowpass N-dimensional data sets using 2d or 3d low or high pass Butterworth filters

complex_plot : convenience method for easy clear plotting of complex vectors

dctn, idctn, dct_octave and idct_octave: discrete cosine transforms in 1d and Nd, adapting Octave code to be also Matlab compatible, so that no toolboxes are required

interp_2d and inter_3d : interpolate N-dimensional data sets in the first 2 or 3 dimensions, using preset interpolation options. Allows for real-imag or phase-magnitude based interpolations for complex numbers

isoctave : simple method to check if the user is running GNU octave

normalize_image : rescale Nd object 0 to 1

pwrspec_2d : returns slicewise power spectra, log power spectra, or normalized log power spectra in dB for an N-dimensional object
