function Y=nowrap2(Y,D,dim)
%
%
%
if nargin < 3
    dim=1;
end

  [diffposx, diffposy]=find(abs(diff(Y,dim)) > D);
   
   if dim == 1
   val=Y(diffposx,:)-Y(diffposx+1,:);
   else dim ==2
   val=Y(:,diffposy)-Y(:,diffposy+1);
   end

  
       
        if dim ==1
        for k=1:size(val,1)
        Y(diffposx(k)+1:end,:)=Y(diffposx(k)+1:end,:)+(Y(diffposx(k)+1:end,1)*0+1)*val(k,:);
        end
        else
        for k=1:size(val,2)
        Y(:,diffposy(k)+1:end)=Y(:,diffposy(k)+1:end)+val(:,k)*(Y(1,diffposy(k)+1:end)*0+1);
        end    
        end

       
       
   %    if val(k) > 0
    %       Y(1:diffpos(k))=Y(1:diffpos(k))-val(k);
    %   else
    %       Y(diffpos(k)+1:end)=Y(diffpos(k)+1:end)-val(k);
    %    end           
       
   
   