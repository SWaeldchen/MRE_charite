function displaySTFT(X, Fs, T, dBlim)

% displaySTFT(X, fs, Nf, dBlim)
% Display the short-time Fourier transform coefficients X
%
% INPUT
%   X: STFT coefficients (2D array)
%   Fs: sampling rate
%   T: duration of signal

[Nt, Nf] = size(X);

XdB = 20 * log10( abs( X(1:round(Nt/2), :)) );

if nargin == 4
    imagesc( [0 T], [0 Fs/2/1000],  XdB, dBlim);
else
    imagesc( [0 T], [0 Fs/2/1000],  XdB);
end

cm = colormap( 'gray' );
cm = cm(end:-1:1,:);
colormap(cm);

axis xy
xlabel( 'Time (seconds)' )
ylabel( 'Frequency (kHz)' )

xlim([0 T])
ylim([0 Fs/2/1000])


% CB = colorbar;
% set(CB, 'ytick', (-50:10:0))

shg

