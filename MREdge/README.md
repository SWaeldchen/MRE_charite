# MREdge
Pipeline for MR Elastography brain processing and analysis by Eric Barnhill.

This pipeline combines both proprietary tools and tools from external libraries (including SPM, FSL, MRIcro, and NIfTI_tools) to create a fully automated pipeline for MRE images of all kinds, including multiple options for motion correction, distortion correction, phase unwrapping, denoising, bandpass filtering, phase discontinuity removal, wave inversion, and for brain images, co-registration, segmentation, and statistical analysis.

More documentation is available at the Charité internal wiki. Briefly, the user populates an mredge_info structure with acquisition details, then sets up a single preferences file with the function mredge_prefs. Then calling mredge() runs the pipeline. To reproduce past results all that is needed is the info and prefs objects, and the raw data on the server.

For detailed descriptions of individual methods, documentation created by m2html can be found in the doc folder. 

I am grateful to Prof. Ivan Selesnick of New York University for his permission to include his wavelet code, as well as his support over the years.
