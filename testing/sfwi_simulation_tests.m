function [sfwi_res, helm_res, mdev_res] = sfwi_simulation_tests(U, freqvec, spacing, den_facs, freq_combs, sigmas, tempfile)

%den_facs = [0.05 0.1 0.3 0.5]; %#ok<*NBRAK>
n_den_facs = numel(den_facs);
%freq_combs = {[1 1], 1:2, 1:6};
n_freqs = numel(freq_combs);
%sigmas = pct_to_db([0.01 0.03 0.05 0.1], 'power');
n_sigmas = numel(sigmas);

sfwi_res = cell(n_freqs, n_sigmas, n_den_facs);
mdev_res = cell(n_freqs, n_sigmas, n_den_facs);
helm_res = cell(n_freqs, n_sigmas, n_den_facs);

sz = size(U);

for f = 1:n_freqs
   for s = 1:n_sigmas
       for df = 1:n_den_facs
            tic
            % add noise
            disp([num2str(f), ' ', num2str(s), ' ', num2str(df)]);
            disp([num2str(sigmas(s)),'dB ',num2str(den_facs(df)), ' den fac']);
            U_noise = reshape(awgn_eb(U(:), sigmas(s), 'measured'), sz);
            U_noise = mir(U_noise);
            preproc = sfwi_preprocess(U_noise(:,:,:,:,:,freq_combs{f}), 0, 1, 1, den_facs(df), den_facs(df));
            [mu_sfwi, mu_helm] = sfwi_inversion_3(preproc, freqvec(freq_combs{f}), spacing);
            mag = finish_from_hodge(preproc, freqvec, spacing, 3, 0, 0);
            sfwi_res{f,s,df} = mu_sfwi;
            helm_res{f,s,df} = mu_helm;
            mdev_res{f,s,df} = mag;
            save(tempfile);
            toc
        end
    end
end

