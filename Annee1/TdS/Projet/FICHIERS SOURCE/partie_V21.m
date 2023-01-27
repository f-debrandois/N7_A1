% Modulateur / Demodulateur V21 désynchronisé
%Felix Foucher de Brandois
%Achraf Marzougui


clear all ; close all;

n_bits = 20 ; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre
bits =[0; 1; 0; 0; 1; 1; 1; 0; 0; 1; 0; 0; 1; 0; 0; 0; 1; 0; 0; 1]

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
SNR_tab = [1; 2; 10; 15; 20; 25; 30; 40; 50; 70; 100];


%% 6.2 Demodulateur de fréquence adapté à la norme V21
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

% 6.1 Contexte de synchronisation idéale
bits_restitues_sync = demodulateur_V21_synchrone(x_perturbe, phi0, phi1);
taux_V21_sync = sum(bits_restitues_sync' ~= bits)/n_bits ; % le taux d'erreur


figure('name', 'Modem V21 synchrone')

NRZ_sortie_sync = repelem(bits_restitues_sync, Ns)';

nexttile
plot(T, NRZ);
hold on
plot(T, NRZ_sortie_sync);
hold off
ylim([-0.5, 1.5])
xlabel("temps (s)")
ylabel("NRZ(t)")
title({['Comparaison des bits. SNR = ' num2str(SNR_dB)] ['Taux d''erreur = ' num2str(taux_V21_sync)]})
legend('bits d''entrée', 'bits de sortie');

% Evolution de l'erreur binaire en fonction du rapport signal sur bruit
taux_V21_sync_tab = zeros(1, length(SNR_tab));
for i = 1:length(SNR_tab)
    bits_restitues_sync = demodulateur_V21_synchrone(x_perturbe_tab(i, :), phi0, phi1);
    taux_V21_sync_tab(i) = sum(bits_restitues_sync' ~= bits)/n_bits ; % le taux d'erreur
end

nexttile
semilogx(SNR_tab, taux_V21_sync_tab);
xlabel("SNR")
ylabel("Taux d'erreur binaire")
title("TEB en fonction du rapport signal / bruit")



% 6.2 Gestion d'une erreur de synchronisation de phase porteuse
% 1 Introduction de l'erreur de phase porteuse
phi2 = rand*2*pi;
phi3 = rand*2*pi;
bits_non_synch = demodulateur_V21_synchrone(x_perturbe, phi2, phi3);

taux_non_synch = sum(bits_non_synch' ~= bits)/n_bits;

NRZ_sortie_non_sync = repelem(bits_non_synch, Ns);

nexttile
plot(T, NRZ);
hold on
plot(T, NRZ_sortie_non_sync);
hold off
ylim([-0.5, 1.5])
xlabel("temps (s)")
ylabel("NRZ(t)")
title({['Comparaison des bits avec démodulation asynchrone. SNR = ' num2str(SNR_dB)] ['Taux d''erreur = ' num2str(taux_non_synch)]})
legend('bits d''entrée', 'bits de sortie');


% 2 Demodulateur

bits_restitues_phase = demodulateur_V21_phase(x_perturbe);
taux_V21_phase = sum(bits_restitues_phase' ~= bits)/n_bits ; % le taux d'erreur


figure('name', 'Modem V21 avec phase porteuse')

NRZ_sortie_phase = repelem(bits_restitues_phase, Ns)';

nexttile
plot(T, NRZ);
hold on
plot(T, NRZ_sortie_phase);
hold off
ylim([-0.5, 1.5])
xlabel("temps (s)")
ylabel("NRZ(t)")
title({['Comparaison des bits. SNR = ' num2str(SNR_dB)] ['Taux d''erreur = ' num2str(taux_V21_phase)]})
legend('bits d''entrée', 'bits de sortie');

% Evolution de l'erreur binaire en fonction du rapport signal sur bruit
taux_V21_phase_tab = zeros(1, length(SNR_tab));
for i = 1:length(SNR_tab)
    bits_restitues_phase = demodulateur_V21_phase(x_perturbe_tab(i, :));
    taux_V21_phase_tab(i) = sum(bits_restitues_phase' ~= bits)/n_bits ; % le taux d'erreur
end

nexttile
semilogx(SNR_tab, taux_V21_phase_tab);
xlabel("SNR")
ylabel("Taux d'erreur binaire")
title("TEB en fonction du rapport signal / bruit")