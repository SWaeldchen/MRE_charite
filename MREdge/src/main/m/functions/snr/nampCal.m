function [n_amp]=nampCal(displacement)
    y=fft(displacement,8,4);
    y(:,:,:,2,:,:)=0;
    y(:,:,:,8,:,:)=0;
    noise=squeeze(std(ifft(y,8,4),0,4));
    % EB testing
    n_amp=sqrt(2/8)*(2*round(rand(size(noise)))-1).*noise;    
    %n_amp=sqrt(2/8).*noise;    
end