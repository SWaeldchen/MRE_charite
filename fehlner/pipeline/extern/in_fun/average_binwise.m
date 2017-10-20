function a2=average_binwise(a,bins)

vec=round(linspace(1,length(a),bins+1));
%vec=1:round(length(a)/bins):length(a);
mat=zeros(length(vec)-1,length(a));
num=zeros(length(vec)-1,1);
for k=1:length(vec)-1 
    mat(k,vec(k):vec(k+1))=1;
    num(k)=length(vec(k):vec(k+1));
end
a2=sum((ones(length(vec)-1,1)*a(:)').*mat,2)./num;


% figure
% plot(1:length(a),a,'.',linspace(1,length(a),bins),a2)