% Variables
n = 10 ; % Nombre de bits
bits = randi([0 1], n, 1); % Signal à transmettre
Fe = 48000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
D = 300; % Débits de la transmission
Ns = Fe/D; % Nombre d'échantillons par bits
Ts = Ns/Fe; % Période par bits
Fs = 1/Ts; %% Fréquence des bits

Fc = 1080; % Fréquence de coupure
delta_f = 100;
F0 = Fc + delta_f;
F1 = Fc - delta_f;


% 3.1 Génération du signal NRZ
affichage1 = tiledlayout(2, 2);
figure(1)

% 1 Signal NRZ et echelle temporelle
NRZ = repelem(bits, Ns)'; % Signal NRZ
T = 0:Te:(n*Ns-1)*Te; % Echelle temporelle

% 2 Tracage du signal
nexttile
plot(T,NRZ)
xlabel("temps (s)")
ylabel("signal NRZ")
title('Tracé du signal NRZ');

% 3 Estimation et tracage de la DSP
DSP_NRZ = pwelch(NRZ,[],[],[],Fe,'twosided');
F = -Fe/2 : Fe/length(DSP_NRZ) : Fe/2 - Fe/length(DSP_NRZ); % Echelle fréquentielle
nexttile
semilogy(F, fftshift(DSP_NRZ))
xlabel("fréquence (Hz)")
ylabel("DSP")
title('Densité spectrale de puissance du signal NRZ');

% 4 Comparaison DSP estimee et theorique
S_NRZ = Signal_S_NRZ(F, Ts);
nexttile
semilogy(F, fftshift(DSP_NRZ))
hold on
semilogy(F, S_NRZ)
hold off
xlabel('fréquence (Hz)');
ylabel('signal');
title('tracé de la DSP estimée et de la DSP théorique');
legend('DSP estimée', 'DSP théorique');


function [S_NRZ] = Signal_S_NRZ(F, Ts)
    S_NRZ = (1/4) * Ts* (sinc(pi*F*Ts).^2) + (1/4) * dirac(F);
end