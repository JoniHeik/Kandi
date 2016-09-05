function [lapaisy] = particleLossesAspiration(Uo, U, dp, d, inletinAsento)
%Funktio laskee aspiraatiotehokkuuden. Aspiraatiotehokkuus liittyy
%n�ytteenoton tehokkuuteen. Saattaa antaa aspiraatiotehokkuudeksi yli 1,
%t�m� on t�ysin odotettavaa!

%Parametrit
% Uo = Auton nopeus (tai tuulen nopeus) (m/s)
% U = linjojen virtauksen nopeus (m/s)
% dp = hiukkaskoko (m)
% d = putken sis�halkaisija (m)
% inletinAsento = n�ytteenoton kulma (radiaaneina)

%Return values:
%lapaisy - n�ytteenoton aspiraatioon liittyv� l�p�isy.

% lasketaan asettuimisnopeus (tarvitaan pys�htyneelle ilmalle)
Vts = gravVelocity(dp);

%Lasketaan stokesin luku    
Stk = stokes(dp, Uo, d); %Ilma liikkuu
Stki = stokes(dp,U,d); %Ilma on paikallaan
      
%Aspiraatiotehokkuudessa ei ole v�li� osoittaako inletti yl�s vai alas
if inletinAsento < 0
    inletinAsento = -inletinAsento
end
  
%Jos n�ytteenotto on pys�htyneest� ilmasta 
if Uo == 0
%T�ss� kaavassa horisontaalinen n�ytteenotto tarkoittaa kulmaa 90 ja
%vertikaalinen 0. Muutetaan t�m�.
    if inletinAsento == pi/2 
        inletinAsento = 0
    elseif inletinAsento  == 0
        inletinAsento = pi/2
    end
    lapaisy = (Vts./U)*cos(inletinAsento)+exp(-4*Stki.^(1+sqrt(Vts./U))./(1+2.*Stki));

%n�ytteenotto liikkuvasta ilmasta
else
    %jos n�ytteenoton kulma on 0 astetta (isoaksiaalinen
    if inletinAsento == 0    
        k = 2 + 0.0617*((Uo/U)^-1)
        lapaisy = 1+ ((Uo/U)-1).*(1-(1./(1+k.*Stk)));

    %jos kulma on v�lilt� 0-60 astetta
    elseif inletinAsento > 0 && inletinAsento <  1.0472
        kulmaAsteina = inletinAsento * (180/pi) %tarvitaan kulmaa my�s asteina
        StkKulma = Stk.* exp(0.022*kulmaAsteina);
        lapaisy = 1 + ((Uo/U)*cos(inletinAsento)-1).*((1-(1+(2+0.617*(Uo/U)).*StkKulma).^-1)./ ...
            1-(1+2.617.*StkKulma).^-1)*(1-(1+0.055.*StkKulma*exp(0.255.*StkKulma)).^-1);
    elseif inletinAsento > 1.0472 %jos kulma on v�lilt� 60-90
        if inletinAsento > pi/2 %Ei ole olemassa malleja yli 90 asteen kulmille. 
            %Jos annettu kulma on yli pi/2, lasketaan t�m� 90 asteen kulmana. 
            inletinAsento = pi/2
        end
        lapaisy = 1 + ((Uo/U)*cos(inletinAsento)-1).*(3*Stk.^sqrt(U/Uo));

             

    end
end

%jotkin kaavoista voivat antaa negatiivisa arvoja. Poistetaan n�m�
%vektoreista
for i = 1:length(lapaisy);
    if lapaisy(i)<0
        lapaisy(i) = 0;
    end
end


   
end
