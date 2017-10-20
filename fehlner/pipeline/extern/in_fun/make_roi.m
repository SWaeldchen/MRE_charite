function make_roi(name)
%
% make_roi(name)
% ingolf.sack@charite.de

w=dicomread(name);
w=double(w);
figure('name',name)
uimenu('Label','save&close','callback',...
'BW=get(gcf,''userdata''); name=[get(gcf,''name'') ''_roi'']; save(name,''BW''); close gcf');
h=imagesc(w);
colormap gray; 
axis image
shg

ButtonName=3;
while ButtonName == 3
BW2=roipoly;
BW=get(gcf,'userdata');
if ~isempty(BW)
    BW3=BW.*BW2;
else
    BW3=BW2;
end

w0=w;
w=w.*BW3;
set(h,'Cdata',w)

ButtonName = menu('ROI ok?', 'yes', 'discard last','proceed','invert last');

switch ButtonName                     
    case 2
    w=w0;
    set(h,'Cdata',w)
    ButtonName=3;
    case 1   
    set(gcf,'userdata',BW3)
    case 3
    set(gcf,'userdata',BW3)
    case 4
    BW3=BW.*(1-BW2);
    w=w0.*BW3;
    set(h,'Cdata',w)
    BN = questdlg('ok now?', ...
                         'ROI selection', ...
                         'yes', 'discard last','proceed','proceed');
                    switch BN    
                    case 'discard last'
                         w=w0;
                             set(h,'Cdata',w)
                             ButtonName=3;
                        case 'yes'
                         set(gcf,'userdata',BW3)
                        case 'proceed'
                          set(gcf,'userdata',BW3)
                           ButtonName=3;
                    end
                     
                         
end

end