function [w, g] = double_prog_smooth(U, freqs, voxelSpacing)
wvec = 0.1:0.1:3;
gvec = 0.1:0.1:5;
w = [];
g = [];

display('Gaussian denoising');
for n = 1:numel(gvec)
    tic
    g = cat(4, g, ESP_preproc_progsmooth(U, freqs, voxelSpacing, 0, 1, gvec(n)));
    toc
end
assignin('base', 'g', g);

eta = 0;
display('Wavelet denoising');
for n = 1:numel(wvec)
    display('--------------'); display(n); display('--------------');
    tic
    w = cat(4, w, ESP_preproc_progsmooth(U, freqs, voxelSpacing, wvec(n), 0, wvec(n)));
    toc
    time = toc-tic;
    if (n==1)
        eta = time;
    end
    eta = eta - time;
    display('Remaining time ',num2str(eta));
end
