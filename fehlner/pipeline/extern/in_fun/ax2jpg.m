function ax2jpg(ax,p)
%
% save image of axes as jpg
%

if nargin < 1
    ax = gca;
end


here=pwd;

if nargin < 2
    p=here;
end

cd(p);
[n p]=uiputfile('*.jpg','save as jpg');
cd(here)
n
if n == 0
    return
end

n=strrep(n,'.jpg','');
pn=[p n '.jpg'];

h=get(ax,'Children');

if strcmp(get(h,'type'),'image')
    
im=get(h,'Cdata');


mi=min(min(im));

im=im-mi;

ma=max(max(im));


im=im/ma;

imwrite(im,pn,'quality',100);

end