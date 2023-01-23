clear all
close all
% 3.1 Génération du signal NRZ 
% Constantes
Fe = 48000; 
Te = 1/Fe; 
Ts = 1/300;
Ns=floor(Ts/Te);
N_bits = 10;
F0 = 6000;
F1 = 2000;
Fc = (F0+F1)/2;
SNR = 50; %dB
n = Fc/Fe;
ordre= 61;

% Signal unipolaire
suite_bits = randi([0,1], 1,N_bits);
t = 0:Te:(N_bits*Ns-1)*Te;
B = ones(1,Ns);
NRZ = kron(suite_bits,B);
figure(1)
plot(t,NRZ)
title("Signal NRZ")
xlabel("Temps (t)")
ylabel("NRZ(t)")

% Densité spectrale de puissance
figure(2)
DSP=pwelch(NRZ,[],[],[],Fe,'twosided');
f = linspace(-Fe/2,Fe/2,length(DSP));
semilogy(f,fftshift(abs(DSP)))
title("Densité spectrale de puissance")
xlabel("Fréquence(f)")
ylabel("Densité spectrale")

% 3.2 Génération du signal modulé en fréquence
%Génération des cosinus
phi1 = 2*pi*rand(1);
phi2 = 2*pi*rand(1);
cos1 = cos(2*pi*F0*t+phi1);
cos2 = cos(2*pi*F1*t+phi2);
x = (1-NRZ).*cos1 + NRZ.*cos2;
figure(3)
plot(t,x)
title("Signal modulé en fréquence")
xlabel("Temps (t)")
ylabel("x(t)")

%4. Canal de transmission à bruit additif, blanc et Gaussien
%génération du bruit 

Px = mean(abs(x).^2);
Pb = Px*10^(-SNR/10);
bruit = sqrt(Pb)*randn(1,length(x));
% Signal modulé + bruit 
signal_perturbe = x + bruit;

% 5. Démodulation par fitrage 
% 5.1 Synthèse du filtre passe-bas
ordre_x = -(ordre-1)/2:(ordre-1)/2;
h_bas = 2*Fc/Fe*sinc(2*Fc/Fe*ordre_x);
y_bas = filter(h_bas,1,signal_perturbe);
figure(4)
plot(t, y_bas)
title("Signal perturbé apres filtrage passe-bas")
xlabel("Temps (t)")
ylabel("y(t)")

% 5.2 Synthèse du filtre passe-haut

h_haut = - 2*Fc/Fe*sinc(2*Fc/Fe*ordre_x);
h_haut((ordre+1)/2) = h_haut((ordre+1)/2)+1; 
y_haut = filter(h_haut,1,signal_perturbe);
figure(5)
plot(t, y_haut)
title("Signal perturbé après filtrage passe-haut")
xlabel("Temps (t)")
ylabel("y(t)")

% 5.4 Tracés à réaliser

% 5.5 Détection d'énergie
% Signal filtré passe-bas 
signal_filtre_paquet = reshape(y_bas,Ns,N_bits);
energie = sum(signal_filtre_paquet.^2);
K = (max(energie) + min(energie))/2;
signal_demodule = energie > K;
figure(6)
plot(1:N_bits,signal_demodule)
title("Signal démodulé après filtrage passe-bas")
xlabel("Temps (t)")
ylabel("y(t)")

% Taux d'erreur binaire
bits_differents = sum(suite_bits~=signal_demodule);
taux_erreur = bits_differents/N_bits

% 5.6 Modification du démodulateur

% Modifier les valeurs et observer

% 6. Démodulateur de fréquence adapté à la norme V21