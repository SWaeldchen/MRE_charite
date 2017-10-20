function openfigs2gif(time_delay,out_name)
%
% openfigs2gif(time_delay,out_name)
%

if nargin < 1
    time_delay = 0;
end

if nargin < 2
    out_name='tmp.gif';
end


map=colormap;
figs=findobj(0,'type','figure');
disp(length(figs))
for k=1:length(figs) 
    fprintf(['k ' int2str(k)])
    f=getframe(figs(k));
    cmp=colormap;
    im(:,:,:,k)= rgb2ind(f.cdata,cmp,'nodither');
end

imwrite(im,map,out_name,'DelayTime',time_delay,'LoopCount',inf)