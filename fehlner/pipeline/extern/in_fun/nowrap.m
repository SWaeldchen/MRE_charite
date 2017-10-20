function nowrap(pl,D)
%
%
%

if nargin < 1
    pl=gco;
end

Y=get(pl,'Ydata');
Yold=Y;

if nargin < 2
    
D=max(diff(Y))/3;



   prompt={'Enter difference parameter:'};
   def={num2str(D)};
   dlgTitle='unwrap';
   lineNo=1;
   answer=inputdlg(prompt,dlgTitle,lineNo,def);
 
   if isempty(answer)
       return
       
   end
   
   
   D=str2num(answer{1});

end

   diffpos=find(abs(diff(Y)) > D);
   
   
   val=Y(diffpos)-Y(diffpos+1);
   
   for k=1:length(val)
       
       Y(diffpos(k)+1:end)=Y(diffpos(k)+1:end)+val(k);
   
   %    if val(k) > 0
    %       Y(1:diffpos(k))=Y(1:diffpos(k))-val(k);
    %   else
    %       Y(diffpos(k)+1:end)=Y(diffpos(k)+1:end)-val(k);
    %    end           
       
   end
   

x=get(pl,'Xdata');
Y2=[Y(1:4:end-1) Y(end)];
x2=[x(1:4:end-1) x(end)];
Y2=interp1(x2,Y2,x,'spline');
set(pl,'Ydata',Y2);
axis tight   

if nargin == 0
   if ~strcmp(questdlg('accept'),'Yes')
       
       
       set(pl,'Ydata',Yold);
       
       
   end
end
   
   axis tight
   
