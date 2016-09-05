function [haviotKok,haviotTransport, haviotSampling, lapaisyTransport, lapaisySampling] = particleLosses(Q,kuvat, dp,d,L,kallistumiskulma,Uo,inletinAsento, mutkienMaara)

%T�m� on vaihtoehtoinen funktio hiukkash�vi�iden laskemiseen. T�ss� t�ytyy
%itse m��ritt�� kaikki parametrit mit� laskemiseen tarvitaant

%T�t� funktiota kutsuttaessa piirret��n kolme eri kuvaajaa. 
%Figure 1 - Kuljetustehokkuus hiukkaskoon funktiona. Kaikki eri mekanismit
%ovat piirretty
%Figure 2 - N�ytteenoton tehokkuus hiukkaskoon funktiona. Aspiraatio ja
%transmissio tehokkuudet piirret��n erikseen.
%Figure 3 - Kokonaish�vi�t hiukkaskoon funktiona. Kuljetuksesta ja
%n�ytteenotosta aiheutuvat h�vi�t piirret��n kuvaan erikseen.

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
%kuvat - kertoo, piirt��k� funktio kuvaajia (0 ei piirr�, 1 piirt��)
%dp - haluttu hiukkaskoko (m) 
%d - putken sis�halkaisija (m)
%L - n�yteputken pituus
%kallistumiskulma - putken kallistus (asteina, 0 horisontaalinen)
%Uo - Auton nopeus (km/h) 
%inletin asento - inletin asento asteissta (-90-90, 0 horisontaalinen, -90
%pystysuora inletti alasp�in, 90 inletti yl�sp�in
%mutkienMaara -  mutkien m��r� n�yteputkessa


%Return values
%haviotKok - vektori, miss� on kokonaish�vi� jokaiselle hiukkaskoolle.
%haviotTransport- vektori, miss� on kuljetush�vi�t jokaiselle
%hiukkaskoolle
%haviotSampling - vektori, miss� on n�ytteenoton h�vi�t jokaiselle
%hiukkaskoolle.

%%
%Aluksi lasketaan/muutetaan tarvittavat vakiot


%Muutetaan putken virtaus (LPM) nopeudeksi (m/s)
U = (Q*10^-3*(1/60))/(pi*(d/2)^2);

%Reynoldsin luku jotta tiedet��n onko turbulenttista
[Re, virtauksenTyyppi] = reynolds(U,d);

%Muutetaan km/h->m/s
Uo = Uo*10^3/3600;

%Tarvittavat vakiot
kallistumiskulma = kallistumiskulma * (pi/180); %Muutetaan asteet radiaaneiksi

%N�ytteenoton kulma 
naytteenotonKulma = inletinAsento * (pi/180) %T�ll� hetkell� 0

%%
%Kuljetustehokkuus
lapaisyTransport = particleLossesTransport(U, d,dp, L, virtauksenTyyppi, kallistumiskulma,mutkienMaara, kuvat);
%N�ytteenoton tehokkuus
lapaisySampling = particleLossesSampling( U, Uo , dp,d,naytteenotonKulma, kuvat);

% Kokonaistehokkuus
lapaisyKok = lapaisyTransport.*lapaisySampling;
haviotKok = 1-lapaisyKok;
haviotTransport = 1 - lapaisyTransport;
haviotSampling = 1- lapaisySampling;

%%
%Piirret��n kuvaajat
if kuvat == 1 
    figure(3)
    semilogx(dp,lapaisyTransport,'LineWidth',3)
    hold on
    semilogx(dp,lapaisySampling,'LineWidth',3)
    semilogx(dp,lapaisyKok,'LineWidth',3)
    xlabel('dp (m)')
    ylabel('Efficiency')
    % title('KokonaisH�vi�t')
    legend('Transport efficiecny', 'Sampling efficiency', 'Overall efficiency')
end



end

