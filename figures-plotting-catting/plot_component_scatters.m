function plot_component_scatters(amp, inv, skip, ymax)

sz = size(amp);
if size(inv) ~= sz
    display('amplitude and inversion must be same size');
    return;
end
if nargin < 3
	ymax = 5000;
	if nargin < 2
		skip = 1;
	end
end

figure(2);
for m = 1:sz(4)
    for n = 1:sz(5)
        index = ((m-1)*sz(5))*2+n;
        amp_temp = abs(middle_circle(amp(:,:,:,m,n)));
        inv_temp = middle_circle(inv(:,:,:,m,n));
        amp_temp = amp_temp(:);
        inv_temp = inv_temp(:);
        inv_threshed = inv_temp < 20000;
        amp_temp = amp_temp(~isnan(amp_temp(inv_threshed)));
        inv_temp = inv_temp(~isnan(inv_temp(inv_threshed)));
        display(index)
        subplot(sz(4)*2,sz(5),index); scatter(amp_temp(1:skip:end), inv_temp(1:skip:end), '.');
        xlabel('Amplitude'); ylabel('Stiffness'); title(['Component ',num2str(n),' ',num2str(m)]); ylim([0 ymax]); xlim([0 5]);
    end
end

for m = 1:sz(4)
    for n = 1:sz(5)
        index = ((m-1)*sz(5))*2+sz(5)+n;
        amp_temp = abs(middle_circle(amp(:,:,:,m,n)));
        inv_temp = middle_circle(inv(:,:,:,m,n));
        amp_temp = amp_temp(:);
        inv_temp = inv_temp(:);
        inv_threshed = inv_temp < 20000;
        amp_temp = amp_temp(~isnan(amp_temp(inv_threshed)));
        display(index)
        subplot(sz(4)*2,sz(5),index); histogram(amp_temp(1:skip:end));xlim([0 5]);
    end
end
