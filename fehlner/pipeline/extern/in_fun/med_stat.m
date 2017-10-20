function [sens spec pospred negpred youden MCC best_cutoff_youden best_cutoff_MCC]=med_stat(F1,F2,cutoff)
%
% [sens spec pospred negpred youden MCC best_cutoff_youden best_cutoff_MCC]=med_stat(F1,F2)
% F1 =     healthy
% F2 =     sick
%
% sens:    sensitivity
% spec:    specificity
% pospred: positive predictive value
% negpred: negative predicitive value
% youden:  Youden coefficent
% MCC:     Matthew correlation coefficient

if nargin < 3
cutoff=linspace(min(F1),max(F2),100);
end

for k=1:length(cutoff)
    
warning off
F1s=sort(F1);
F2s=sort(F2);

N=(F1s < cutoff(k));
P=(F2s > cutoff(k));

TN=length(find(N));
FP=length(find(~N));
TP=length(find(P));
FN=length(find(~P));


sens(k)=TP/(TP + FN);
spec(k)=TN/(FP + TN);

pospred(k)=TP / (TP + FP);
negpred(k)=TN / (TN + FN);

youden(k)=sens(k)+spec(k)-1;


MCC(k)= (TP * TN - FP * FN)/sqrt( (TP + FP) * ( TP + FN ) * ( TN + FP ) * ( TN + FN ) );
warning on

end

% ein bisschen glätten, um identische cut-off Werte zu vermeiden
 sens2=wiener2(sens,[1 10]);
 spec2=wiener2(spec,[1 10]);
 youden2=sens2+spec2-1;
 
ind1=round(mean(find(youden2 == max(youden2))));
ind2=round(mean(find(MCC == max(MCC))));

if isnan(ind1)
figure
    plot(youden2)
    find(youden2 == max(youden2))
end

best_cutoff_youden=cutoff(ind1);
best_cutoff_MCC=cutoff(ind2);

% jetzt wieder den ungeglätten Youden
%ind1=round(mean(find(youden == max(youden))));
[tmp I]=sort(youden);
ind1=I(end);

%   figure
%   plot(1:100,sens,1:100,spec,[ind1 ind1],[0 1]);

sens_vec=sens;
spec_vec=spec;
sens=sens(ind1);
spec=spec(ind1);
pospred=pospred(ind1); 
negpred=negpred(ind1);
youden=youden(ind1);
MCC=MCC(ind1);

if sens < spec
 r=spec/sens;
else
 r=sens/spec;
end

inc=0;
while r > 1.5
inc=inc+1;
    ind1=I(end-inc);
sens=sens_vec(ind1);
spec=spec_vec(ind1);

    if sens < spec
 r=spec/sens;
else
 r=sens/spec;
    end
end
    
%  sens=sens(ind2);
%  spec=spec(ind2);
%  pospred=pospred(ind2); 
%  negpred=negpred(ind2);
%  youden=youden(ind2);
%  MCC=MCC(ind2);
