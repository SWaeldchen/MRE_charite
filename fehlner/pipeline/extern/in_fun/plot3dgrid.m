function h=plot3dwaves(SIG,red,cut,col)
% h=plot3dwaves(SIG,cut)
% cut: treshold for isosurface

if nargin < 2
    cut = 0;
    red=1;
end

if nargin < 3
    cut = 0;
end

if nargin < 4
    col = 'w';
end

si=size(SIG);
%[x,y,z,SIG] = subvolume(SIG,[si(1)/2,nan,si(2)/2,nan,nan,nan]);
[x,y,z,SIG] = subvolume(SIG,[nan,nan,nan,nan,nan,nan]);

h=figure('name','3d grid','numbertitle','off','units','normalized',...
    'position',[0.2561 0.1134 0.6710 0.7813],'keypressfcn','keyfcn');

ax=axes;
p = patch(isosurface(x,y,z,SIG,cut),'facecolor',col,'EdgeColor','b');
reducepatch(p,red);

axis tight;
axis image;


set(ax, 'units','normalized',...
        'position',[0 0 1 1],...
        'Projection','perspective',...
        'View',[-37.5 30],...
        'visible','off');