load('firstHarmonic_FD');
subj{1} = firstHarmCorr;
load('firstHarmonic_HT');
subj{2} = firstHarmCorr;
load('firstHarmonic_IS');
subj{3} = firstHarmCorr;
load('firstHarmonic_JG');
subj{4} = firstHarmCorr;
clear firstHarmCorr
mu = cell(4, 3);
mag = cell(4,3);
preprocs = cell(4,3);
freqvec = [20 25 30];
spacing = [.002 .002 .002];
for b = 1:4
    for n = [1 2 4]
        preprocs{b, n} = sfwi_preprocess_stationary(subj{b}(:,:,:,:,:,n), 0, 0, 1, 0.14, 0.35);
        mu{b, n} = abs(full_wave_inversion(preprocs{b, n}, freqvec, spacing, 1, 2));
        mag{b, n} = finish_from_hodge(preprocs{b, n}, freqvec, spacing, 2, 10);
        save('sfwi_hypo', 'mu', 'mag', 'preprocs');
    end
end

