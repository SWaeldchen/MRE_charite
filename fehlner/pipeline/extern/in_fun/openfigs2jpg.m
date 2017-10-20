function openfigs2jpg(name)
%
%
%

if nargin < 1
    name=[];
end

figs=findobj(0,'type','figure');

for k=1:length(figs)
    
  set(0,'currentfigure',figs(k))
  shg
  n=num2str(1000+k);
  print(figs(k), '-djpeg', [name n(2:end)]);
  
end