% filtering the complex MR signal in 2D
% 
% [MRsignalSmoothed] = smoothMRsignal( MRsignal, inplaneResolution, sigma )
% 
% filtering is done by a in-plane radial gaussian funtion with the parameter sigma
% 
% input:
% MRsignal              6D complex MR signal
%                       - 1st and 2nd dimensions correspond to the in-plane matrix
%                         size(number of rows and columns)
% inplaneResolution     pixel spaceing in meters, correspond to the 1st and
%                       2nd dimensions in MRsignal, respectively
% sigma                 filter stength of 2D-gauss smooth in m
% 
% output:
% MRsignalSmoothed      smoothed complex MR signal
%                       MRsignalSmoothed has the same size like MRsignal

% edit by Heiko Tzschätzsch, Caritè - Universitätsmedizin Berlin, Berlin, Germany
% edit: 2015/04/01
% last change: 2015/11/06

function MRsignalSmoothed = smoothMRsignal( MRsignal, inplaneResolution, sigma)

% get the dimensions
n1 = size(MRsignal,1);% number of rows
n2 = size(MRsignal,2);% number of columns
nSlice = size(MRsignal,3);% number of slices
nTimestep = size(MRsignal,4);% number of time steps
nComponent = size(MRsignal,5);% number of components
nFrequency = size(MRsignal,6);% number of frequencies


% calculate the wavenumber for k-space filtering
k1 = -( (0:n1-1)-fix(n1/2) ) / (n1*inplaneResolution(1)) * 2*pi;%[rad/m] wavenumber in 1st direction
k2 = ( (0:n2-1)-fix(n2/2) ) / (n2*inplaneResolution(2)) * 2*pi;%[rad/m] wavenumber in 2nd direction
[theta, rho] = cart2pol( ones(n1,1)*k2, k1'*ones(1,n2) );% transform into polar coordinates


% filter functiopn in k-space
filterRho = ifftshift(exp( -1/2 * (sigma*rho).^2 ));% gaussian filter function


MRsignalSmoothed = zeros( size(MRsignal) );
for iFrequency = 1 : nFrequency
	display(iFrequency)
    for iComponent = 1 : nComponent
        for iTimestep = 1 : nTimestep  
                tmpMRsignal = MRsignal(:, :, :, iTimestep, iComponent, iFrequency);
                signalR = anisodiff2D(real(tmpMRsignal), 4, 1/7, 50, 1);
                signalI = anisodiff2D(imag(tmpMRsignal), 4, 1/7, 50, 1);
				MRsignalSmoothed(:, :, :, iTimestep, iComponent, iFrequency) = signalR + 1i*signalI;

        end
    end
end

end
