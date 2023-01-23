% Projet 1
%Felix Foucher
%Achraf Marzougui

clear all ; close all;

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

%% 3. Modem de fréquence
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


% 3.2 Génération du signal modulé en fréquence
affichage2 = tiledlayout(2, 2);
figure(2)

% 1 Géneration du signal x
phi0 = rand*2*pi;
phi1 = rand*2*pi;
x = (1 - NRZ) .* cos(2*pi*F0*T + phi0) + NRZ .* cos(2*pi*F1*T + phi1);

% 2 Tracage du signal
nexttile
plot(T, x)
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
%affichage3 = tiledlayout(2, 2);
figure(3)

bruit = 0;

for i=1:4
    subplot(2,2,i)
    SNR_dB = 10 + 10*i;
    x_bruit = Bruit(x, SNR_dB);
    plot(T, x_bruit);
    xlabel("temps")
    ylabel("x bruité")
    title("SNR_d_B = " + SNR_dB)
end


%% 5. Démodulation par filtrage
F0 = 6000;
F1 = 2000;
Fc_norm = Fc/Fe;
ordre = 61;
affichage4 = tiledlayout(2, 2);
figure(4)


% 5.1 Synthèse du filtre passe-bas
T_filtre = -Te*(ordre-1)/2:Te:Te*(ordre-1)/2; % Echelle temporelle du filtre passe bas
h_pb = 2*Fc_norm*sinc(2*Fc_norm*T_filtre); % Reponse impulsionnelle du filtre passe bas
Hpb = fft(h_pb, ordre);
F_filtre = -Fe/2:Fe/length(Hpb):Fe/2 - Fe/length(Hpb);

% 5.2 Synthèse du filtre passe-haut
h_ph = -h_pb;
h_ph((ordre+1)/2) = 1 - 2*Fc_norm;
Hph = fft(h_ph, ordre);

% 5.3 Filtrage
Xpb_d = filter(h_pb, 1, [x+bruit, zeros(1, floor(ordre/2) - 1)]);
Xpb = Xpb_d(floor(ordre/2):end);
Xph_d = filter(h_ph, 1, [x+bruit, zeros(1, floor(ordre/2) - 1)]);
Xph = Xph_d(floor(ordre/2):end);

% 5.4 Tracés à réaliser
% 1 Réponse impulsionnelle et réponse en fréquence
nexttile
plot(T_filtre, h_pb);
xlabel("Temps (s)");
ylabel("h(t)");
title("Réponse impulsionelle du filtre passe-bas" );
nexttile
plot(F_filtre, abs(Hpb));
xlabel("Fréquence (Hz)");
ylabel("H(f)");
title("Réponse fréquencielle du filtre passe-bas" );

nexttile
plot(T_filtre, h_ph);
xlabel("Temps (s)");
ylabel("h(t)");
title("Réponse impulsionelle du filtre passe-haut" );
nexttile
plot(F_filtre, abs(Hph));
xlabel("Fréquence (Hz)");
ylabel("H(f)");
title("Réponse fréquencielle du filtre passe-haut" );

% 2 DSP du signal modulé et réponse en fréquence du filtre
nexttile
semilogy(F, fftshift(DSP_x))
hold on
plot(F_filtre, abs(Hpb))
hold off
xlabel("Fréquence (Hz)");
ylabel('Signal');
title("DSP de x et réponse en fréquences du filtre passe-bas" );
legend('DSP', 'Réponse en fréquences');

nexttile
semilogy(F, fftshift(DSP_x))
hold on
plot(F_filtre, fftshift(abs(Hph)))
hold off
xlabel("Fréquence (Hz)");
ylabel('Signal');
title("DSP de x et réponse en fréquences du filtre passe-haut" );
legend('DSP', 'Réponse en fréquences');

% 3 Signal de sortie et DSP
nexttile
plot(T, Xpb)
xlabel("temps (s)")
ylabel("Sortie du passe bas")
title("Signal en sortie du passe bas")
nexttile
Dsp_Xpb = pwelch(Xpb,[],[],[],Fe,'twosided');
semilogy(F, fftshift(Dsp_Xpb))
xlabel("Fréquences (Hz)")
ylabel("DSP")
title("Densité spectrale de puissance du signal en sortie du passe-bas")

nexttile
plot(T, Xph)
xlabel("temps (s)")
ylabel("Sortie du passe-haut")
title("Signal en sortie du passe-haut")
nexttile
Dsp_Xph = pwelch(Xph,[],[],[],Fe,'twosided');
semilogy(F, fftshift(Dsp_Xph))
xlabel("Fréquences (Hz)")
ylabel("DSP")
title("Densité spectrale de puissance du signal en sortie du passe-haut")

% 5.5 Détection d'énergie
% 1 Calcul d'energie
[bits_restitues] = detection_energie(x_fb, Ns);
NRZ_sortie = repelem(bits, Ns);
subplot(2,1,1)
plot(t, N);
xlabel("temps")
ylabel("NRZ(t) en entrée")
title("NRZ à l'entrée");
subplot(2,1,2)
plot(t, NRZ_sortie)
xlabel("temps")
ylabel("NRZ(t) en sortie")
title("NRZ en sortie (Démodulation par filtrage)");



% 2 Erreur binaire
erreur = sum(bits_restitues ~= bits);
taux = erreur/n ; % le taux d'erreur


% 6.1 Contexte de synchronisation ideale
% 1 Principe de fonctionnement du récepteur
signal_0 = x . cos(2*pi*F0*t + phi0);
signal_1 = x.  cos(2*pi*F1*t + phi1);
valeur_0 = integrer_signal(signal_0,Ts);
valeur_1 = integrer_signal(signal_1,Ts);
resultat = valeur_1 - valeur_0 ;
% La synchronisation idéale suivant la recommandation V21


% 2 Implementation du demodulateur



% 6.2 Gestion d'une erreur de synchronisation de phase porteuse
% 1 Introduction de l'erreur de phase porteuse



% 2 Gestion d'une erreur de phase porteuse






function [S_NRZ] = Signal_S_NRZ(F, Ts)
    S_NRZ = (1/4) * Ts* (sinc(pi*F*Ts).^2) + (1/4) * dirac(F);
end

function [x_bruit] = Bruit(x,SNR_dB)
    
    P_x = mean(abs(x).^2);
    P_y = P_x*10^(-SNR_dB/10);
    bruit = sqrt(P_y) * randn(1, size(x, 1))';
    x_bruit = x + bruit;
    
end