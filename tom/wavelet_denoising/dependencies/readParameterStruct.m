function p=readParameterStruct( fileName )
%
% function to read a parameter struct from a file
% Copyright (c) 2018 Elastography Group, Charite Universitätsmedizin Berlin
% Last Change: Tom Meyer 09.01.2018
%

p=struct();
fid = fopen(fileName,'r');
li=fgetl(fid);
while ischar(li) && ~isempty(li)
    eval(['p.' li]);
    li=fgetl(fid);
end

fclose(fid);

end

