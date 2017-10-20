function h=plot3dwaves(SIG,cut)
% h=plot3dwaves(SIG,cut)
% cut: treshold for isosurface

if nargin < 2
    cut = 0;
end


si=size(SIG);
%[x,y,z,SIG] = subvolume(SIG,[nan, nan, nan, nan, nan,si(3)/2]);
[x,y,z,SIG] = subvolume(SIG,[nan,nan,nan,nan,nan,nan]);

h=figure('name','waves 3d','numbertitle','off','units','normalized',...
    'position',[0.2561 0.1134 0.6710 0.7813],'keypressfcn','keyfcn');

ax=axes;
p1 = patch(isosurface(x,y,z,SIG,cut),'FaceColor',[0.5 0.5 0.5],'EdgeColor','none');
isonormals(x,y,z,SIG,p1);
%p2 = patch(isocaps(x,y,z,SIG, cut),'FaceColor','interp','EdgeColor','none');
p2 = patch(isocaps(x,y,z,SIG, cut),'FaceColor',[0.3 0.3 0.3],'EdgeColor','none');

lighting gouraud
light('Position',[78.75 87.4519 279.808],'color',[1 1 1],'style','local');
axis tight;
axis image;
%  camlight left;
%  camlight left;
%  camlight left;


set(ax, 'units','normalized',...
        'position',[0 0 1 1],...
        'Projection','perspective',...
        'View',[-37.5 30],...
        'visible','off');