function showopenfigs(waittime,num)
%
% shows all open figs in order
% showopenfigs(waittime,num)
%
% waititme: pause in seconds (1/3 is default)
% num: number of repeat cycles

    figs=sort(get(0,'children'));

    warning off

    if nargin < 1
        waittime = 1/3;
    end
    if nargin < 2
        num=1;
    end
    
    k=0;
    for L=1:length(figs)*num
            k=k+1;
            if k > length(figs) k=1; end
            
            set(0,'currentfigure',figs(k));
            shg
            pause(waittime)
            %ax=get(figs(k),'children');
            %getframe(ax);
    end

    warning on    
        
       