    function [ lapaisy ] = particleLossesTransmission(Uo,U,dp,d,inletinAsento)
%Parametrit
%  Uo = Auton nopeus (tai tuulen nopeus) (m/s)
% U = linjojen virtauksen nopeus (m/s)
% dp = hiukkaskoko (m)
% d = putken sisähalkaisija (m)
% inletinAsento = kertoo inletin asennon (-90-90, 0 horisontaalinen, +90 pystysuora
% ylöspäin, -90 pystysuora alaspäin.

Stk = stokes(dp, U, d); %Ilma liikkuu

if inletinAsento < 0
    inletinAsento = 'alas';
    inletinAsento = -inletinAsento; %Kaavoissa täytyy käyttää positiivista kulman arvoa
else
    inletinAsento = 'ylös';
end

if Uo == 0
    %jos näytteeontto on pysähtuneessä ilmasta, ei ole hyviä malleja
    %transmissiotehokkuudelle
    lapaisy = ones(1,length(dp));
    return
elseif Uo/U < 1
    if inletinAsento == 0
        Iv = 0.09*(Stk.*((U-Uo)/U)).^0.3;
        %Superisokineettisessä tapauksessa ja isoaksiaalinen (Hangal % Willeke 1990)
        lapaisy = exp(-75.*(Iv).^2);
    else
         
       %Superkineettinen ja ei-isoaksiaalinen
        Iv = 0.09*(Stk.*inletinAsento.*((U-Uo)/U)).^0.3;
        a = 12*((1-inletinAsento/90)-exp(-inletinAsento));
        if strcmp(inletinAsento, 'alas')
            Iw = Stk.*sqrt(Uo/U).*sin(inletinAsento-a).*sin((inletinAsento-a)/2);
        else
            Iw = Stk.*sqrt(Uo/U).*sin(inletinAsento+a).*sin((inletinAsento-a)/2);
        end
        lapaisy = exp(-75.*(Iv+Iw).^2);
    end


else
    %Subisokineetitine tapaus (Liu 1989)
%     lapaisy1 = 1+(((Uo/U)-1)./(1+(2.66/Stk.^
    lapaisy = (1+(((Uo/U)-1)./(1+(2.66./Stk.^(2/3)))))./(1+(((Uo/U)-1)./(1+(0.418./Stk))));
    for i = 1:length(lapaisy);
        if lapaisy(i) >1
            lapaisy(i) = 1;
        end
    end
      
end

