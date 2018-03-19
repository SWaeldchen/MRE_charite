function u_cplx = ft_to_time_steps(u_ft, u_cplx, TIME_STEPS)
if nargin < 3
    TIME_STEPS = 8;
end
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
            shifted_field = field*shift;
            u_cplx(:,:,:,s,m,n) = abs(u_cplx(:,:,:,s,m,n)).*exp(1i*real(shifted_field));
            %u_cplx(:,:,:,s,m,n) = 1i*shifted_field;
        end
    end
end
            