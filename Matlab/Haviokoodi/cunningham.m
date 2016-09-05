function [C] = cunningham( dp )
%Funktio laskee Cunninghamin korjauskertoimen. 
%Parametrit
% dp - hiukkasen koko (m)


vapaa_matka = 66*10^-9;

C = 1 + (vapaa_matka./dp).*[2.34+1.05*exp(-0.39.*(dp./vapaa_matka))];

end

