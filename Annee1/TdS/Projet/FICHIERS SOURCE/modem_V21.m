% Modulateur / Demodulateur V21 synchrone
%Felix Foucher
%Achraf Marzougui


clear all ; close all;

n_bits = 20 ; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre

phi0 = rand*2*pi;
phi1 = rand*2*pi;

Fe = 48000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
D = 300; % Débits de la transmission
Ns = Fe/D; % Nombre d'échantillons par bits
Ts = Ns/Fe; % Période par bits
Fs = 1/Ts; %% Fréquence des bits

F0 = 1180;
F1 = 980;

SNR_dB = 50;
SNR_tab = [1; 2; 10; 20; 50; 100];


%% 6.1 Demodulateur de fréquence adapté à la norme V21 pour une synchronisation idéale
% Construction du signal d'entrée
NRZ = repelem(bits, Ns)';
T = 0:Te:(n_bits*Ns-1)*Te;
x = modulateur(bits, phi0, phi1, F0, F1);
P_x = mean(abs(x).^2);
P_y = P_x*10.^(-SNR_dB/10);
bruit = sqrt(P_y) * randn(1, length(x));

P_y_tab = P_x*10.^(-SNR_tab/10);
bruit_tab = sqrt(P_y_tab) * randn(1, length(x));

[x_perturbe] =  x + bruit;
[x_perturbe_tab] = x + bruit_tab;

bits_restitues = demodulateur_V21_synchrone(x_perturbe, phi0, phi1);
taux_V21 = sum(bits_restitues' ~= bits)/n_bits ; % le taux d'erreur

% Démodulation du signal
figure('name', 'Modem V21 synchrone')

NRZ_sortie = repelem(bits_restitues, Ns)';

nexttile
plot(T, NRZ);
hold on
plot(T, NRZ_sortie);
hold off
ylim([-0.5, 1.5])
xlabel("temps (s)")
ylabel("NRZ(t)")
title({['NRZ en sortie. SNR = ' num2str(SNR_dB)] ['Taux d''erreur = ' num2str(taux_V21)]})
legend('bits d''entrée', 'bits de sortie');

% Evolution de l'erreur binaire en fonction du rapport signal sur bruit
taux_V21_tab = zeros(1, length(SNR_tab));
for i = 1:length(SNR_tab)
    bits_restitues = demodulateur_V21_synchrone(x_perturbe_tab(i, :), phi0, phi1);
    taux_V21_tab(i) = sum(bits_restitues' ~= bits)/n_bits ; % le taux d'erreur
end

nexttile
semilogx(SNR_tab, taux_V21_tab);
xlabel("SNR")
ylabel("Taux d'erreur binaire")
title("TEB en fonction du rapport signal / bruit")

% 6.2 Gestion d'une erreur de synchronisation de phase porteuse
% 1 Introduction de l'erreur de phase porteuse
phi2 = rand*2*pi;
phi3 = rand*2*pi;
bits_non_synch = demodulateur_V21_synchrone(x_perturbe, phi2, phi3);

taux_non_synch = sum(bits_non_synch' ~= bits)/n_bits


function [signal] = modulateur(bits, phi0, phi1, F0, F1)

    Fe = 48000; % Fréquence d'échantillonnage
    Te = 1/Fe; % Période d'échantillonnage
    D = 300; % Débits de la transmission
    Ns = Fe/D; % Nombre d'échantillons par bits

    T = Te * [0:(length(bits)*Ns-1)]; % Echelle temporelle 
    NRZ = repelem(bits, Ns)'; % Signal NRZ
    signal = (1 - NRZ) .* cos(2*pi*F0*T + phi0) + NRZ .* cos(2*pi*F1*T + phi1);
end


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