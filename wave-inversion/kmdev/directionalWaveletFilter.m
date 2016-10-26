% directional and radial filter of the complex wave field to extract the
% shear waves. Each component of the wave field (4th dimension) will be
% filterd and added in the 4th component. The first direction shows in
% positive 2-direction, the following are equal spaced and in mathematical
% positive order.
% filteredWaveField = directionalRadialFilter( waveField, inplaneResolution, frequency, FilterRho, FilterTheta)
% 
% input:
% waveField             - 5D complex wave field
%                       - 1st and 2nd dimensions correspond to the in-plane matrix
%                         size(number of rows and columns)
%                       - 3rd dimension corresponds to the number of slices
%                         (at least 1 slice)
%                       - 4th dimension contains the components of the displacement
%                         the order of the components SS, RO, and PE is arbitrary
%                       - 5th direction corresponds to the number of frequencies
% inplaneResolution     pixel spaceing in meters, correspond to the 1st and
%                       2nd dimensions in MRsignal, respectively.
% frequency             array of frequencies in Hz
%                       note: length(frequency) must be identical to size(waveField,5)
%                       note: order of frequency must match the data order in the 5th dimension of  waveField
% FilterRho             structure for radial filter
%                       - FilterRho.method :
%                               'diff'      linear high pass (is equivalent to gradient in space)
%                               'gauss'     gaussian function
%                                           with the filter value FilterRho.value
%                               'diffgauss' derivative of gaussian function
%                                           with the filter value FilterRho.value
%                               'symetric'  symetric gaussian filter for k and c
%                                           with the two filter values FilterRho.valueHP and FilterRho.valueTP
%                               'gaussC'    gaussian filter for c
%                                           with the HP-value in k-space
%                                           FilterRho.valueHP
% FilterTheta           structure for directional filter
%                       - FilterRho.flag :
%                               'on'       apply directional filter
%                               'off'      no directional filter
%                       - FilterRho.sigma :
%                               standart deviation of gaussian in theta direction
%                               note: the optimal number of directions will
%                               be automatical calculated
% 
% output:
% filteredWaveField     6D complex filterd wave field,
%                       the first three dimensions are identical to waveField, 
%                       4th dimension corresponds to number of directions used in the directional filter,
%                       5th dimension contains the components
%                       6th direction corresponds to the number of frequencies

% edit by Heiko Tzsch�tzsch, Carit� - Universit�tsmedizin Berlin, Berlin, Germany
% Date: 2015/06/05
function filteredWaveField = directionalWaveletFilter( waveField)
    sz = size(waveField);
    %{
    dim1 = nextpwr2(sz(1));
    dim2 = nextpwr2(sz(2));
    dim = max(dim1, dim2);
    [~, ~, spectra] = collect_dt_filters(dim);
    %}
    numfilts = 6;
    filteredWaveField = zeros( sz(1) , sz(2) , sz(3),  numfilts, sz(4), sz(5) );
    % main filter proces
    for iFrequency = 1 : sz(5) % loop over frequencies
        for iComponent = 1 : sz(4)
            for iSlice = 1 : sz(3)

                    currentWaveField = waveField(:, :, iSlice, iComponent, iFrequency) ;% complex wave field for the current frequency
                    [~, filteredField, ~] = wavelet_directional_filter(currentWaveField, 3);
                    for n = 1:numfilts
                        filteredWaveField(:,:,iSlice,n, iComponent, iFrequency) = filteredField(:,:,n);
                    end
            end % loop over slices
        end % loop over components
    end % loop over freqs
end