for n = 1:3
    brain_pad = simplepad(brain(:,:,:,n), [128 128 128]);
    brain_den(:,:,:,n) = DT_OGS(brain_pad);
end