% Projet 1
%Felix Foucher

clear all; close all;

nb_bits = 30;
bits = randi([0, 1], 1, nb_bits);
Fe = 48000;
D = 300;
Ns = Fe/D;
Te = 1/Fe;
Ts = Ns*Te;
Fs = 1/Ts;

% 3.1
t = tiledlayout(2, 1);

T = [0:Te:nb_bits*Ts - Te];
NRZ = repelem(bits, Ns);

nexttile
plot(T, NRZ);
xlabel('temps (s)');
ylabel('signal NRZ');
title('tracé du signal NRZ');

DSP=pwelch(NRZ,[],[],[],Fe,'twosided');

f = [0 : Fe/length(DSP) : Fe - Fe/length(DSP)];

nexttile
semilogy(f, DSP);
hold on
S_NRZ = (1/4) * Ts* (sinc(pi*f*Ts).^2) + (1/4) * dirac(f);

semilogy(f, fftshift(S_NRZ));
hold off

xlabel('fréquence (Hz)');
ylabel('signal');
title('tracé de la DSP estimée et de la DSP théorique');
legend('DSP estimée', 'DSP théorique');

phi0 = rand*2*pi;
phi1 = rand*2*pi;

Fc = 1080;
delta_f = 800;
F0 = Fc + delta_f;
F1 = Fc - delta_f;
x = (1 - NRZ) .* cos(2*pi*F0 * T + phi0) + NRZ .* cos(2*pi*F1*T + phi1);

plot(x);