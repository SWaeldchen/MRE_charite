function dat = wavepeaks(profile)

dat=[1 0]';
D = gradient(profile);
p = 1;
for k = 2:1:length(profile)
    if (sign(D(1,k)) ~= sign(D(1,k-1)))
        dat(1,p) = k;
        dat(2,p) = profile(1,k);
        p = p+1;
    end;    
end;


