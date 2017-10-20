function find_normals(x,y)


 xy=[x(:) y(:)]';
 v=(xy(:,2:end)-xy(:,1:end-1))/2;
 %L=sqrt(sum((v).^2,1));
 L=2;
 vn(2,:)=-v(1,:).*L./v(2,:);
 vn(1,:)=L;
 
 n=sqrt(sum((vn).^2,1));
 
 for k=1:length(vn) hold on; line([0 vn(1,k)]+xy(1,k),[0 vn(2,k)]+xy(2,k),'color','r'); end
 plot(x,y);shg
 
