function unwrap = rga_progressive(wrap, rg4d)
% rg4d must be an instance of Java class com.ericbarnhill.phaseTools.RG4D
wrap = double(wrap);
wrap = (wrap - min(wrap(:))) ./ (max(wrap(:)) - min(wrap(:))) * 2* pi;
sz = size(wrap);
if numel(sz) ~= 4
	display('4D data required for RGA progressive');
	return;
end

unwrap_4d = rg4d.unwrapArray(wrap);
unwrap_3d = zeros(size(unwrap_4d));
for t = 1:sz(4)
	wrap_3d = zeros(sz(1), sz(2), sz(3), 1);
	wrap_3d(:,:,:,1) = unwrap_4d(:,:,:,t);
	unwrap_3d(:,:,:,t) = rg4d.unwrapArray(wrap_3d);
end
unwrap_2d = zeros(size(unwrap_3d));
for t = 1:sz(4)
	for z = 1:sz(3)
		wrap_2d = zeros(sz(1), sz(2), 1, 1);
		wrap_2d(:,:,1,1) = unwrap_3d(:,:,z,t);
		unwrap_2d(:,:,z,t) = rg4d.unwrapArray(wrap_2d);
	end
end
unwrap = unwrap_2d;
