function [ Stk ] = stokes( dp, U, d )
%Tämä funktio laskee stokesin luvun.

%parametrit
%dp - Hiukkasen halkaisija (m)
%U - Virtauksen nopeus (m/s)
%d - putken halkaisija (m)

p = 1000; % Hiukaksten tiheys (kg/m3)
myy = 1.833*10^-5; %Ilman viskositeetti Pa*s

C = cunningham(dp);

Stk = dp.^2.*p.*C.*U./(18*myy*d);


end

