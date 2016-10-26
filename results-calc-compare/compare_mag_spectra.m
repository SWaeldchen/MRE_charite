function [f, e] = compare_mag_spectra(x)

sz = size(x);
n_subj = sz(1);
n_levels = sz(2);
slices = size(x{1,1},3);
%middle_slice = round(slices/2);
f = zeros(n_subj, n_levels);
e = zeros(n_subj, n_levels);
for i = 1:n_subj
    for j = 1:n_levels
        f_acq = 0;
        e_acq = 0;
        for k = 1:slices
            sl = x{i,j}(:,:,k);
            sl(isnan(sl)) = 0;
            image_ft_log = log(normalizeImage(abs(fftshift(fft2(sl))))) / log(10);
            passed_f = find(image_ft_log>=-3);
            image_ft_en = normalizeImage(abs(fftshift(fft2(sl))));
            f_acq = f_acq + numel(passed_f);
            e_acq = e_acq + sum(image_ft_en(passed_f));
            if (i == 1 && j == 1)
                ii = image_ft_log;
                ii(~passed_f) = 0;
                assignin('base', 'im1x', ii);
            end
            if (i == 1 && j == 2)
                ii = image_ft_log;
                ii(~passed_f) = 0;
                assignin('base', 'im2x', ii);
            end
            if (i == 1 && j == 3)
                ii = image_ft_log;
                ii(~passed_f) = 0;
                assignin('base', 'im4x', ii);
            end
        end
        e(i,j) = e_acq;
        f(i,j) = f_acq;
    end
end
