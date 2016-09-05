function [ lapaisy] = particleLossesGravitation(dp,U,L,d, virtauksen_tyyppi, kallistumiskulma)
%Parametrit
%dp- hiukkaskoko (m)
%U - Virtausnopeus(m/s)
%L - Putken pituus (m)
%d - Putken halkaisija (m)
% Virtauksen tyyppi - kertoo onko virtaus turbulenttista vai laminaarista
%kallistumiskulma - kertoo kulman, missä putki on kallistunut

%Return values:
%lapaisy - gravitaatioon liittyvä läpäisy.
%%
%hiukkasten asettumisnopeus
Vts = gravVelocity(dp);


if strcmp(virtauksen_tyyppi, 'Laminar')
    e = (3/4)*cos(kallistumiskulma).*L.*Vts./(d*U);

    %Läpäisy laminaariselle (Heyder and Gebhart 1977)
    lapaisy = 1-(2/pi)*(2.*e.*sqrt(1-e.^(2/3))-e.^(1/3).*sqrt(1-e.^(2/3))+asin(e.^(1/3))) 
    
else
    %Flow Rate Q
	Q = 0.25*pi*(d)^2*U;
    %Läpäisy turbulenttiselle (Schwendiman 1975)
    lapaisy = exp(-d.*L.*Vts.*cos(kallistumiskulma)./Q); 
    
end





 end

