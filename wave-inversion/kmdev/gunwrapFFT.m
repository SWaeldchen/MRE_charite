% in-plane Laplacian unwrap and temporal fourier decomposition
% 
% [complexWaveField] = gunwrapFFT(temporalWaveField)
% 
% input:
% temporalWaveField     - 6D temporal resoluted wave field
%                       - 1st and 2nd dimensions correspond to the in-plane matrix
%                         size(number of rows and columns)
%                       - 4th dimension are the number of timesteps
% 
% output:
% complexWaveField          5D unwraped and frequency decomposed wave fied                      

% edit by Florian Dittmann - Universitätsmedizin Berlin, Berlin, Germany
% idea from Ingolf Sack and Florian Dittmann, Carité - Universitätsmedizin Berlin, Berlin, Germany
% Date: 2015/04/01
% last change: 2016/02/01 (by Heiko Tzschätzsch)
function [complexWaveField]=gunwrapFFT(temporalWaveField)

% size of temporalWaveField
si = size(temporalWaveField);
si = [si 1 1 1 1]; % length(si)>=6

% Dirichlet condition: displacement at the edge = 0;
E = ones(si(1)*si(2),1);
laplaceMatrix = spdiags([E E -4*E E E], [-si(1) -1:1 si(1)], si(1)*si(2) , si(1)*si(2) );
laplaceMatrix(si(1):si(1):end, si(1)+1:si(1):end) = 0;% Dirichlet for bottom row
laplaceMatrix(si(1)+1:si(1):end, si(1):si(1):end) = 0;% Dirichlet for top row

% rewrite exp(1i*phase) of  all single 2D phase images as column vectors in a matrix
normMRSignal = reshape(exp(1i*temporalWaveField),[si(1)*si(2) prod(si(3:end))]);

% compute 2D laplacian of phase images
laplacianField = imag((laplaceMatrix*normMRSignal).*conj(normMRSignal));

% FFT along timesteps
ft = fft(reshape(laplacianField,[prod(si(1:3)) si(4) prod(si(5:end))]),[],2);

n = 1;%n-th harmonic
% select n-th harmonic and rewrite (fourier transformed) laplacian as column vectors
laplacianNthHarm = reshape(ft(:,1+n,:),[si(1)*si(2) prod([si(3) si(5:end)])]);

% solve integration
complexWaveField = laplaceMatrix\laplacianNthHarm;

complexWaveField = reshape(complexWaveField,[si(1:3) si(5:end)]);
end