% directional and radial filter of the complex wave field to extract the
% shear waves. Each component of the wave field (4th dimension) will be
% filterd and added in the 4th component. The first direction shows in
% positive 2-direction, the following are equal spaced and in mathematiacal
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

% edit by Heiko Tzschätzsch, Carité - Universitätsmedizin Berlin, Berlin, Germany
% Date: 2015/06/05
function filteredWaveField = directionalRadialFilter( waveField, inplaneResolution, frequency, FilterRho, FilterTheta)

%get the dimensions
n1 = size(waveField,1);% number of rows
n2 = size(waveField,2);% number of columns
nSlice = size(waveField,3);% number of slices
nComponent = size(waveField,4);% number of components
nFrequency = size(waveField,5);% number of frequencies


        
% calculate the wavenumber for k-space filtering
k1 = -( (0:n1-1)-fix(n1/2) ) / (n1*inplaneResolution(1)) * 2*pi;%[rad/m] wavenumber in 1st direction
k2 = ( (0:n2-1)-fix(n2/2) ) / (n2*inplaneResolution(2)) * 2*pi;%[rad/m] wavenumber in 2nd direction
[theta, rho] = cart2pol( ones(n1,1)*k2, k1'*ones(1,n2) );% transform to polar coordinates



% calculate directional filter
switch FilterTheta.flag
    case 'on'
        
        nTheta = round( 2*pi / FilterTheta.sigma );% number of directions
        if nTheta > 1 % at least two directions
            
            % calculate the angles of directions
            thetaValue= 2*pi * linspace( 0, 1-1/nTheta, nTheta);%[rad] 
            
            filterFunctTheta = zeros( n1 ,n2 , nTheta );
            for iTheta = 1 : nTheta % loop over directions
                currentThetaValue = thetaValue( iTheta );%[rad] selected theta value
                currentTheta = imag(log( exp( 1i * (theta-currentThetaValue) ) ));%[rad] rotated theta
                filterFunctTheta(:,:,iTheta) = exp( -1/2 * ( currentTheta/FilterTheta.sigma ).^2 );% gaussian function with selected theta
            end
            
        else % no directional filtering
            nTheta = 1;% number of directions set to 1
            filterFunctTheta = ones( n1, n2 );% directional filter are isotropic
        end
        
    otherwise % no directional filtering
        nTheta = 1;% number of directions set to 1
        filterFunctTheta = ones( n1, n2 );% directional filter are isotropic
end



filteredWaveField = zeros( n1 ,n2 , nSlice, nTheta, nComponent, nFrequency );
for iFrequency = 1 : nFrequency % loop over frequencies
    
    currentFrequency=frequency(iFrequency);%[Hz]  selected frequency
    
    % calculate radial filter
    switch FilterRho.method
        case 'diff'% linear high pass (equivalent to gradient in space)
            filterRho = rho;
        case 'gauss'% function: gaussian
            filterRho = exp( -1/2 * (FilterRho.value*rho).^2 );
       	case 'fermi'% function: gaussian
            kBT = currentFrequency / FilterRho.value;%[1/m] hight pass value in k-space
            filterRho = 2 ./ ( exp(-2*rho/kBT) + 1) - 1;
        case 'diffgauss'% function: derivative of gaussian
            filterRho = FilterRho.value * rho .* exp( 1/2 * (1-(FilterRho.value*rho).^2) );
        case 'symetric'% symetric gaussian filter for k and c
            sigmaLP = FilterRho.valueLP;%[m] low pass value in k-space
            sigmaHP = FilterRho.valueHP/(2*pi*currentFrequency);%[m] hight pass value for constant shear wave speed filter
            filterRho = exp( -1/2 * (rho*sigmaLP).^2) .* exp( -1/2 *( 1./(rho*sigmaHP)).^2);% symetric filter for k and c
            filterRho( rho==0 ) = 0;% set the center inf to 0
        case 'gaussC'% gaussian filter for c
            sigmaHP = FilterRho.valueHP/(2*pi*currentFrequency);%[m] hight pass value for constant shear wave speed filter
            filterRho = exp( -1/2 *( 1./(rho*sigmaHP)).^2);% gaussian filter in c-space
            filterRho( rho==0 ) = 0;% set the center inf to 0
        otherwise
            filterRho = ones( n1, n2 );% radial filter constant
    end
    
    
    
    %create the combined filter
    filter = repmat(filterRho,[1 1 nTheta]) .* filterFunctTheta;
    
    
    
    % main filter proces
    for iSlice = 1 : nSlice
        for iComponent = 1 : nComponent
            
            currentWaveField = waveField(:, :, iSlice, iComponent, iFrequency) ;% complex wave field for the current frequency
            fourierWF = fftshift( fftn(currentWaveField) );% in-plane fourier transformation
            
            for iTheta = 1 : nTheta % for all directions
                filterdFourierWF = fourierWF .* filter(:,:,iTheta); % filtering
                filteredWaveField(:, :, iSlice, iTheta, iComponent, iFrequency) = ifftn(ifftshift(filterdFourierWF));% inverse fft
            end
            
        end % loop over components
    end % loop over slices
    
end% loop over frequencies

end