% Image à retrouver
%Felix Foucher
%Achraf Marzougui

clear all ; close all;

load fichier1.mat
bits_restitues1 = modem_V21_phase(signal);

load fichier2.mat
bits_restitues2 = modem_V21_phase(signal);

load fichier3.mat
bits_restitues3 = modem_V21_phase(signal);

load fichier4.mat
bits_restitues4 = modem_V21_phase(signal);

load fichier5.mat
bits_restitues5 = modem_V21_phase(signal);

load fichier6.mat
bits_restitues6 = modem_V21_phase(signal);

suite_binaire_reconstruite = [bits_restitues1 bits_restitues2 bits_restitues3 bits_restitues4 bits_restitues5 bits_restitues6];

image_retrouvee = reconstitution_image(suite_binaire_reconstruite);
