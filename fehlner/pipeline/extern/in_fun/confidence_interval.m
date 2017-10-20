function ci=confidence_interval(a,alph)
% ci=confidence_interval(a,alph)
%
% Ermöglicht die Berechnung des 1-Alpha Konfidenzintervalls für den Erwartungswert einer Zufallsvariablen. 
% Ein Konfidenzintervall ist ein Bereich, der sich links und rechts des jeweiligen Stichprobenmittels erstreckt. 
% Beispielsweise können Sie für eine Ware, die Sie per Post zugestellt bekommen, mit einer bestimmten Sicherheit 
% (Konfidenzniveau) vorhersagen, wann die Ware frühestens beziehungsweise spätestens bei Ihnen eintrifft.
%
% Alpha   ist die Irrtumswahrscheinlichkeit bei der Berechnung des Konfidenzintervalls. Das Konfidenzintervall 
% ist gleich 100*(1 - Alpha)%, was bedeutet, dass ein Wert für Alpha von 0,05 einem Konfidenzniveau von 95% entspricht.
% 
% Ist Alpha gleich 0,05, dann muss die Fläche unter der Kurve der
% standardisierten Normalverteilung berechnet werden, die dem Wert (1 - Alpha) bzw. 95% entspricht. 
% Dieser Wert ist ± 1,96. Für das Konfidenzintervall gilt daher:
% std(a)/sqrt(length(a))*1.96)
% %
% 80                        1.28
% 85                        1.44
% 90                        1.645
% 95                        1.96
% 99                        2.575


%Level=[80 85 90 95 99];
%Z=[1.28 1.44 1.645 1.96 2.575];

if nargin < 2
    alph=0.05;
end
    
if alph == 0.05
    Z = 1.96;
elseif alph == 0.01
    Z = 2.575;
else
    error('wrong alpha!')
end

ci=std(a)/sqrt(length(a))* Z;

% disp('median (abweichung)')
% disp([num2str(median(a)) ' (' num2str(ci) ')'])
