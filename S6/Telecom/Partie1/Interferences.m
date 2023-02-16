% Etude des interférences entre symbole et du critère de Nyquist
% Felix Foucher de Brandois

clear all ; close all;

% Constantes
n_bits = 20; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
D = 3000; % Débits de la transmission
Ns = Fe/D; % Nombre d'échantillons par bits
Ts = Ns/Fe; % Période par bits
Fs = 1/Ts; %% Fréquence des bits