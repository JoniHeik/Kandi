function [ Vts ] = gravVelocity( dp )
%Brief: Calculates gravitational settling velocity

%Parametrit
%dp - hiukkaskoko (m)


myy = 1.833*10^-5; %Ilman viskositeetti (Pa*s)
pd = 1000; %Hiukkasen tiheys (kg/m3)
g = 9.81; %Gravitaatiovakio (m/s2)

C= cunningham(dp); %Cunninghamin korjauskerroin

%hiukkasten asettumisnopeus
Vts = pd.*(dp).^2.*g.*C./(18*myy);

end

