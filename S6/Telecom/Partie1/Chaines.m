% Projet de Telecommunication : Etude de modulateurs bande de base
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-E

clear all ; close all;

% Constantes
n_bits = 2000; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits


%% 4. Etude de l'impact du bruit et du filtrage adapté, notion d'efficacité en puissance
% Filtre de mise en forme

% Canal de propagation


% 4.1 Etude de chaque chaine de trasmission
% 1. Sans bruit
% Chaine 1
    % Mapping


    % Filtre de réception

% Chaine 2
    % Mapping


    % Filtre de réception

% Chaine 3
    % Mapping


    % Filtre de réception



% 2. Avec bruit



% 4.2 Comparaison des chaines de transmission implantées


