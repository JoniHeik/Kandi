function [lapaisy] = particleLossesBend(dp, U , d, kaartumiskulma)
%Laskee mutkien läpäisyn hiukkaskoolle


%parametrit
% dp - hiukkaskoko (m)
% U - virtaus putkessa (m/s)
% d- putken halkaisija (m)
% kaartulmiskulma - kulman kaartumiskulma asteina.

%Return values
%lapaisy - mutkan läpäisy
%Lasketaan uudestaan Reynoldsin luku
[Re virtauksenTyyppi] = reynolds(U,d);
%stokesin luku

Stk = stokes(dp,U,d);

%Mutkassa virtaus on laminaarista Re 5000 asti
if Re < 5000
    %Laminaariselle (Pui 1987)
    lapaisy = (1.+(Stk./0.171).^(0.452.*(Stk./0.171)+2.242)).^(-(2/pi)*kaartumiskulma);
else
    %Turbulenttiselle (Pui 1987)
    kaartumiskulma = kaartumiskulma *(180/pi) %kulman täytyy olla radiaaneina.
    lapaisy = exp(-2.823*Stk*kaartumiskulma);
    
end