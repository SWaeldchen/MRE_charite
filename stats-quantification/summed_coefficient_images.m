function [w_sum] = summed_coefficient_images(v, T);

if ndims(v) ~= 4
	display('summed_coefficient_images is a 4D method.');
	return;
end

sz = size(v);
pwr2_y = nextpwr2(sz(1));
pwr2_x = nextpwr2(sz(2));
pwr2_z = nextpwr2(sz(3));
pwrmax = max(pwr2_y, max(pwr2_x, pwr2_z));
pad_vec = [pwrmax, pwrmax, pwrmax];
v_pad = zeros([pad_vec, sz(4)]);

for n = 1:3	
	v_pad(:,:,:,n) = simplepad(v(:,:,:,n), pad_vec);
end



[Faf, Fsf] = FSfarras;
[af, sf] = dualfilt1;
J = 1;
w_n = cell(3,1);
w_sum = cell(3,1);

%reset w_sum to zeros
for n = 1:3
	w_n{n} = cplxdual3D(v_pad(:,:,:,n),J,Faf,af);
	w_sum{n} = w_n{n};
	for j = 1:J
		for s1 = 1:2
		    for s2 = 1:2
		        for s3 = 1:2
		            w_sum{n}{j}{1}{s1}{s2}{s3} = zeros(size(w_n{n}{j}{1}{s1}{s2}{s3}));
		            w_sum{n}{j}{2}{s1}{s2}{s3} = [];
		        end
		    end
		end
	end
end


% sum abs at each voxel
for n = 1:3
	for j = 1:J
		for s1 = 1:2
		    for s2 = 1:2
		        for s3 = 1:7
		            a = w_n{n}{j}{1}{s1}{s2}{s3};
		            b = w_n{n}{j}{2}{s1}{s2}{s3};
		            C = a + 1i*b;
		            w_sum{1}{j}{1}{s1}{s2}{s3} = w_sum{1}{j}{1}{s1}{s2}{s3} + abs(C);
		        end
		    end
		end
	end
end

% threshold

