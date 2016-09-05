function [ kokLapaisy ] = particleLossesTransport(U, d,dp, L, virtauksenTyyppi, kallistumiskulma, mutkia, kuvat)
%Funktio laskee putkiston kuljetustehokkuuden annetuilla parametreilla

% Parametrit:
%U - putken virtaus (m/s)
%d - putken halkaisija (m)
%dp - hiukkaskoko (m)
%L - Putken pituus (m)
%virtauksenTyyppi - kertoo onko virtaus turbulenttista vai laminaarista
%kallistumiskulma - kertoo putken kallistumiskulman (asteina)
%mutkia - kuinka monta mutkaa mittausj�restelyss� on
%kuvat - kertoo, piirret��nk� kuvaajia (0 kuvia ei piirret�, 1 kuvat
%piiret��n)

%Return values:
%kokLapaisy - kuljetustehokkuuden kokonaisl�p�isy.

%%
%Lasketaan jokaiselle mekanismille erikseen l�p�isy
%Diffuusiohaviot
lapaisyDif = particleLossesDiffusion(dp,U, virtauksenTyyppi, L, d);   
%Gravitaatio
 lapaisyGrav = particleLossesGravitation(dp,U,L,d, virtauksenTyyppi, kallistumiskulma);
%Turbulentti asettuminen
if strcmp(virtauksenTyyppi, 'Turbulent')
    lapaisyTurb = particleLossesTurbulent(dp,U,L,d);
else
    lapaisyTurb = ones(1,length(dp));
end
%Mutkat. K�ytet��n autossa olevia mutkia eli kaksi mutkaa
%Alustetaan lapaisyMutkaKok
lapaisyMutkaKok = 1;
for i  = 1:mutkia
    lapaisyMutka = particleLossesBend(dp, U, d ,90);
    lapaisyMutkaKok = lapaisyMutkaKok.*lapaisyMutka;
end

%kokonaisl�p�isy
kokLapaisy = lapaisyDif.*lapaisyGrav.*lapaisyTurb.*lapaisyMutkaKok;

%%

%kuvaajat
if kuvat == 1
    if mutkia > 0
        figure(1)
        semilogx(dp,kokLapaisy,'k','LineWidth',3)
        xlabel('dp (m)')
        ylabel('Efficiency')
        hold on
        semilogx(dp,lapaisyTurb,'--','LineWidth',3)
        semilogx(dp,lapaisyMutkaKok,'--', 'LineWidth',3)
        semilogx(dp,lapaisyDif,'--','LineWidth',3)
        semilogx(dp,lapaisyGrav,'--','LineWidth',3)
        legend('Overall', 'Turbulent','Bend', 'Diffusion', 'Gravitation')
        title('Transport efficiency')
    else
        figure(1)
        semilogx(dp,kokLapaisy,'k','LineWidth',3)
        xlabel('dp (m)')
        ylabel('Efficiency')
        hold on
        semilogx(dp,lapaisyTurb,'g','LineWidth',3)
        semilogx(dp,lapaisyGrav,'b','LineWidth',3)
        semilogx(dp,lapaisyDif,'r','LineWidth',3)
        legend('Overall', 'Turbulent','Gravitation', 'Diffusion')
        title('Transport efficiency')
    end
end



    

end
