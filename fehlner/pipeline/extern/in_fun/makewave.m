function SIG=makewave(p,U1,p1,U2,p2,U3,p3)
%
% SIG=makewave(p,U1,p1,U2,[p2,U3,p3])
% p: phase of the new wae image
% U1/U2/U3: wave images  
% p1/p2/p3: phases of the corresponding wave images
% if nargin < 5 U(p=0) = U2
%

if nargin < 4
    help makewave
    return
end


p=pi/180*p;
p1=pi/180*p1;




%SIG U0
%SIG=U1*R1-U2*sin(p1)/sin(p2-p1);

if nargin < 5
    
    
    % take U2 as U0
    U0=U2;
    %SIG=U0*sin(p) - U0*cos(p)*sin(p1)/cos(p1) + U1 *cos(p)/cos(p1);
    
    %SIG mit bekanntem U0
    SIG=U1*(sin(p-p1)/tan(p1)+cos(p-p1))-sin(p-p1)/sin(p1)*U0;

    
else
    
    p2=pi/180*p2;
    p3=pi/180*p3;
    R =sin(p-p3)/sin(p3);

    SIG=U3*(R*cos(p3) + cos(p-p3)) -...
    U1*(R*cos(p1) + R*cos(p2-p1)*sin(p1)/sin(p2-p1)) +...
    U2* R*sin(p1) / sin(p2-p1);

end