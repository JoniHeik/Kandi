function [ lapaisytehokkuus ] = particleLossesTurbulent(dp,U,L,d)
%Tämä funktio laskee turbulenttisesta asettumisesta johtuvat häviöt

%parametrit
%dp - hiukkasen koko (m)
%U - Virtauksen nopeus putkessa (m/s)
%L - Putken pituus (m)
%d - putken halkaisija (m)

%Reynodlsin luku
[Re, virtauksen_tyyppi] = reynolds(U,d);
Stk = stokes(dp,U,d);

%Willeke & Baron 2005
V = (6.*10.^-4.*(0.0395.*Stk.*Re.^(3/4)).^2+2*10^-8*Re).*U./(5.03.*Re.^(1/8));

%Flow Rate
Q = 0.25*pi*(d)^2*U;

lapaisytehokkuus = exp(-pi*d*L*V/Q);


end

