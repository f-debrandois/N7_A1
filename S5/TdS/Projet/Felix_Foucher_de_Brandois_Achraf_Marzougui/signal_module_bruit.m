% Signal modulé et Bruit
%Felix Foucher de Brandois
%Achraf Marzougui

clear all ; close all;

% Constantes
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

F0 = 6000;
F1 = 2000;


%% 3. Modem de fréquence
% 3.1 Génération du signal NRZ
figure('name', 'Signal NRZ')

% 1 Signal NRZ et echelle temporelle
NRZ = repelem(bits, Ns)'; % Signal NRZ
T = 0:Te:(n_bits*Ns-1)*Te; % Echelle temporelle

% 2 Tracage du signal
nexttile
plot(T,NRZ)
ylim([-0.5, 1.5])
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


% 3.2 Génération du signal modulé en fréquence
figure('name', 'Signal modulé en fréquence')

% 1 Géneration du signal x
x = (1 - NRZ) .* cos(2*pi*F0*T + phi0) + NRZ .* cos(2*pi*F1*T + phi1);

% 2 Tracage du signal
nexttile
plot(T, x)
ylim([-1.5, 1.5])
xlabel("temps")
ylabel("x(t)")
title("Signal x(t)")

% 3 Densité spectrale de puissance theorique du signal x
S_x = (1/4)*(Signal_S_NRZ(F-F0, Ts) + Signal_S_NRZ(F+F0, Ts) + Signal_S_NRZ(F-F1, Ts) + Signal_S_NRZ(F+F1, Ts));

% 4 Estimation et tracage de la DSP
DSP_x = pwelch(x,[],[],[],Fe,'twosided');
nexttile
semilogy(F, fftshift(DSP_x))
hold on
semilogy(F, S_x)
hold off
xlabel('fréquence (Hz)');
ylabel('signal');
title('tracé de la DSP estimée et de la DSP théorique');
legend('DSP estimée', 'DSP théorique');



%% 4. Canal de transmission à bruit additif, blanc et Gaussien
figure('name', 'Bruit additif, blanc et Gaussien')

P_x = mean(abs(x).^2);

SNR_dB = 50;
P_y = P_x*10.^(-SNR_dB/10);
bruit = sqrt(P_y) * randn(1, length(x));

nexttile
plot(T, x)
ylim([-1.5, 1.5])
xlabel("temps")
ylabel("x(t)")
title("Signal x(t)")

nexttile
plot(T, x + bruit);
ylim([-1.5, 1.5])
xlabel("temps (s)")
ylabel("Signal perturbé")
title("SNR_d_B = " + SNR_dB)


function [S_NRZ] = Signal_S_NRZ(f, t)
    S_NRZ = (1/4)*t*(sinc(pi*f*t).^2) + (1/4)*(f==0);
end