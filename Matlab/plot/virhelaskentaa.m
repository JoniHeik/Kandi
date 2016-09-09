function[] = virhelaskentaa(flow)
%Q, L, E are symbolic values
syms Q L E

%%
%Constants
T = 293; %Lämpötila (K)
d = 0.012;
k = 1.38065*10^-23; %Boltzmanin vakio (J/K)
myy = 1.833*10^-5; %Ilman viskositeetti Pa*s
p0 = 1.192; %Ilman tiheys (kg/m3)
dp = [0.001:0.01:100]*10^-6;
LPituus = 2.5;

%%
%Virherajat
deltaQ = 0.1*0.25*pi*(d)^2;
deltaL = 0.001;

%%
%Cunninnhamin korjauskerroin
C = cunningham(dp);

%Diffuusiokerroin D
D = (k*T*C)./(3*pi*myy.*dp);

%Flow Rate Q
QVirtaus = 0.25*pi*(d)^2*flow;

%e:n lauseke
e = pi.*D.*L./Q;

% e = (-pi*D*L/Q);

%Derivate for Q and L
edeltaQ = diff(e,Q);
edeltaL = diff(e,L);

%Subs values to functions
edeltaQ = subs(subs(edeltaQ,Q,QVirtaus),L,LPituus);
edeltaL = subs(subs(edeltaL,Q,QVirtaus),L,LPituus);
%Calculate error for e
 virheE = sqrt(abs(double(edeltaL).*deltaL).^2+abs(double(edeltaQ).*deltaQ).^2);
% virheE = sqrt((abs(edeltaQ*deltaQ)^2 + (abs(edeltaL*deltaL)^2)))

%Value for E
eArvo = double(subs(subs(e,Q,QVirtaus),L,LPituus));

%particle penetration for diffusion
lapaisy = exp(-E.*(3.66 + (0.2672./(E+0.10079*E.^(1/3)))));
%derivate for penetration
lapaisyDiff = diff(lapaisy,E);
%Error
virhe = abs(double(subs(lapaisyDiff,E,eArvo)).*virheE);
virhe





end