function [haviotKok] = particle_losses(Q,dp,Uo)

%Funktio laskee hiukkashäviöt annetuilla parametreillä. Otetaan huomioon
%näytteenotontehokkuus ja kuljetustehokkuus. Tämä on  pääfunktio joka
%kutsuu muita funktioita. Funktio palauttaa vektorin, jossa on häviö
%jokaiselle hiukkaskoolle.

%TÄtä funktiota kutsuttaessa piirretään neljä eri kuvaajaa. 
%Figure 1 - Kuljetustehokkuus hiukkaskoon funktiona. Kaikki eri mekanismit
%ovat piirretty
%Figure 2 - Kokonaiskuljetushäviöt hiukkaskoon funktiona
%Figure 3 - Näytteenoton tehokkuus hiukkaskoon funktiona. Aspiraatio ja
%transmissio tehokkuudet piirretään erikseen.
%Figure 4 - Kokonaishäviöt hiukkaskoon funktiona. Kuljetuksesta ja
%näytteenotosta aiheutuvat häviöt piirretään kuvaan erikseen.

% Parametrit:
%Q - putken virtaus (LPM)
%dp - haluttu hiukkaskoko (m) (vapaaehtoinen)
%Uo - Auton nopeus (km/h) (vapaaehtoinen)


%Return values
%haviotKok - vektori, missä on häviö jokaiselle hiukkaskoolle.

if nargin == 1
    dp = [0.001:0.01:100]*10^-6 %Luodaan hiukkaskokovektori 0.001 mikrosta 100 mikroon
    Uo = 0; %Oletuksena näytteenotto pysähtyneestä ilmasta
elseif nargin == 2
    Uo = 0; %Oletuksena näytteenotto pysähtyneestä ilmasta
end

%%
%Aluksi lasketaan/muutetaan tarvittavat vakiot
for i = 1:5

if i == 1
    %Auton putken halkaisija 12mm
    d = 0.010; %(m)
    %Auton putken pituus 2.5 m
    L = 1 %(m)
    %kallistumiskulma 0
    kallistumiskulma = 0;

    %Muutetaan putken virtaus (LPM) nopeudeksi (m/s)
    Q = 1
    U = (Q*10^-3*(1/60))/(pi*(d/2)^2);

    %Reynoldsin luku jotta tiedetään onko turbulenttista
    [Re, virtauksenTyyppi] = reynolds(U,d);

    %Muutetaan km/h->m/s
    Uo = Uo*10^3/3600;

    %Tarvittavat vakiot
    kallistumiskulma = kallistumiskulma * (pi/180); %Muutetaan asteet radiaaneiksi
elseif i == 2
        %Auton putken halkaisija 12mm
    d = 0.010; %(m)
    %Auton putken pituus 2.5 m
    L = 1 %(m)
    %kallistumiskulma 0
    kallistumiskulma = 0;

    %Muutetaan putken virtaus (LPM) nopeudeksi (m/s)
    Q = 1
    U = (Q*10^-3*(1/60))/(pi*(d/2)^2);

    %Reynoldsin luku jotta tiedetään onko turbulenttista
    [Re, virtauksenTyyppi] = reynolds(U,d);

    %Muutetaan km/h->m/s
    Uo = Uo*10^3/3600;

    %Tarvittavat vakiot
    kallistumiskulma = kallistumiskulma * (pi/180); %Muutetaan asteet radiaaneiksi
    mutkia = 1
    
elseif i == 2
        %Auton putken halkaisija 12mm
    d = 0.010; %(m)
    %Auton putken pituus 2.5 m
    L = 5 %(m)
    %kallistumiskulma 0
    kallistumiskulma = 0;

    %Muutetaan putken virtaus (LPM) nopeudeksi (m/s)
    Q = 1
    U = (Q*10^-3*(1/60))/(pi*(d/2)^2);

    %Reynoldsin luku jotta tiedetään onko turbulenttista
    [Re, virtauksenTyyppi] = reynolds(U,d);

    %Muutetaan km/h->m/s
    Uo = Uo*10^3/3600;

    %Tarvittavat vakiot
    kallistumiskulma = kallistumiskulma * (pi/180); %Muutetaan asteet radiaaneiksi
    mutkia = 1
    
end



%%
%Kuljetustehokkuus
lapaisyTransport = particleLossesTransport(U, d,dp, L, virtauksenTyyppi, kallistumiskulma,mutkia);
%Näytteenoton tehokkuus
lapaisySampling = particleLossesSampling( U, Uo , dp,d);

% Kokonaistehokkuus
lapaisyKok = lapaisyTransport.*lapaisySampling;
haviotKok = 1-lapaisyKok;

%%
%Piirretään kuvaajat
figure(4)
semilogx(dp,lapaisyKok,'LineWidth',3)
hold on
xlabel('dp (m)')
ylabel('Läpäisy')
% title('KokonaisHäviöt')
legend('Kuljetustehokkuus', 'Sisäänmenotehokkuus', 'Kokonaistehokkuus')

end

end