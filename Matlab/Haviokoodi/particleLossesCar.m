function [haviotKok, haviotTransport, haviotSampling, lapaisyTransport] = particleLossesCar(Q,kuvat, dp,Uo,inletinAsento)

%Funktio laskee hiukkash‰viˆt annetuilla parametreill‰. Otetaan huomioon
%n‰ytteenotontehokkuus ja kuljetustehokkuus. T‰m‰ on  p‰‰funktio joka
%kutsuu muita funktioita. T‰ss‰ funktiossa putken halkaisija, mutkien
%lukum‰‰r‰ ja putken pituus on m‰‰ritetty TTY:n Aerosolifysiikan
%mobiililaboration auton mukaisesti.

%Tƒt‰ funktiota kutsuttaessa piirret‰‰n kolme eri kuvaajaa. 
%Figure 1 - Kuljetustehokkuus hiukkaskoon funktiona. Kaikki eri mekanismit
%ovat piirretty
%Figure 2 - N‰ytteenoton tehokkuus hiukkaskoon funktiona. Aspiraatio ja
%transmissio tehokkuudet piirret‰‰n erikseen.
%Figure 3 - Kokonaish‰viˆt hiukkaskoon funktiona. Kuljetuksesta ja
%n‰ytteenotosta aiheutuvat h‰viˆt piirret‰‰n kuvaan erikseen.

% Parametrit:
%Q - putken virtaus (LPM)
%kuvat - kertoo, halutaanko piirt‰‰ kuvaajia (0 kuvaajia ei piirret‰, 1
%kuvaaja piirret‰‰n. Vapaaehtoinen, oletus 0).
%dp - haluttu hiukkaskoko (m) (vapaaehtoinen, oletuksena hiukkaskokovektori
%0.001 mikrosta 100 mikroon)
%Uo - Auton nopeus (km/h) (vapaaehtoinen, oletus 0)
%inlettinAsento - inletin asento asteina (0 = horisontaalinen, 90 =
%pystsuora, inletti osoittaa ylˆsp‰in, -90 = pystysuora, inletti osoittaa
%alasp‰in. Vaapaaehtoinen, oletus 0)
% HUOM! Ei ole olemassa malleja yli 90 asteen kulmille, jos
%inletti on ollu 180 asteen kulmassa verrattuna virtaukseen on
%suositeltavaa k‰ytt‰‰ 90 asteen kulmaa.


%Return values
%haviotKok - vektori, miss‰ on h‰viˆ jokaiselle hiukkaskoolle.
%haviotTransport - Kuljetuksessa tapahtuvat h‰viˆt.
%haviotSampling - N‰ytteenotossa tapahtuvat h‰viˆt.
if nargin == 1
    kuvat = 0;
    dp = [0.001:0.01:100]*10^-6; %Luodaan hiukkaskokovektori 0.001 mikrosta 100 mikroon
    Uo = 0; %Oletuksena n‰ytteenotto pys‰htyneest‰ ilmasta
    inletinAsento = 0;
elseif nargin == 2
    dp = [0.001:0.01:100]*10^-6; %Luodaan hiukkaskokovektori 0.001 mikrosta 100 mikroon
    Uo = 0; %Oletuksena n‰ytteenotto pys‰htyneest‰ ilmasta
    inletinAsento = 0;
elseif nargin == 3;
    Uo = 0; %Oletuksena n‰ytteenotto pys‰htyneest‰ ilmasta
    inletinAsento = 0;
elseif nargin == 4;
    inletinAsento = 0;
end

%%
%Aluksi lasketaan/muutetaan tarvittavat vakiot


%Auton putken halkaisija 12mm
d = 0.012; %(m)
%Auton putken pituus 2.5 m
L = 2.5; %(m)

%kallistumiskulma putkessa on 0
kallistumiskulma = 0;

%Muutetaan putken virtaus (LPM) nopeudeksi (m/s)
U = (Q*10^-3*(1/60))/(pi*(d/2)^2);

%Reynoldsin luku jotta tiedet‰‰n onko turbulenttista
[Re, virtauksenTyyppi] = reynolds(U,d);
if Re > 1000 && Re < 4000
    disp('Warning: Flow is in transition regime (1000 < Re < 4000), formulas may not work properly')
end
%Muutetaan km/h->m/s
Uo = Uo*10^3/3600;

%Muutetaan asteet radiaaneiksi
kallistumiskulma = kallistumiskulma * (pi/180); 
inletinAsento = inletinAsento * (pi/180); 

%%
%Kuljetustehokkuus
lapaisyTransport = particleLossesTransport(U, d,dp, L, virtauksenTyyppi, kallistumiskulma, 2, kuvat);
%N‰ytteenoton tehokkuus
lapaisySampling = particleLossesSampling( U, Uo , dp,d, inletinAsento, kuvat);

% Kokonaistehokkuus
lapaisyKok = lapaisyTransport.*lapaisySampling;
haviotTransport = 1-lapaisyTransport;
haviotSampling = 1-lapaisySampling;
haviotKok = 1-lapaisyKok;

%%
%Piirret‰‰n kuvaajat
if kuvat == 1
    figure(3)
    semilogx(dp,1-lapaisyTransport,'LineWidth',3)
    hold on
    semilogx(dp,1-lapaisySampling,'LineWidth',3)
    semilogx(dp,haviotKok,'LineWidth',3)
    xlabel('dp (m)')
    ylabel('Losses')
    title('Overall losses')
    legend('Transport losses', 'Sampling losses', 'Overall losses')
end



end
