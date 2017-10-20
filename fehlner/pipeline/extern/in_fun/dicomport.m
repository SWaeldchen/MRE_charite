function w=dicomport(ser,ima)
% w=dicomport(ser,[ima])
% w=dicomport(2);
% w=dicomport(2,1:123);

if nargin < 2
    a=list([num2str(ser) '_*']);
    ima=1:size(a,1);
end

    
for k=1:length(ima)
    
    name=list([num2str(ser) '_' num2str(ima(k)) '_*']);
    w(:,:,k)=double(dicomread(name));

    fprintf([num2str(ima(k)) ' '])

    
end

