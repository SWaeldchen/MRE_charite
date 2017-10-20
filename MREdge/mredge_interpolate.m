function [] = mredge_interpolate(info, prefs)
%% function mredge_interpolate(info, prefs);
%
% Part of the MREdge software package
% Created 2016 by Eric Barnhill for Charite Medical University Berlin
% Private usage only. Distribution only by permission of Elastography working
% group.
%
%
% USAGE:
%
%   Interpolate the wave field to increase spatial resolution
%
% INPUTS:
%
%   info - MREdge acquisition info structure generated with mredge_acquisition_info
%   prefs - MREdge preferences structure generated with mredge_prefs
%
% OUTPUTS:
%
%   none


loop_over_freqs_and_components_4d_nii(info,prefs, @(x) proc_fun(x), 'FT', 'FT');
%loop_over_freqs_and_components_4d_nii(info,prefs, @(x) proc_fun(x), 'Magnitude', 'Magnitude');

% here we define the processing function that will be applied to each 4D
% nifti volume
    function f_interp = proc_fun(vol4D)
        s = size(vol4D);
        
        % perform interpolation here...
        Nx = s(2);
        Ny = s(1);
        Nz = s(3);
        
        [X Y Z] = meshgrid(1:Nx, 1:Ny, 1:Nz);
        increment = 1/prefs.interpolation_factor;
        [Xi Yi Zi] = meshgrid(1:increment:Nx, 1:increment:Ny, 1:increment:Nz);
        
        s4 = 1;
        if (length(s) > 3)
            s4 = s(4);
        end
        
        f_interp=zeros([size(Xi) s4]);
        
        for k=1:s4
            f_interp(:,:,:,k) = interp3(X,Y,Z,vol4D(:,:,:,k),Xi, Yi, Zi, 'cubic');
        end
        % end of interpolation stuff
        f_interp = squeeze(f_interp);
     end


end