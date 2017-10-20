function hs=plot3dwaves_slices(SIG,achse,param,cut)
%
% hs=plot3dwaves_slices(SIG,param,A,cut)
% achse: axis of rotation
% param: matrix of paramters for each row coinciding with the parameters of plot3dwaves2(3)
% cut amplitude treshold for isosurfaces
if nargin < 4
    cut = 0;
end


si=size(SIG);
[x,y,z,SIG] = subvolume(SIG,[nan,nan,50,100,nan,nan]);
%[x,y,z,SIG] = subvolume(SIG,[nan,nan,nan,nan,nan,nan]);

h=figure('name','waves 3d','numbertitle','off','units','normalized',...
    'position',[0.2561 0.1134 0.6710 0.7813],'keypressfcn','keyfcn');

ax=axes;
p1 = patch(isosurface(x,y,z,SIG,cut),'FaceColor',[0.5 0.5 0.5],'EdgeColor','none');
isonormals(x,y,z,SIG,p1);
p2 = patch(isocaps(x,y,z,SIG, cut),'FaceColor',[0.3 0.3 0.3],'EdgeColor','none');

    
 hold on   
for k=1:size(param,1)
    
    [x, y, z,]=makeslice(si,achse,param(k,:));
    hs=slice(SIG*0,x,y,z);
    %set(hs,'Edgecolor','none','Facecolor',[0 0 0],'Facealpha',A);
    set(hs,'Facecolor','none','MeshStyle','both','linewidth',3);
end

lighting gouraud
%light('Position',[78.75 87.4519 279.808],'color',[1 1 1],'style','local');

axis tight;
axis image;
camlight left;
camlight left;
camlight left;


set(ax, 'units','normalized',...
        'position',[0 0 1 1],...
        'Projection','perspective',...
        'View',[-37.5 30],...
        'visible','off');
