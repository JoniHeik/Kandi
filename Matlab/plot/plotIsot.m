function [haviotElpiMedian ] = plotIsot(flow)

close all
%Funktio tarkoitettu laskemaan isojen hiukkasten pitoisuuksia. 
%Käytetyt laitteet:
%-APS
%-ELPI PLUS
%-ELPI

%Parametrina
%-Mittauksessa käytetty virtaus (lpm)


%Listataan kaikki datat
list = dir('P:\Kandi\Kandimittaukset\dataIsot\2016*.mat');

%KÄydään läpi kaikki listassa olevat tieodostot
for fileIndex = 1:length(list)
    filename = list(fileIndex).name;
    load(filename); %avataan tiedosto
    %Jos tiedostossa oleva flow on sama kuin parametrina annettu
    if dataDay.flow == flow
        elpiPlusDpMean = dataDay.elpiPlus.dpMean;
        elpiDpMean = dataDay.elpi.dpMean;
        apsDp = dataDay.uvAps.dp; %APS:n hiukkaskoot
        %Jos referenssi mittaus, tallennnetaan arvot tänne
        if dataDay.reference == 1
            %OTetaan oikeat arvot 
            if flow == 25
                elpiPlus = dataDay.elpiPlus.dnDlogdp(10:end,:);
                elpi = dataDay.elpi.dndlogdp(10:end,:);
                aps = [dataDay.uvAps.dndlogdp(1:2,:);dataDay.uvAps.dndlogdp(4:end,:)];
            elseif flow == 10
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:200,:);
                elpi = dataDay.elpi.dndlogdp(50:200,:);
                aps = [dataDay.uvAps.dndlogdp(1:5,:)];
            elseif flow == 15
                elpiPlus = dataDay.elpiPlus.dnDlogdp(100:end,:);
                elpi = dataDay.elpi.dndlogdp(100:end,:);
                aps = [dataDay.uvAps.dndlogdp(1:3,:)];
            elseif flow == 20
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:end,:);
                elpi = dataDay.elpi.dndlogdp(50:end,:);
                aps = [dataDay.uvAps.dndlogdp(3:end,:)];
            elseif flow == 30
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:150,:);
                elpi = dataDay.elpi.dndlogdp(50:150,:);
                aps = [dataDay.uvAps.dndlogdp(3:end,:)];
            elseif flow == 35
                elpiPlus = dataDay.elpiPlus.dnDlogdp(10:end,:);
                elpi = dataDay.elpi.dndlogdp(10:end,:);
                aps = [dataDay.uvAps.dndlogdp(1:4,:)];
            elseif flow == 40
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:250,:);
                elpi = dataDay.elpi.dndlogdp(50:250,:);
                aps = [dataDay.uvAps.dndlogdp(1:4,:)];
                
                
                
            end
            
            
            %MEDIAANIT
            elpiPlusReferenceMedian = median(elpiPlus); %ElpiPlus referenssi mittauksen data. 
            elpiReferenceMedian = median(elpi); %Elpi referenssi mittauksen data
            
            apsReferenceMedian = median(aps); %APS referenssi mittauksen data
            elpiDnReferenceMedian = dataDay.elpi.dnMedian;
            elpiPlusDnReferenceMedian = dataDay.elpiPlus.dnMedian;

            
                    
           
            
        else
            if flow == 25
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
                elpi = dataDay.elpi.dndlogdp(50:300,:);
                aps = [dataDay.uvAps.dndlogdp(1:3,:);dataDay.uvAps.dndlogdp(6:end,:)];
                elpiStd = std(elpi);
            elseif flow == 10
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
                elpi = dataDay.elpi.dndlogdp(50:300,:);
                aps = dataDay.uvAps.dndlogdp(1:7,:);
                elpiStd = std(elpi);
            elseif flow == 15
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
                elpi = dataDay.elpi.dndlogdp(50:300,:);
                aps = dataDay.uvAps.dndlogdp(1:8,:);
                elpiStd = std(elpi);
            elseif flow == 20
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:200,:);
                elpi = dataDay.elpi.dndlogdp(50:200,:);
                aps = [dataDay.uvAps.dndlogdp(1:4,:)];
                elpiStd = std(elpi);
            elseif flow == 30
                elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
                elpi = dataDay.elpi.dndlogdp(50:300,:);
                aps = [dataDay.uvAps.dndlogdp(5:6,:)];
                elpiStd = std(elpi);
            elseif flow == 35
                elpiPlus = dataDay.elpiPlus.dnDlogdp(40:110,:);
                elpi = dataDay.elpi.dndlogdp(40:110,:);
                aps = [dataDay.uvAps.dndlogdp(1:5,:)];
                elpiStd = std(elpi);
            elseif flow == 40
                elpiPlus = dataDay.elpiPlus.dnDlogdp(100:250,:);
                elpi = dataDay.elpi.dndlogdp(100:250,:);
                aps = [dataDay.uvAps.dndlogdp(7:end,:)];
                elpiStd = std(elpi);
                
                
            end
            
            
            elpiPlusMittausMedian = median(elpiPlus); %ElpiPlus data
            elpiMittausMedian = median(elpi); %Elpi data
            apsMittausMedian = median(aps); %APS dat
            elpiDnMittausMedian = dataDay.elpi.dnMedian;
            elpiPlusDnMittausMedian = dataDay.elpiPlus.dnMedian;
      
            


            
        end
      
    end
    
end

%Normalisoidaan data. ElpiPlus oli suoraan kiinni hiukkasten generoinnissa

%Jaetaan referenssidata mittaudatalla. Aloitetaan vasta 11 arvosta, sillä
%meitä kiinnostaa vain isot hiukkaste
%8 on 4.828788667978750e-07
%MEDIAANI
elpiPlusNormalisointiMedian = elpiPlusReferenceMedian./elpiPlusMittausMedian;

%Jos jostain syystä on ollut negatiivista dataa, muutetaan se ykköseksi



%%MEDIAANIT
apsMittausMedian = [apsMittausMedian(1:3)*elpiPlusNormalisointiMedian(8) apsMittausMedian(4:9)*elpiPlusNormalisointiMedian(9)...
    apsMittausMedian(10:17)*elpiPlusNormalisointiMedian(10) apsMittausMedian(18:22)*elpiPlusNormalisointiMedian(11)...
    apsMittausMedian(23:29)*elpiPlusNormalisointiMedian(12) apsMittausMedian(30:36)*elpiPlusNormalisointiMedian(13)...
    apsMittausMedian(37:end)*elpiPlusNormalisointiMedian(14)]

elpiMittausMedian = [elpiMittausMedian(1)*elpiPlusNormalisointiMedian(3) elpiMittausMedian(2)*elpiPlusNormalisointiMedian(4)...
    elpiMittausMedian(3)*elpiPlusNormalisointiMedian(5) elpiMittausMedian(4)*elpiPlusNormalisointiMedian(6)...
    elpiMittausMedian(5)*elpiPlusNormalisointiMedian(7) elpiMittausMedian(6)*elpiPlusNormalisointiMedian(8)...
    elpiMittausMedian(7)*elpiPlusNormalisointiMedian(9) elpiMittausMedian(8)*elpiPlusNormalisointiMedian(10)...
    elpiMittausMedian(9)*elpiPlusNormalisointiMedian(11) elpiMittausMedian(10)*elpiPlusNormalisointiMedian(12)...
    elpiMittausMedian(11)*elpiPlusNormalisointiMedian(13) elpiMittausMedian(12)*elpiPlusNormalisointiMedian(14)]

apsMittausMedian = [ mean(apsMittausMedian(1:3)) mean(apsMittausMedian(4:6)) mean(apsMittausMedian(7:9))...
    mean(apsMittausMedian(10:12)) mean(apsMittausMedian(13:15)) mean(apsMittausMedian(16:18)) mean(apsMittausMedian(19:21)) ...
    mean(apsMittausMedian(22:24)) mean(apsMittausMedian(25:27)) mean(apsMittausMedian(28:30)) apsMittausMedian(31:end)]
  
apsReferenceMedian = [ mean(apsReferenceMedian(1:3)) mean(apsReferenceMedian(4:6)) mean(apsReferenceMedian(7:9))...
    mean(apsReferenceMedian(10:12)) mean(apsReferenceMedian(13:15)) mean(apsReferenceMedian(16:18)) mean(apsReferenceMedian(19:21)) ...
    mean(apsReferenceMedian(22:24)) mean(apsReferenceMedian(25:27)) mean(apsReferenceMedian(28:30)) apsReferenceMedian(31:end)]


apsDp = [ mean(apsDp(1:3)) mean(apsDp(4:6)) mean(apsDp(7:9))...
    mean(apsDp(10:12)) mean(apsDp(13:15)) mean(apsDp(16:18)) mean(apsDp(19:21)) ...
    mean(apsDp(22:24)) mean(apsDp(25:27)) mean(apsDp(28:30)) apsDp(31:end)]

%Teoreettiset häviöt
hiukkaskoko = [elpiDpMean(1:5)' apsDp*10^-6]
[haviotTeor haviotTransport haviotSampling] = particleLossesCar(flow,0,hiukkaskoko);
    
% haviot


%Mediaani
haviotAPSMedian = apsMittausMedian./apsReferenceMedian;
for i = 1:length(haviotAPSMedian)
    if haviotAPSMedian(i) > 1
        haviotAPSMedian(i) = 1;
    end
end

haviotAPSMedian = 1- haviotAPSMedian;



haviotElpiMedian = elpiMittausMedian./elpiReferenceMedian;
for i = 1:length(haviotElpiMedian)
    if haviotElpiMedian(i) > 1
        haviotElpiMedian(i) = 1;
    end
end
haviotElpiMedian = 1 - haviotElpiMedian;



% %%
% %KUVAAJIEN PIIRTÄMINEN
% 
%ElpiPlussan data
figure(5)
semilogx(elpiPlusDpMean(3:end),elpiPlusReferenceMedian(3:end),'LineWidth',3)
hold on
semilogx(elpiPlusDpMean(3:end),elpiPlusMittausMedian(3:end),'LineWidth',3)
xlabel('dp (m)')
ylabel('dN/dlogDp (#/cm^3)','Interpreter','none')
legend('Nollamittaus', 'Automittaus')

% 
% 
% % %APS data, mittausdata on normalisoitu
% % figure(6)
% % semilogx(apsDp(3:end),apsReference(3:end),'LineWidth',3)
% % hold on
% % semilogx(apsDp(3:end),apsMittaus(3:end),'LineWidth',3)
% % legend('Referenssi','Mittaus')
% % title('APS')
% % xlabel('dp({\mu}m)')
% % ylabel('dndlogdp')
% 
% % 
%Elpin data. mittausdata on normalisoitu
figure(7)
h  = errorbar(elpiDpMean(2:end)',elpiReferenceMedian(2:end),elpiStd(2:end))
hold on
set(h,'LineWidth',1.5)
set(gca,'xscale','log')
legend('Referenssi')
title('Elpi')
xlabel('dp (m)')
ylabel('dndlogdp')

figure(14)
semilogx(hiukkaskoko,haviotTransport,'LineWidth',3)
hold on
semilogx(apsDp(1:end)*10^-6, haviotAPSMedian(1:end),'*k')
semilogx(elpiDpMean(3:end),haviotElpiMedian(3:end),'*m')
xlabel('dp(m)')
ylabel('Häviöt')
% title('Häviöt mediaani')
legend('Teoreettinen häviö', 'APS häviö', 'Elpi häviö', 'Location','northwest')
% 
%APS data, mittausdata on normalisoitu
figure(15)
semilogx(apsDp(2:end),apsReferenceMedian(2:end),'LineWidth',3)
hold on
semilogx(apsDp(2:end),apsMittausMedian(2:end),'LineWidth',3)
legend('Nollamittaus','Automittaus')
% title('APS Median')
xlabel('dp({\mu}m)')
ylabel('dN/dlogDp')



    
    
end