function [bits_restitues] = demodulateur_V21_phase(signal)

    Fe = 48000; % Fréquence d'échantillonnage
    Te = 1/Fe; % Période d'échantillonnage
    D = 300; % Débits de la transmission
    Ns = Fe/D; % Nombre d'échantillons par bits

    Fc = 1080; % Fréquence de coupure
    delta_f = 100;
    F0 = Fc + delta_f;
    F1 = Fc - delta_f;

    theta0 = rand*2*pi;
    theta1 = rand*2*pi;

    x = reshape(signal, Ns, length(signal)/Ns);
    T = reshape(Te * [0:length(signal)-1], Ns, length(signal)/Ns);
    x0_sin = x .* sin(2*pi*F0*T + theta0);
    x0_cos = x .* cos(2*pi*F0*T + theta0);
    x1_sin = x .* sin(2*pi*F1*T + theta1);
    x1_cos = x .* cos(2*pi*F1*T + theta1);
        
    x0 = sum(x0_cos).^2 + sum(x0_sin).^2;
    x1 = sum(x1_cos).^2 + sum(x1_sin).^2;

    H = x1 - x0;
    bits_restitues = H > 0;
end   