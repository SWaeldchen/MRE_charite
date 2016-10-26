function [mag, phi] = ESP_multisession(x, freqvec, spacing)

sz = size(x);

sessions = sz(6);
mag = cell(sessions,1);
phi = cell(sessions,1);
for n = 1:sessions
	[mag{n}, phi{n}] = ESP_v0_51d(x(:,:,:,:,:,n), freqvec, spacing);
end
