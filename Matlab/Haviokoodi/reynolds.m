function [ Re, virtauksen_tyyppi ] = reynolds( U ,d)
%T�m� funktio laskee Reynoldsin luvun ja palauttaan virtauksen tyypin.

%Parametrit
%U - virtauksen nopeus (m/s)
%d - putken halkaisija (m)
p0 = 1.192; %Ilman tiheys (kg/m3)
myy = 1.833*10^-5; %Ilman viskositeetti Pa*s

%Reynoldsin luku. 
Re = p0*U*d/myy;

% Jos Re < 1000, on virtaus laminaarista. Jos Re >4000 on virtaus
% turbulenttista. V�lialueella ollaan, jos 1000 < Re < 4000. Merkit��n
% t�ss� kuitenkin virtaus turbulenttiseksi ja varoitetaan k�ytt�j��.
if Re < 1000
    virtauksen_tyyppi = 'Laminar';
else
    virtauksen_tyyppi = 'Turbulent';    

end



end

