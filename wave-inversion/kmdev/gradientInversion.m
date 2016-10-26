% calculate the maps of the shear wave speed, the penetration rate and the amplitude of
% the shear wave field by the gradient method of kMDEV
% 
% [c, Lambda, amplitude] = gradientInversion( shearWaveField, inplaneResolution, frequency, weigthingFactor)
% 
% input:
% shearWaveField        - 6D complex filterd wave field
%                       - 1st and 2nd dimensions correspond to the in-plane matrix
%                         size(number of rows and columns)
%                       - 3rd dimension corresponds to the number of slices
%                         (at leeat 1 slice)
%                       - 4th dimension corresponds to number of directions used in the directional filter,
%                       - 5th dimension contains the components
%                       - 6th direction corresponds to the number of frequencies
% inplaneResolution     pixel spaceing in meters, correspond to the 1st and
%                       2nd dimensions in shearWaveField, respectively.
% frequency             array of frequencies in Hz
%                       note: length(frequency) must be identical to size(shearWaveField,6)
%                       note: order of frequency must match the data order in the 6th dimension of shearWaveField      
% weigthingFactor       amplitude weigthing factor for the computation of c, a, and amplitude
% 
% output:
% c                     map of shear wave speed
%                       - c.standart: standart calculation of c
%                       - c.alternative: more stable calculation of c only if the shear
%                         wave amplitudes have a strong frequency dependence
%                       - c.frequencyResolved: calculation of frequency resolved c
%                       - c.standardStd: calutation of standard devitation of shear wave speed
% Lambda                map of penetration depth
%                       - Lambda.standart: standart calculation of Lambda
%                       - Lambda.alternative: more stable calculation of a only if the shear
%                         wave amplitudes have a strong frequency dependence
%                       - Lambda.frequencyResolved: frequency resolved Lambda
% amplitude              map of amplitude
%                       - amplitude.standart: standart calculation of amplitude
%                       - amplitude.alternative: more stable calculation of amplitude only if the shear
%                         wave amplitudes have a strong frequency dependence
%                       - amplitude.frequencyResolved: gives the frequency
%                       resolved amplitude

% edit by Heiko Tzschätzsch, Carité - Universitätsmedizin Berlin, Berlin, Germany
% edit: 2015/10/16
% last change: 2015/12/11
function [c, Lambda, amplitude] = gradientInversion(shearWaveField,inplaneResolution,frequency,weigthingFactor)

%get the dimensions
n1 = size(shearWaveField,1);% number of rows
n2 = size(shearWaveField,2);% number of columns
nSlice = size(shearWaveField,3);% number of slices
nTheta = size(shearWaveField,4);% number of directions used in the directional filter
nComponent = size(shearWaveField,5);% number of components
nFrequency = size(shearWaveField,6);% number of frequencies

% preallocate the frequency averaged (standard) output values
standardC = zeros( n1, n2, nSlice );%[m/s] shear wave speed
stdC = zeros( n1, n2, nSlice );%[m/s] standard devitation of shear wave speed
inverseCTotal = zeros( n1, n2, nTheta,  nComponent, nFrequency );%[s/m] temporal inverse shear wave speed
weigthTotal = zeros( n1, n2, nTheta,  nComponent, nFrequency );% temporal weight
standardLambda = zeros( n1, n2, nSlice );%[m] penetration depth
standardAmplitude = zeros( n1, n2, nSlice );% amplitude

% preallocate the frequency resolved output values
fC = zeros( n1, n2, nSlice, nFrequency );%[m/s] shear wave speed
fLambda = zeros( n1, n2, nSlice, nFrequency );%[m] penetration depth
fAmplitude = zeros( n1, n2, nSlice, nFrequency );% amplitude

for iSlice = 1 : nSlice
    
    % initialize the nominators and denominator
    nominatorC = 0;
    nominatorLambda = 0;
    nominatorAmplitude = 0;
    denominator = 0;
    
    for iFrequency = 1 : nFrequency
        currentFrequency = frequency( iFrequency );%[Hz] selected frequency
    
        % initialize the nominators and denominator for frequency resolved values
        fNominatorC = 0;
        fNominatorLambda = 0;
        fNominatorAmplitude = 0;
        fDenominator = 0;
        
        for iTheta = 1 : nTheta % loop over directions
            for iComponent = 1 : nComponent % loop over components
                
                currentSWF = shearWaveField(:, :, iSlice, iTheta, iComponent, iFrequency);
                
                
                % amplitude -----------------------------------------------
                currentAmplitude =  abs(currentSWF);
                weight = currentAmplitude.^weigthingFactor;% calculate the weight
                weigthTotal(:, :, nTheta, iComponent, iFrequency) = weight;%sum of the weigthed amplitude
                fNominatorAmplitude = fNominatorAmplitude + currentAmplitude .* weight;
                fDenominator = fDenominator + weight;%sum of the weigths
                
                
                % calculate the shear wave speed --------------------------
%                 normedSWF = currentSWF ./ currentAmplitude;% amplitude normed shear wave field
%                 [G2,G1] = gradient( normedSWF, inplaneResolution(2), inplaneResolution(1) );%[rad/m] gradients of normed shear wave field
                phaseDifference1 = angle( conj(currentSWF(1:end-1,:)) .* currentSWF(2:end,:) ) / inplaneResolution(1);
                phaseDifference2 = angle( conj(currentSWF(:,1:end-1)) .* currentSWF(:,2:end) ) / inplaneResolution(2);
                G1 = [phaseDifference1(1,:); (phaseDifference1(1:end-1,:)+phaseDifference1(2:end,:)) / 2; phaseDifference1(end,:)];
                G2 = [phaseDifference2(:,1), (phaseDifference2(:,1:end-1)+phaseDifference2(:,2:end)) / 2, phaseDifference2(:,end)];
                currentKreal = sqrt( abs(G1).^2 + abs(G2).^2);%[rad/m] real part of the wave vector k
                inverseCTotal(:, :, nTheta, iComponent, iFrequency) = currentKreal / (2*pi*currentFrequency);%[s/m]
                fNominatorC = fNominatorC + currentKreal .* weight;% sum of the weigthed real k
                
                % calculate the penetration depth -------------------------
                [G2,G1] = gradient( currentAmplitude, inplaneResolution(2), inplaneResolution(1) );%gradients of amplitude
                if nTheta>1 % if directional filter 'on'
                    % projection of amplitude gradient in filter direction
                    unitvector1 = -sin( (iTheta-1)*2*pi/nTheta);
                    unitvector2 = +cos( (iTheta-1)*2*pi/nTheta);
                    
                    currentKimag = abs(G1.*unitvector1 + G2.*unitvector2) ./ currentAmplitude;%[1/m] imag part of the wave vector k
                    
                    [G2,G1] = gradient( currentKimag, inplaneResolution(2), inplaneResolution(1) );%gradients of firt guess of imag k
                    corretion = sqrt( abs(G1.*unitvector1 + G2.*unitvector2) );%[1/m] should be 1/r of point source
                    currentKimag = abs( currentKimag - corretion );
                else % directional filter 'off'
                    currentKimag = sqrt( G1.^2 + G2.^2 ) ./ currentAmplitude;%[1/m] imag part of the wave vector k
                end
                fNominatorLambda = fNominatorLambda+ currentKimag .* weight;% sum of the weigthed imag k
                
                
%                 currentC(:,:,iTheta, iComponent) = (2*pi*currentFrequency) ./ currentKreal;
%                 currentLambda(:,:,iTheta, iComponent) = currentFrequency ./ currentKimag;
%                 currentAmp(:,:,iTheta, iComponent) = currentAmplitude;
%                 currentWave(:,:,iTheta, iComponent) = currentSWF; 
            end% loop over components
        end% loop over directions
%         if iSlice == 10 & iFrequency == 4
%             zwischenschritt.cc=currentC(:,:,:, [1,3]);
%             zwischenschritt.mag=currentAmp(:,:,:, [1,3]);
%             zwischenschritt60Hz.wave=currentWave(:,:,:, [1,3]);
%             zwischenschritt60Hz.info='iSlice == 10, iFrequency == 7, iComponent=1+3';
%             save('JG', 'zwischenschritt30Hz');
%             save('JG', 'zwischenschritt60Hz','-append');
%             plot2dwaves( reshape(currentC, [n1 n2 nTheta*nComponent]) );caxis([0 5])
%             plot2dwaves( reshape(currentLambda, [n1 n2 nTheta*nComponent]) );caxis([0 5])
%             plot2dwaves( reshape(currentAmp, [n1 n2 nTheta*nComponent]) );caxis([0 5])
%             plot2dwaves( reshape(currentWave, [n1 n2 nTheta*nComponent]) );caxis([-1 1])
%             plot2dwaves( reshape(angle(currentWave), [n1 n2 nTheta*nComponent]) );caxis([-1 1])
%         end

        
        % calculate the frequency resolved c, a, and amplitude
        fKreal = fNominatorC ./ fDenominator;%[rad/m] real part of k for selected frequency
        fC(:,:,iSlice,iFrequency) = (2*pi*currentFrequency) ./ fKreal;%[m/s] shear wave speed
        fKimag = fNominatorLambda ./ fDenominator;%[1/m] imag part of k for selected frequency
        fLambda(:,:,iSlice,iFrequency) = 1 ./ fKimag;%[m] penetration depth
        fAmplitude(:,:,iSlice,iFrequency) = fNominatorAmplitude ./ fDenominator;%
        
%         s = 31;
%         temp = smooth2(fAmplitude(:,:,iSlice,iFrequency), 'gaussian', [3*s 3*s 1], s);
%         temp = temp.^weigthingFactor;
%         fNominatorC = fNominatorC ./ temp;
%         fDenominator = fDenominator ./ temp;
        
        % calculate the standard nominator and denominnator
        nominatorC = nominatorC + fNominatorC / (2*pi*currentFrequency);
        nominatorLambda = nominatorLambda + fNominatorLambda;
        nominatorAmplitude = nominatorAmplitude + fNominatorAmplitude;
        denominator = denominator + fDenominator;
        
    end  % loop over frequencies
    
    
    % calculate the standard c, a, and amplitude
    inverseC = nominatorC ./ denominator;%[s/m] inverse shear wave speed
    standardC(:,:,iSlice) = 1 ./ inverseC;%[m/s] shear wave speed
    residueInverseC = repmat(inverseC, [1 1 nTheta nComponent nFrequency]) - inverseCTotal;%[s/m] residue of inverse shear wave speed
    inverseCStd = sqrt( sum(sum(sum( residueInverseC.^2 .* weigthTotal ,5),4),3) ./ denominator );%[s/m] standard devitation of inverse shear wave speed
    stdC(:,:,iSlice) = inverseCStd ./ ( inverseC.^2 );%[m/s] standard devitation of shear wave speed
    inverseLambda = nominatorLambda ./ denominator;%[1/m] inverse penetration depth
    standardLambda(:,:,iSlice) = 1 ./ inverseLambda;%[m] penetration depth
    standardAmplitude(:,:,iSlice) = nominatorAmplitude ./ denominator;% amplitude
    
end  % loop over slices

% calculate the output values
c.standard = standardC;%[m/s]
c.alternative = 1 ./ mean( 1./fC ,4);%[m/s]
c.frequencyResolved = fC;%[m/s]
c.standardStd = stdC;%[m/s]

Lambda.standard = standardLambda;%[m]
Lambda.alternative = 1 ./ mean( 1./fLambda ,4);%[m]
Lambda.frequencyResolved = fLambda;%[m]

amplitude.standard = standardAmplitude;
amplitude.alternative = mean( fAmplitude ,4);
amplitude.frequencyResolved = fAmplitude;
    
end