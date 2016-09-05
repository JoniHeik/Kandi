function [ kokLapaisy ] = particleLossesSampling( U, Uo , dp,d, inletinAsento, kuvat)
%Funktio laskee näytteenoton tehokkuuden annetuilla parametreillä. TÄllä
%hetkellä on vain mahdollista laskea häviöt isoaksiaalisessa tapauksessa
%(putken virtaus ja ilmavirtaus ovat saman suuntaisia, eikä niiden välissä
%ole kulmaa)

%Parametrit:
%U - Virtaus näyteputkissa (m/s)
%Uo - Auton nopeus (m/s)
%dp - hiukkaskoko (m)
%d  - putken sisähalkaisija (m)
%inletinAsento - inletinAsento kulma (radiaaneina)
%kuvat - kertoo, piirretäänkö kuvaajia (0 ei piirretä, 1 piirretään)

%Return values:
%kokLapaisy - Näytteenoton kokonaistehokkuus.
%%
aspiraatioLapaisy = particleLossesAspiration(Uo, U, dp, d, inletinAsento); %Aspiraatiotehokkuus
transmissioLapaisy = particleLossesTransmission(Uo,U,dp,d, inletinAsento); %Transmissiotehokkuus

kokLapaisy = aspiraatioLapaisy.*transmissioLapaisy;

%%
if kuvat == 1
    figure(2)
	semilogx(dp, aspiraatioLapaisy,'LineWidth',3)
    hold on
    semilogx(dp, transmissioLapaisy, 'LineWidth',3)
    semilogx(dp, kokLapaisy,'LineWidth',3)
    xlabel('dp (m)')
    ylabel('Efficiency')
    title('Sampling efficiency')
    legend('Aspiration','Transmission','Overall')

end

end

