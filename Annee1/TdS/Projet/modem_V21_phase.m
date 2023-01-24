% Modulateur / Demodulateur V21
%Felix Foucher
%Achraf Marzougui

function [bits_restitues] = modem_V21_phase(signal)

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
    bits_restitues = H>0;



        x_reshaped = reshape(x, Ns, length(x)/Ns);
        t_reshaped = reshape(t, Ns, length(x)/Ns);
        x0_cos = x_reshaped .* cos(2*pi*F0*t_reshaped);
        x0_sin = x_reshaped .* sin(2*pi*F0*t_reshaped);
        x1_cos = x_reshaped .* cos(2*pi*F1*t_reshaped);
        x1_sin = x_reshaped .* sin(2*pi*F1*t_reshaped);
        x0 = sum(x0_cos).^2 + sum(x0_sin).^2;
        x1 = sum(x1_cos).^2 + sum(x1_sin).^2;
        H = x0 - x1;
        bits_res_GE = H<0;



end    