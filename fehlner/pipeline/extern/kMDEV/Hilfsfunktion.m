plot2dwaves(c.frequencyResolved(:,:,:,1))
colormap jet
caxis([0 4])
plot2dwaves(c.frequencyResolved(:,:,:,2))
colormap jet
caxis([0 4])

iFrequency=1;
plot2dwaves(reshape(shearWaveField(:,:,3,:,:,iFrequency),[size(shearWaveField,1) size(shearWaveField,2) 12*3]))
caxis([-1 1]*10^3)

iFrequency=1;
plot2dwaves(animate(w3D2w2D(squeeze(shearWaveField(:,:,3,:,1,iFrequency)))));
caxis([-1 1])
% plot2dwaves(animate(w3D2w2D(squeeze(shearWaveField(:,:,3,:,3,iFrequency)))));
% caxis([-1 1])

w=ginput;

clear r
r=sqrt( (w(1:2:end,1)-w(2:2:end,1)).^2 + (w(1:2:end,2)-w(2:2:end,2)).^2  );
disp( [mean(r), std(r)]*2*inplaneResolution(1)*frequency(iFrequency) )

plot2dwaves(a.frequencyResolved(:,:,:,1))
colormap jet
caxis([0 4])
plot2dwaves(a.frequencyResolved(:,:,:,2))
colormap jet
caxis([0 4])

s=get(gco,'ydata');as=abs(hilbert(s));hold on;plot(as)
0.2*exp(-1)


iFrequency=1;
plot2dwaves(reshape(waveField(:,:,3,:,iFrequency),[size(waveField,1) size(waveField,2) 3]))
caxis([-1 1]*10^3)

iFrequency=1;
plot2dwaves(animate(w3D2w2D(squeeze(shearWaveField(:,:,3,:,2,iFrequency)))));