function [ ] = plotPienet(flow)

close all
% list = dir('D:\Koulujuttuja\Kandi\Kandimittaukset\dataPienet\2016*.mat');
list = dir('P:\Kandi\Kandimittaukset\dataPienet\2016*.mat');



for fileIndex = 1:length(list)
    filename = list(fileIndex).name;
    load(filename);
    if dataDay.flow == flow
        smpsDp = dataDay.smps.dp;
        if dataDay.reference == 1
            
            [rows columns] = size(dataDay.smps.dndlogdp);
            if rows > 1
               smpsReference1 = median(dataDay.smps.dndlogdp);
           
            else
                smpsReference1 = dataDay.smps.dndlogdp;
            end
            if flow == 10
                psmConcReference1 = dataDay.psm.conc(60:end);
                psmTimeReference1 = dataDay.psm.time(60:end);
                psmTimeGenerate = 1:1:length(dataDay.psm.time(60:end))';
                
            else
                psmConcReference1 = dataDay.psm.conc;
                psmTimeReference1 = dataDay.psm.time;
            end
            
            
            
            alkuAika = datevec(dataDay.timeBegin);
            
            
        elseif dataDay.reference == 2
            [rows columns] = size(dataDay.smps.dndlogdp);
            if rows > 1
               smpsReference2 = median(dataDay.smps.dndlogdp);
           
            else
                smpsReference2 = dataDay.smps.dndlogdp;
            end
            
            if flow == 10
               psmConcReference2 =  dataDay.psm.conc(40:end);
               psmTimeReference2 = dataDay.psm.time(40:end);
            elseif flow == 15
               psmConcReference2 =  dataDay.psm.conc(110:end);
               psmTimeReference2 = dataDay.psm.time(110:end);
            else
                psmConcReference2 = dataDay.psm.conc;
                psmTimeReference2 = dataDay.psm.time;
            end

            loppuAika = datevec(dataDay.timeEnd);
        else
            [rows columns] = size(dataDay.smps.dndlogdp);
            if rows > 1
                if flow == 10
                    smpsMittaus = median(dataDay.smps.dndlogdp(1:2,:));
                else
              
                    smpsMittaus = median(dataDay.smps.dndlogdp);
                end
            else
                smpsMittaus = dataDay.smps.dndlogdp;
            end
            if flow == 10
                psmConcMittaus = dataDay.psm.conc(30:180);
                psmTimeMittaus = dataDay.psm.time(30:180);
            else
                psmConcMittaus = dataDay.psm.conc;
                psmTimeMittaus = dataDay.psm.time;                
            end
            
            mittausLoppui = datevec(dataDay.timeEnd);
                         
        end
        
        
    end
end

aikaerotus = etime(loppuAika,alkuAika); %kertoo sekuntteinea eron
aikaErotusMittaus = etime(mittausLoppui,alkuAika)
[M1, I1]= max(smpsReference1);
maxDp1 = smpsDp(I1);
[M2 ,I2]= max(smpsReference2);
maxDp2 = smpsDp(I2);

kasvuNopeus = (maxDp2-maxDp1)/aikaerotus %m/s

particleLossesCar(flow,smpsDp);

smpsDpReferenssi = smpsDp + (aikaErotusMittaus*kasvuNopeus);
smpsDpMittaus = smpsDp - (aikaErotusMittaus*kasvuNopeus);
%%


sovitus = fit([psmTimeReference1; psmTimeReference2], [psmConcReference1; psmConcReference2] ,'poly5')
fun = @(x,psmTimeGenerate)x(1)*exp(x(2)*(psmTimeGenerate));
x0 = [psmConcReference1(1), -5];
% sovitusLs = lsqcurvefit(fun,x0,psmTimeGenerate',psmConcReference1)


%%
figure(7)
semilogx(smpsDp ,smpsReference1,'LineWidth',3)
hold on
semilogx(smpsDp -(maxDp2-maxDp1),smpsReference2,'LineWidth',3)
semilogx(smpsDpMittaus,smpsMittaus,'LineWidth',3)
legend('Nollamittaus 1','Nollamittaus 2','Mittaus')
xlabel('dp (m)')
ylabel('dN/dlogDp (#/cm^3)','Interpreter','none')

if flow == 10
    smpsReference1 =  [smpsReference1(1:73) smpsReference1(74:end)*2]
end

if flow == 15 || flow == 35
 figure(5)
semilogx(smpsDp ,smpsReference2,'LineWidth',3)
hold on
semilogx(smpsDp,smpsMittaus,'LineWidth',3)
legend('Nollamittaus','Mittaus')
xlabel('dp (m)')
ylabel('dN/dlogDp (#/cm^3)','Interpreter','none')
else
    figure(5)
semilogx(smpsDpReferenssi ,smpsReference1,'LineWidth',3)
hold on
semilogx(smpsDp,smpsMittaus,'LineWidth',3)
legend('Nollamittaus (laskettu)','Mittaus')
xlabel('dp (m)')
ylabel('dN/dlogDp (#/cm^3)','Interpreter','none') 
end


figure(6)

plot( psmTimeReference1,psmConcReference1,'k')
hold on
plot(psmTimeReference2, psmConcReference2,'b')
plot(psmTimeMittaus, psmConcMittaus,'g')
h = plot(sovitus)

% plot(psmTimeGenerate, psmConcReference1,psmTimeGenerate',fun(sovitusLs,psmTimeGenerate'))
datetick('x')
legend('Nollamittaus 1', 'Nollamittaus 2', 'Automittaus', 'Sovitus')
xlabel('Aika')
ylabel('Pitoisuus (#/cm^3)','Interpreter','none')


figure(8)
semilogx(smpsDp ,smpsReference1,'LineWidth',3)
hold on
semilogx(smpsDp,smpsReference2,'LineWidth',3)
semilogx(smpsDp,smpsMittaus,'LineWidth',3)
legend('Nollamittaus 1','Nollamittaus 2','Mittaus')
xlabel('dp (m)')
ylabel('dN/dlogDp (#/cm^3)','Interpreter','none')







end