% ~gergaud/ENS/Automatique/TP19-20/TP_Etudiants/simu_pendule_etu/simu_pendule_inv_echant_etu.m
%
%
% Auteur : Gergaud Joseph
% Date : october 2019
% Institution : Université de Toulouse, INP-ENSEEIHT
%               Département Sciences du Numérique
%               Informatique, Mathématiques appliquées, Réseaux et Télécommunications
%               Computer Science department
%
%-----------------------------------------------------------------------------------------
%
% Code Matlab de test pour la simulation du pendule inversé contrôlé. 
%
%-----------------------------------------------------------------------------------------


% Remarque : On ne fait pas de sous programme car Simulink utilise
% l'environnement Matlab
%
clear all; close all;
addpath('./Ressources');
fich_simulink = './pendule_inv_echant_etu'
% Pour une figure avec onglet
set(0,  'defaultaxesfontsize'   ,  12     , ...
   'DefaultTextVerticalAlignment'  , 'bottom', ...
   'DefaultTextHorizontalAlignment', 'left'  , ...
   'DefaultTextFontSize'           ,  12     , ...
   'DefaultFigureWindowStyle','docked');
%
% Initialisations
% ---------------
t0 = 0;             % temps initial
g = 9.81; l = 10;   % constantes
xe = [0 0]';         % (x_e, u_e) point de fonctionnement
ue = 0;             %

% Cas
% -----
x0 = [pi/20 0]';       % initial point
tf = 100;              % temps final
K = [30 10];
algorithme = 'ode45';
RelTol = '1e-3';

% Cas 1
fich = 'cas1';
delta_t = 0.1;
simu_pendule_inv_echant

% Cas 2
fich = 'cas2';
delta_t = 0.2;
simu_pendule_inv_echant

% Cas 3
fich = 'cas3';
delta_t = 0.3;
simu_pendule_inv_echant

% Cas 4
fich = 'cas4';
delta_t = 0.4;
simu_pendule_inv_echant

