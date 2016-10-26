function [v_thresh, w_sum] = cdtw_consensus_coefficients(v, T);

sz = size(v);
if numel(sz) < 5
	d5 = 1;
	if numel(sz) < 4
		d4 = 1;
	else
		d4 = sz(4);
	end
else
	d4 = sz(4);
	d5 = sz(5);
end
n_ims = d4*d5;


pwr2_y = nextpwr2(sz(1));
pwr2_x = nextpwr2(sz(2));
pwr2_z = nextpwr2(sz(3));
pwrmax = max(pwr2_y, max(pwr2_x, pwr2_z));
pad_vec = [pwrmax, pwrmax, pwrmax];
v_pad = zeros([pad_vec, d4]);

for n = 1:d5
	for m = 1:d4
		v_pad(:,:,:,m,n) = simplepad(v(:,:,:,m,n), pad_vec);
	end
end

[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 1;
w_n = cell(m,n);

%set sizes within w_sum
w_sum = cplxdual3D(v_pad(:,:,:,1,1),J,Faf,af);

%reset w_sum to zeros
for j = 1:J
	for s1 = 1:2
	    for s2 = 1:2
	        for s3 = 1:2
	            w_sum{j}{1}{s1}{s2}{s3} = zeros(size(w_sum{j}{1}{s1}{s2}{s3}));
	            w_sum{j}{2}{s1}{s2}{s3} = [];
	        end
	    end
	end
end


% collect eact cdwt and sum abs at each voxel of w_sum
for n = 1:d5
	for m = 1:d4
		w_n{m,n} = cplxdual3D(v_pad(:,:,:,m,n),J,Faf,af);
		for j = 1:J
			for s1 = 1:2
				for s2 = 1:2
				    for s3 = 1:7
				        a = w_n{m,n}{j}{1}{s1}{s2}{s3};
				        b = w_n{m,n}{j}{2}{s1}{s2}{s3};
				        C = a + 1i*b;
				        w_sum{j}{1}{s1}{s2}{s3} = w_sum{j}{1}{s1}{s2}{s3} + abs(C) ./ n_ims;
				    end
				end
			end
		end
	end
end

w_thresh = w_n;

% threshold consensus coefficients with nonnegative garotte

for n = 1:d5
	for m = 1:d4
		for j = 1:J
			for s1 = 1:2
				for s2 = 1:2
				    for s3 = 1:7
				        a = w_n{m,n}{j}{1}{s1}{s2}{s3};
				        b = w_n{m,n}{j}{2}{s1}{s2}{s3};
						thresh = w_sum{j}{1}{s1}{s2}{s3};
				        C = a + 1i*b;
						C = ( C - T^2 ./ C ) .* (thresh > T);  
						w_thresh{m,n}{j}{1}{s1}{s2}{s3} = real(C);
						w_thresh{m,n}{j}{2}{s1}{s2}{s3} = imag(C);
				    end
				end
			end
		end
	end
end

% inverse transform

v_thresh_pad = v_pad;

for n = 1:d5
	for m = 1:d4
		v_thresh_pad(:,:,:,m,n) = icplxdual3D(w_thresh{m,n},J,Fsf,sf);
	end
end

v_thresh = v_thresh_pad(1:sz(1), 1:sz(2), 1:sz(3), 1:d4, 1:d5);


