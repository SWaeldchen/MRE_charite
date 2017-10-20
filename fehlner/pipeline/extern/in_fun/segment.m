function x=segment;
%
%
%

here=pwd;
[n p]=uigetfile('*_roi.mat','load roi-file');
cd(here);

if n
    load([p n]);
else
BW=roipoly;
end

im=get(gca,'children');
im=findobj(im,'type','image','visible','on');
CD=get(im,'CData');


ButtonName=questdlg('cut off', ...
                       'segment what', ...
                       'interior','exterior','cancel','cancel');
                   
                   switch ButtonName
                   case 'interior'
                       x=find(BW == 1);
                   case 'exterior'
                       x=find(BW == 0);
                   otherwise
                       x=[];
                   end
                   
CD(x)=0;

set(im,'Cdata',CD);


if (~isempty(x)) & (n == 0)
    
    [n p]=uiputfile('*_roi.mat','save roi-file');
    
    if n
    n=strrep(n,'_roi.mat','');
    save([p n '_roi.mat'],'BW');
    cd(here)
    end
end