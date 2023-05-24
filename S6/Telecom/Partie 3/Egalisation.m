% Projet de Telecommunication : Introduction à l'égalisation
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Fraine Sofiane
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-EF

clear all ; close all;

% Constantes
n_bits = 1000; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits


%% 2. Impact d’un canal de propagation multitrajets
% 2.1 Etude théorique
bits_th = [0 1 1 0 0 1]';
Ts = Tb;            % Période symbole
Ns = Fe * Ts;       % Nombre d'échantillons par bits
h = ones(1, Ns);    % Reponse impulsionnelle du filtre de mise en forme
hr = ones(1, Ns);  % Reponse impulsionnelle du filtre de réception
hc = 1;

xe = 1;
ye = 1


