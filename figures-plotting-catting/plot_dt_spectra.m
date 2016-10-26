function mont = plot_dt_spectra(af11, af12, af21, af22)


w1R = af11*af11';
w2R = af11*af12';
w3R = af12*af11';
w4R = af12*af12';

w1I = af21*af21';
w2I = af21*af22';
w3I = af22*af21';
w4I = af22*af22';

w1 = w1R + 1i*w1I;
w2R_ = w2R + w2I;
w2I_ = w2R - w2I;
w3R_ = w3R + w3I;
w3I_ = w3R - w3I;
w4R_ = w4R + w4I;
w4I_ = w4R - w4I;

w2 = w2R_ + 1i*w2I_;
w3 = w3R_ + 1i*w3I_;
w4 = w4R_ + 1i*w4I_;

w1f = abs(fftshift(fft2(w1)));
w2f = abs(fftshift(fft2(w2)));
w3f = abs(fftshift(fft2(w3)));
w4f = abs(fftshift(fft2(w4)));

w1Rf = abs(fftshift(fft2(w1R)));
w2Rf = abs(fftshift(fft2(w2R)));
w3Rf = abs(fftshift(fft2(w3R)));
w4Rf = abs(fftshift(fft2(w4R)));

w1If = abs(fftshift(fft2(w1I)));
w2If = abs(fftshift(fft2(w2I)));
w3If = abs(fftshift(fft2(w3I)));
w4If = abs(fftshift(fft2(w4I)));

mont1 = cat(2, abs(w1), abs(w2), abs(w3), abs(w4));
mont2 = cat(2, w1f, w2f, w3f, w4f);
mont3 = cat(2, w1R, w2R, w3R, w4R);
mont4 = cat(2, w1Rf, w2Rf, w3Rf, w4Rf);
mont5 = cat(2, w1I, w2I, w3I, w4I);
mont6 = cat(2, w1If, w2If, w3If, w4If);
mont = cat(1, mont1, mont2, mont3, mont4, mont5, mont6);