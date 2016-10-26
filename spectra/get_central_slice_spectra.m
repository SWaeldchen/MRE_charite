function [naives, srs] = get_central_slice_spectra(ym1x, ym4x, om1x, om4x)

sz1x = size(ym1x{1});
sz4x = size(ym4x{1});
mid1x = round(sz1x(3)/2);
mid4x = round(sz4x(3)/2);

naives = [];
srs = [];

for m = 1:5
	ym_naive = cubic_interp_3d(ym1x{m},4);
	om_naive = cubic_interp_3d(om1x{m},4);
	cslc_y1x = ym_naive(:,:,mid4x);
	cslc_o1x = om_naive(:,:,mid4x);
	cslc_y4x = ym4x{m}(:,:,mid4x);
	cslc_o4x = om4x{m}(:,:,mid4x);

	cslc_y1x_ft = spectradb(cslc_y1x);
	cslc_y1x_ft(cslc_y1x_ft<-5) = nan;
	naives = cat(3, naives, cslc_y1x_ft);

	cslc_o1x_ft = spectradb(cslc_o1x);
	cslc_o1x_ft(cslc_o1x_ft<-5) = nan;
	naives = cat(3, naives, cslc_o1x_ft);

	cslc_y4x_ft = spectradb(cslc_y4x);
	cslc_y4x_ft(cslc_y4x_ft<-5) = nan;
	srs = cat(3, srs, cslc_y4x_ft);

	cslc_o4x_ft = spectradb(cslc_o4x);
	cslc_o4x_ft(cslc_o4x_ft<-5) = nan;
	srs = cat(3, srs, cslc_o4x_ft);
end		
