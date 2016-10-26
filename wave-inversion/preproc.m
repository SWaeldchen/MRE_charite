function wUnwrapped = preproc(wWrapped)

% Adaptation of code found in Dittmann et al 2015.

si=size(wWrapped);
si=[si,1,1,1,1];
% FD scheme with Dirac boundary conditions
E=ones(si(1)*si(2),1);
Laplacian=spdiags([E,E,-4*E,E,E],[ -si(1),-1:1,si(1)],si(1)*si(2), si(1)*si(2));
% unwrapping including slice wise temporal FFT
PHI=reshape(exp(1i*wWrapped),[si(1)*si(2),prod(si(3:end))]);
LaplacianPHI=imag((Laplacian*PHI).*conj(PHI));
ft=fft(reshape(LaplacianPHI,[prod(si(1:3)), si(4),prod(si(5:end))]), [],2);
wx=reshape(ft(:,2,:),[si(1)*si(2), prod([si(3) si(5:end)])]);
% integration
wUnwrapped=Laplacian\wx;
wUnwrapped=reshape(wUnwrapped,[si(1:3), si(5:end)]);
