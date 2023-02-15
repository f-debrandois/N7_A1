function [signal] = modulateur(bits, phi0, phi1, F0, F1)

    Fe = 48000; % Fréquence d'échantillonnage
    Te = 1/Fe; % Période d'échantillonnage
    D = 300; % Débits de la transmission
    Ns = Fe/D; % Nombre d'échantillons par bits

    T = Te * [0:(length(bits)*Ns-1)]; % Echelle temporelle 
    NRZ = repelem(bits, Ns)'; % Signal NRZ
    signal = (1 - NRZ) .* cos(2*pi*F0*T + phi0) + NRZ .* cos(2*pi*F1*T + phi1);
end