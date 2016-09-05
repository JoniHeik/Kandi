function [haviotKok] = particle_losses(Q,dp,Uo)

%Funktio laskee hiukkash�vi�t annetuilla parametreill�. Otetaan huomioon
%n�ytteenotontehokkuus ja kuljetustehokkuus. T�m� on  p��funktio joka
%kutsuu muita funktioita. Funktio palauttaa vektorin, jossa on h�vi�
%jokaiselle hiukkaskoolle.

%T�t� funktiota kutsuttaessa piirret��n nelj� eri kuvaajaa. 
%Figure 1 - Kuljetustehokkuus hiukkaskoon funktiona. Kaikki eri mekanismit
%ovat piirretty
%Figure 2 - Kokonaiskuljetush�vi�t hiukkaskoon funktiona
%Figure 3 - N�ytteenoton tehokkuus hiukkaskoon funktiona. Aspiraatio ja
%transmissio tehokkuudet piirret��n erikseen.
%Figure 4 - Kokonaish�vi�t hiukkaskoon funktiona. Kuljetuksesta ja
%n�ytteenotosta aiheutuvat h�vi�t piirret��n kuvaan erikseen.

% Parametrit:
%Q - putken virtaus (LPM)
%dp - haluttu hiukkaskoko (m) (vapaaehtoinen)
%Uo - Auton nopeus (km/h) (vapaaehtoinen)


%Return values
%haviotKok - vektori, miss� on h�vi� jokaiselle hiukkaskoolle.

if nargin == 1
    dp = [0.001:0.01:100]*10^-6 %Luodaan hiukkaskokovektori 0.001 mikrosta 100 mikroon
    Uo = 0; %Oletuksena n�ytteenotto pys�htyneest� ilmasta
elseif nargin == 2
    Uo = 0; %Oletuksena n�ytteenotto pys�htyneest� ilmasta
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

    %Reynoldsin luku jotta tiedet��n onko turbulenttista
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

    %Reynoldsin luku jotta tiedet��n onko turbulenttista
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

    %Reynoldsin luku jotta tiedet��n onko turbulenttista
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
%N�ytteenoton tehokkuus
lapaisySampling = particleLossesSampling( U, Uo , dp,d);

% Kokonaistehokkuus
lapaisyKok = lapaisyTransport.*lapaisySampling;
haviotKok = 1-lapaisyKok;

%%
%Piirret��n kuvaajat
figure(4)
semilogx(dp,lapaisyKok,'LineWidth',3)
hold on
xlabel('dp (m)')
ylabel('L�p�isy')
% title('KokonaisH�vi�t')
legend('Kuljetustehokkuus', 'Sis��nmenotehokkuus', 'Kokonaistehokkuus')

end

end