brain1x = brain1Mag_1x(:,:,5);
brain1x(isnan(brain1x))=0;
brain1x_ups = imresize(brain1x,4, 'bilinear');

brain2x = brain1Mag_2x(:,:,5);
brain2x(isnan(brain2x))=0;
brain2x_ups = imresize(brain2x, 2, 'bilinear');

brain4x = brain1Mag_4x(:,:,5);
brain4x(isnan(brain4x)) = 0;

brain1x_ft = abs(fftshift(fft2(brain1x)));
brain2x_ft = abs(fftshift(fft2(brain2x)));
brain1x_db = log(normalizeImage(brain1x_ft)) / log(10);
brain2x_db = log(normalizeImage(brain2x_ft)) / log(10);
brain1x_ups_db = log(normalizeImage(abs(fftshift(fft2(brain1x_ups))))) / log(10);
brain2x_ups_db = log(normalizeImage(abs(fftshift(fft2(brain2x_ups))))) / log(10);
brain4x_ft = abs(fftshift(fft2(brain4x)));
brain4x_db = log(normalizeImage(brain4x_ft)) / log(10);

montage = cat(2, brain1x_ups_db, brain2x_ups_db, brain4x_db);
openImage(montage, MIJ);
cutoff = -10;
xlims = [cutoff 0];
ylims = [0 2000];
figure(1);
subplot(1, 3, 1); histogram(brain1x_db(brain1x_db>=cutoff), 32); xlim(xlims); ylim(ylims);
subplot(1, 3, 2); histogram(brain2x_db(brain2x_db>=cutoff), 32); xlim(xlims); ylim(ylims);
subplot(1, 3, 3); histogram(brain4x_db(brain4x_db>=cutoff), 32); xlim(xlims); ylim(ylims);
%{
figure(2);
subplot(1, 3, 1); histogram(brain1x_ft, 16); %xlim(xlims); ylim(ylims);
subplot(1, 3, 2); histogram(brain2x_ft, 16); %xlim(xlims); ylim(ylims);
subplot(1, 3, 3); histogram(brain4x_ft, 16);% xlim(xlims); ylim(ylims);
%}
brain1x_cut = brain1x_db(brain1x_db>=cutoff);
brain2x_cut = brain2x_db(brain2x_db>=cutoff);
brain4x_cut = brain4x_db(brain4x_db>=cutoff);

count = [numel(brain1x_cut) numel(brain2x_cut) numel(brain4x_cut)]
energy = [sum(brain1x_cut.^2) sum(brain2x_cut.^2) sum(brain4x_cut.^2)]


