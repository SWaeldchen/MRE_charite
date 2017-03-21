function mean_amps = harmonic_amplitudes(phase, mask)

nf = size(phase,6);
nc = size(phase,5);
nh = size(phase,4)/2;
mean_amps = zeros(nh,nc,nf);

for p = 1:nf
    for n = 1:nc
        for m = 1:nh
            h = gunwrapFFT(phase(:,:,:,:,n,p), m);
            h_mask = h.*mask;
            mean_amps(m,n,p) = mean(   abs(  h_mask( abs(h_mask)>0 )  )   );
        end
    end
end
    
cmp_labels = {'1', '2', '3'};
freq_labels = {'30', '40', '50', '60'};
labels = cell(nc*nf,1);
figure(1); hold on;
for p = 1:nf
    for n = 1:nc
        label_index = (p-1)*nc + n;
        labels(label_index) = strcat(freq_labels(p),'_', cmp_labels(n));
        plot(mean_amps(:,n,p), 'color', [1 1 p/nf]);
    end
end
legend(labels);
    

