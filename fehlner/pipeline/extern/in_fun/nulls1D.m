function [NS, XX, YY]=nulls1D(Y,prec,flag)
% NS=nulls1D(Y,prec)
% gives the indices NS of the amplitude nulls of ocillations
% Y(NS) = 0;
% prec: optional the precition in times the original length of Y


if nargin < 2
    prec=1;
    
end


X=1:length(Y);
XX=linspace(1,length(Y),length(Y)*prec);
YY=spline(X,Y,XX);


NS=find(diff(sign(YY)))';


if nargin == 3
plot(XX,YY,XX(NS),zeros(1,length(NS)),'.')
end