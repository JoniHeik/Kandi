close all

flows = [10 15 20 25 30 35 40];

for i = 1:length(flows)
    dp = [0.001:0.01:100]*10^-6;
    [haviotTeor haviotTransport haviotSampling] = particleLossesCar(flows(i),0,dp);
    
    figure(1)
    semilogx(dp,1-haviotTeor,'LineWidth',1)
    hold on
    xlabel('Dp (m)')
    ylabel('Läpäisy')
    
    
end

legend('10 lpm', '15 lpm','20 lpm','25 lpm','30 lpm','35 lpm','40 lpm')


