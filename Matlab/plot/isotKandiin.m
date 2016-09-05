close all

%Listataan kaikki datat
list = dir('P:\Kandi\Kandimittaukset\dataIsot\2016*.mat');
legendIndex1 = ['Nollamittaus 40 lpm'; 'Nollamittaus 35 lpm'; 'Nollamittaus 30 lpm';'Nollamittaus 25 lpm'; ...
    'Nollamittaus 20 lpm'; 'Nollamittaus 15 lpm'; 'Nollamittaus 10 lpm']

for fileIndex = 1:length(list)
    filename = list(fileIndex).name;
    load(filename); %avataan tiedosto
    elpiPlusDp = dataDay.elpiPlus.dpMean;
    elpiDp = dataDay.elpi.dpMean;
    apsDp = dataDay.uvAps.dp;
    if dataDay.reference == 1
       %OTetaan oikeat arvot 
       if dataDay.flow == 25
           elpiPlus = dataDay.elpiPlus.dnDlogdp(10:end,:);
           elpi = dataDay.elpi.dndlogdp(10:end,:);
           aps = [dataDay.uvAps.dndlogdp(1:2,:);dataDay.uvAps.dndlogdp(4:end,:)];
       elseif dataDay.flow == 10
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:200,:)
           elpi = dataDay.elpi.dndlogdp(50:200,:);
           aps = [dataDay.uvAps.dndlogdp(1:5,:)];
       elseif dataDay.flow == 15
           elpiPlus = dataDay.elpiPlus.dnDlogdp(100:end,:);
           elpi = dataDay.elpi.dndlogdp(100:end,:);
           aps = [dataDay.uvAps.dndlogdp(1:3,:)]
       elseif dataDay.flow == 20
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:end,:)
           elpi = dataDay.elpi.dndlogdp(50:end,:);
           aps = [dataDay.uvAps.dndlogdp(3:end,:)];
       elseif dataDay.flow == 30
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:150,:);
           elpi = dataDay.elpi.dndlogdp(50:150,:);
           aps = [dataDay.uvAps.dndlogdp(3:end,:)];
       elseif dataDay.flow == 35
           elpiPlus = dataDay.elpiPlus.dnDlogdp(10:end,:);
           elpi = dataDay.elpi.dndlogdp(10:end,:);
           aps = [dataDay.uvAps.dndlogdp(1:4,:)];
       elseif dataDay.flow == 40
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:250,:);
           elpi = dataDay.elpi.dndlogdp(50:250,:);
           aps = [dataDay.uvAps.dndlogdp(1:4,:)];
       end
       

       
       elpiPlusNolla = median(elpiPlus)
       
       if dataDay.flow == 25
           Nolla1 = elpiPlusNolla;
       elseif dataDay.flow == 10
           Nolla2 = elpiPlusNolla;
       end
       
       figure(1)
       plot(elpiPlusDp,elpiPlusNolla)
       hold on
       legend(legendIndex1);
       
    else
       if dataDay.flow == 25
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
           elpi = dataDay.elpi.dndlogdp(50:300,:);
           aps = [dataDay.uvAps.dndlogdp(1:3,:);dataDay.uvAps.dndlogdp(6:end,:)];
       elseif dataDay.flow == 10
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
           elpi = dataDay.elpi.dndlogdp(50:300,:);
           aps = dataDay.uvAps.dndlogdp(1:7,:);
       elseif dataDay.flow == 15
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
           elpi = dataDay.elpi.dndlogdp(50:300,:);
           aps = dataDay.uvAps.dndlogdp(1:8,:);
       elseif dataDay.flow == 20
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:200,:);
           elpi = dataDay.elpi.dndlogdp(50:200,:);
           aps = [dataDay.uvAps.dndlogdp(1:4,:)];
       elseif dataDay.flow == 30
           elpiPlus = dataDay.elpiPlus.dnDlogdp(50:300,:);
           elpi = dataDay.elpi.dndlogdp(50:300,:);
           aps = [dataDay.uvAps.dndlogdp(5:6,:)];
       elseif dataDay.flow == 35
           elpiPlus = dataDay.elpiPlus.dnDlogdp(40:110,:);
           elpi = dataDay.elpi.dndlogdp(40:110,:);
           aps = [dataDay.uvAps.dndlogdp(1:5,:)];
       elseif dataDay.flow == 40
           elpiPlus = dataDay.elpiPlus.dnDlogdp(100:250,:);
           elpi = dataDay.elpi.dndlogdp(100:250,:);
           aps = [dataDay.uvAps.dndlogdp(7:end,:)];
       end
       elpiPlusMittaus = median(elpiPlus)
           
       if dataDay.flow == 25
           Mittaus1 = elpiPlusMittaus;
       elseif dataDay.flow == 10
           Mittaus2 = elpiPlusMittaus;
       end
   end
        
end

hiukkaskoko = [elpiDp(1:5)' apsDp*10^-6]
flow = [10 15 20 25 30 35 40];
for i = 1:length(flow)
    [haviotTeor haviotJotkut haviotmoi] = particleLossesCar(flow(i), hiukkaskoko);
    haviotTeorKok{i} = haviotTeor
end
      

figure(2)
plot(elpiPlusDp(3:end), Mittaus1(3:end),'--','LineWidth', 3)
hold on
plot(elpiPlusDp(3:end), Nolla1(3:end) , '--', 'LineWidth',3)
plot(elpiPlusDp(3:end), Mittaus2(3:end) ,'-', 'LineWidth',3)
plot(elpiPlusDp(3:end), Nolla2(3:end) , '-', 'LineWidth',3)
xlabel('Dp (m)')
ylabel('dN/dlogDp (#/cm^{3})')
ylim([0 inf])
legend('Automittaus 25 lpm', 'Nollamittaus 25 lpm', 'Automittaus 10 lpm', 'Nollamittaus 10 lpm')

figure(41)
for i = 1:length(flow)
    semilogx(hiukkaskoko,haviotTeorKok{i}, 'LineWidth',2)
    hold on
end
xlabel('Dp (m)')
ylabel('Häviöt')
legend('10 lpm', '15 lpm','20 lpm','25 lpm','30 lpm','35 lpm','40 lpm')

for i = 1:length(flow)
     haviotElpi =  plotIsotVarmuusKopio(flow(i))
     haviotElpiKok{i} = haviotElpi
end

figure(6)
for i = 1:length(flow)
  
    semilogx(elpiDp(3:end)', haviotElpiKok{i}(3:end),'*')
    hold on
end

legend('10 lpm', '15 lpm','20 lpm','25 lpm','30 lpm','35 lpm','40 lpm')