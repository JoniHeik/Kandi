function [ lapaisy ] = particleLossesDiffusion( dp,U, virtauksen_tyyppi, L, d )
%Laskee diffuusioon liittyvän läpäisyn.

%Parametrit:
%dp - hiukkasen koko (m)
% U - virtaus putkessa (m/s)
%L - Putken pituus (m)
%d - putken halkaisija (m)
% Virtauksen tyyppi - kertoo onko virtaus turbulenttista vai laminaarista

%Return values:
%lapaisy - diffuusioon liittyvä läpäisy.


%Lasketaan läpäisytehokkuudelle tarvittavat vakiot
T = 293; %Lämpötila (K)
k = 1.38065*10^-23; %Boltzmanin vakio (J/K)
myy = 1.833*10^-5; %Ilman viskositeetti Pa*s
p0 = 1.192; %Ilman tiheys (kg/m3)

%%
%Cunninnhamin korjauskerroin
C = cunningham(dp);

%Diffuusiokerroin D
D = (k*T*C)./(3*pi*myy.*dp);

%Flow Rate Q
Q = 0.25*pi*(d)^2*U;
%vakio e
e = pi.*D.*L./Q;


%%

%Reynoldsin luku;
[Re, virtauksen_tyyppi]= reynolds(U,d);

%Shcdimnit luku
Sc = myy./(p0.*D);

%Sherwoodin luku (Holman 1972)
if strcmp(virtauksen_tyyppi, 'Laminar')
    Sh = 3.66 + (0.2672./(e+0.10079*e.^(1/3))); %laminaariselle
else
    Sh = 0.0118*Re^(7/8)*Sc.^(1/3); %Turbulenttiselle
end



%läpäisytehokkuus (Willeke & Baron 2005) Sama kaava pätee turbulenttiselle 
%ja laminaariselle virtaukselle. Tämä otetaan huomioon laskettaessa
%Sherwoodin lukua Sh, eli funktiossa vakiot_diffuusio.
lapaisy = exp(-e.*Sh);




end

