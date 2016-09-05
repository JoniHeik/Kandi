function [ kokLapaisy ] = particleLossesSampling( U, Uo , dp,d, inletinAsento, kuvat)
%Funktio laskee n�ytteenoton tehokkuuden annetuilla parametreill�. T�ll�
%hetkell� on vain mahdollista laskea h�vi�t isoaksiaalisessa tapauksessa
%(putken virtaus ja ilmavirtaus ovat saman suuntaisia, eik� niiden v�liss�
%ole kulmaa)

%Parametrit:
%U - Virtaus n�yteputkissa (m/s)
%Uo - Auton nopeus (m/s)
%dp - hiukkaskoko (m)
%d  - putken sis�halkaisija (m)
%inletinAsento - inletinAsento kulma (radiaaneina)
%kuvat - kertoo, piirret��nk� kuvaajia (0 ei piirret�, 1 piirret��n)

%Return values:
%kokLapaisy - N�ytteenoton kokonaistehokkuus.
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

