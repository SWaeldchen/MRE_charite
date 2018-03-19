function [wu wx wu2]=gunwrapFFT2(w)
%
% [wu wx]=gunwrap(w)
% in-plane Laplacian unwrap 
% INPUT
% w: n-dimensional cube of wrapped phase images
%	 -> 1st and 2nd index: inplane dimensions
%	 -> 4th index: time step dimension
% OUTPUT
% wu: first harmonic of the unwrapped image
% wx: laplacian of first harmonic
% authors: Florian Dittmann and Ingolf Sack, 2015


si=size(w);
si=[si 1 1 1 1];

E=ones(si(1)*si(2),1);
d=spdiags([E E -4*E E E],[-si(1) -1:1 si(1)],si(1)*si(2),si(1)*si(2));

% rewrite exp(1i*phase) of  all single 2D phase images as column vectors in a
% matrix
PHI =reshape(exp(1i*w),[si(1)*si(2) prod(si(3:end))]);

%compute 2D laplacian of phase images
laplacian=imag((d*PHI).*conj(PHI));

% FFT along time steps
ft=fft(reshape(laplacian,[prod(si(1:3)) si(4) prod(si(5:end))]),[],2);

% select first harmonic and rewrite (fourier transformed) laplacian as
% column vectors 
wx=reshape(ft(:,2,:),[si(1)*si(2) prod([si(3) si(5:end)])]);

% solve integration
wu=d\wx;

wu2=d\wu;
wu2=reshape(wu2,[si(1:3) si(5:end)]);

wx=reshape(wx,[si(1:3) si(5:end)]);
wu=reshape(wu,[si(1:3) si(5:end)]);


