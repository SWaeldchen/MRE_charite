function u_cplx = ft_to_time_steps(u_ft, u_cplx)
TIME_STEPS = 8;
shifts = linspace(0, 2*pi, TIME_STEPS);
sz = size(u_ft);
if numel(sz) < 5 
    d5 = 1;
else
    d5 = sz(5);
end
if numel(sz) < 4
    d4 = 1;
else
    d4 = sz(4);
end
for n = 1:d5
    for m = 1:d4
        field = u_ft(:,:,:,m,n);
        for s = 1:numel(shifts)
            shift = exp(-1i*shifts(s));
            u_cplx(:,:,:,s,m,n) = field * shift;
        end
    end
end
            