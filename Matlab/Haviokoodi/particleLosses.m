function [haviotKok,haviotTransport, haviotSampling, lapaisyTransport, lapaisySampling] = particleLosses(Q,kuvat, dp,d,L,kallistumiskulma,Uo,inletinAsento, mutkienMaara)

%Tämä on vaihtoehtoinen funktio hiukkashäviöiden laskemiseen. Tässä täytyy
%itse määrittää kaikki parametrit mitä laskemiseen tarvitaant

%TÄtä funktiota kutsuttaessa piirretään kolme eri kuvaajaa. 
%Figure 1 - Kuljetustehokkuus hiukkaskoon funktiona. Kaikki eri mekanismit
%ovat piirretty
%Figure 2 - Näytteenoton tehokkuus hiukkaskoon funktiona. Aspiraatio ja
%transmissio tehokkuudet piirretään erikseen.
%Figure 3 - Kokonaishäviöt hiukkaskoon funktiona. Kuljetuksesta ja
%näytteenotosta aiheutuvat häviöt piirretään kuvaan erikseen.

%Tarvittavat funktiot:

%	particleLossesTransport.m
%	particleLossesSampling.m
%	particleLossesDiffusion.m
%	particleLossesGravitation.m
%	particleLossesTurbulent.m
%	particleLossesBend.m
%	particleLossesTransmission.m
%	particleLossesAspiration.m
%	stokes.m
%	reynolds.m
%	gravVelocity.m
%	cunningham.m


% Parametrit:

%Q - putken virtaus (LPM)
%kuvat - kertoo, piirtääkö funktio kuvaajia (0 ei piirrä, 1 piirtää)
%dp - haluttu hiukkaskoko (m) 
%d - putken sisähalkaisija (m)
%L - näyteputken pituus
%kallistumiskulma - putken kallistus (asteina, 0 horisontaalinen)
%Uo - Auton nopeus (km/h) 
%inletin asento - inletin asento asteissta (-90-90, 0 horisontaalinen, -90
%pystysuora inletti alaspäin, 90 inletti ylöspäin
%mutkienMaara -  mutkien määrä näyteputkessa


%Return values
%haviotKok - vektori, missä on kokonaishäviö jokaiselle hiukkaskoolle.
%haviotTransport- vektori, missä on kuljetushäviöt jokaiselle
%hiukkaskoolle
%haviotSampling - vektori, missä on näytteenoton häviöt jokaiselle
%hiukkaskoolle.

%%
%Aluksi lasketaan/muutetaan tarvittavat vakiot


%Muutetaan putken virtaus (LPM) nopeudeksi (m/s)
U = (Q*10^-3*(1/60))/(pi*(d/2)^2);

%Reynoldsin luku jotta tiedetään onko turbulenttista
[Re, virtauksenTyyppi] = reynolds(U,d);

%Muutetaan km/h->m/s
Uo = Uo*10^3/3600;

%Tarvittavat vakiot
kallistumiskulma = kallistumiskulma * (pi/180); %Muutetaan asteet radiaaneiksi

%Näytteenoton kulma 
naytteenotonKulma = inletinAsento * (pi/180) %Tällä hetkellä 0

%%
%Kuljetustehokkuus
lapaisyTransport = particleLossesTransport(U, d,dp, L, virtauksenTyyppi, kallistumiskulma,mutkienMaara, kuvat);
%Näytteenoton tehokkuus
lapaisySampling = particleLossesSampling( U, Uo , dp,d,naytteenotonKulma, kuvat);

% Kokonaistehokkuus
lapaisyKok = lapaisyTransport.*lapaisySampling;
haviotKok = 1-lapaisyKok;
haviotTransport = 1 - lapaisyTransport;
haviotSampling = 1- lapaisySampling;

%%
%Piirretään kuvaajat
if kuvat == 1 
    figure(3)
    semilogx(dp,lapaisyTransport,'LineWidth',3)
    hold on
    semilogx(dp,lapaisySampling,'LineWidth',3)
    semilogx(dp,lapaisyKok,'LineWidth',3)
    xlabel('dp (m)')
    ylabel('Efficiency')
    % title('KokonaisHäviöt')
    legend('Transport efficiecny', 'Sampling efficiency', 'Overall efficiency')
end



end

