function [bits_restitues] = demodulateur_V21_synchrone(signal, phi0, phi1)

    Fe = 48000; % Fréquence d'échantillonnage
    Te = 1/Fe; % Période d'échantillonnage
    D = 300; % Débits de la transmission
    Ns = Fe/D; % Nombre d'échantillons par bits

    Fc = 1080; % Fréquence de coupure
    delta_f = 100;
    F0 = Fc + delta_f;
    F1 = Fc - delta_f;

    x = reshape(signal, Ns, length(signal)/Ns);
    T = reshape(Te * [0:length(signal)-1], Ns, length(signal)/Ns);
    x0 = x .* cos(2*pi*F0*T + phi0);
    x1 = x .* cos(2*pi*F1*T + phi1);

    H = sum(x1) - sum(x0);
    bits_restitues = H > 0;
end  