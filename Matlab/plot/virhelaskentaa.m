function[] = virhelaskentaa(flow)

syms Q


%Lasketaan läpäisytehokkuudelle tarvittavat vakiot
T = 293; %Lämpötila (K)
d = 0.012;
k = 1.38065*10^-23; %Boltzmanin vakio (J/K)
myy = 1.833*10^-5; %Ilman viskositeetti Pa*s
p0 = 1.192; %Ilman tiheys (kg/m3)
dp = [0.001:0.01:100]*10^-6;
L = 2.5;

deltaQ = 0.1*0.25*pi*(d)^2;
deltaL = 0.001;

%%
%Cunninnhamin korjauskerroin
C = cunningham(dp);

%Diffuusiokerroin D
D = (k*T*C)./(3*pi*myy.*dp);

%Flow Rate Q
QVirtaus = 0.25*pi*(d)^2*flow;

e = 2*Q^2

% e = (-pi*D*L/Q);
edeltaQ = diff(e,Q)

moi = vpa(subs(e,Q,QVirtaus));

% virheE = sqrt((abs(edeltaQ*deltaQ)^2 + (abs(edeltaL*deltaL)^2)))







end