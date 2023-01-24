% Projet 1
%Felix Foucher
%Achraf Marzougui

clear all ; close all;

% Constantes
n_bits = 20 ; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Signal à transmettre
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

% F0 = 6000;
% F1 = 2000;
% Fc = (F0 + F1)/2;

Fc_norm = Fc/Fe;
ordre = 201;

%% 3. Modem de fréquence
% 3.1 Génération du signal NRZ
figure('name', 'signal NRZ')

% 1 Signal NRZ et echelle temporelle
NRZ = repelem(bits, Ns)'; % Signal NRZ
T = 0:Te:(n_bits*Ns-1)*Te; % Echelle temporelle

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
figure('name', 'Signal modulé en fréquence')

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
figure('name', 'Bruit additif, blanc et Gaussien')

P_x = mean(abs(x).^2);

SNR_dB = 50;
P_y = P_x*10.^(-SNR_dB/10);
bruit = sqrt(P_y) * randn(1, length(x));
x_perturbe = x + bruit;
nexttile
plot(T, x_perturbe);
xlabel("temps (s)")
ylabel("Signal perturbé")
title("SNR_d_B = " + SNR_dB)

SNR_tab = [1; 2; 10; 20; 50; 100];
P_y_tab = P_x*10.^(-SNR_tab/10);
bruit_tab = sqrt(P_y_tab) * randn(1, length(x));
x_perturbe_tab = x + bruit_tab;


%% 5. Démodulation par filtrage

% Filtre passe-bas
figure('name', 'Filtre passe-bas')

% 5.1 Synthèse du filtre passe-bas
T_filtre = Te*[-(ordre-1)/2:(ordre-1)/2]; % Echelle temporelle du filtre passe bas
h_pb = 2*Fc_norm*sinc(2*Fc_norm*(T_filtre/Te)); % Reponse impulsionnelle du filtre passe bas
Hpb = fft(h_pb, ordre);
F_filtre = -Fe/2:Fe/length(Hpb):Fe/2 - Fe/length(Hpb);

% 5.3 Filtrage
Xpb_d = filter(h_pb, 1, [x_perturbe, zeros(1, floor(ordre/2) - 1)]);
Xpb = Xpb_d(floor(ordre/2):end);

% 5.4 Tracés à réaliser
% 1 Réponse impulsionnelle et réponse en fréquence
nexttile
plot(T_filtre, h_pb);
xlabel("Temps (s)");
ylabel("h(t)");
title("Réponse impulsionelle du filtre passe-bas" );
nexttile
semilogy(F_filtre, abs(Hpb));
xlabel("Fréquence (Hz)");
ylabel("H(f)");
title("Réponse fréquencielle du filtre passe-bas" );

% 2 DSP du signal modulé et réponse en fréquence du filtre
nexttile
semilogy(F, fftshift(DSP_x))
hold on
semilogy(F_filtre, abs(Hpb))
hold off
xlabel("Fréquence (Hz)");
ylabel('Signal');
title("DSP de x et réponse en fréquences du filtre passe-bas" );
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


% Filtre passe-haut
figure('name', 'Filtre passe-haut')
% 5.2 Synthèse du filtre passe-haut
h_ph = -h_pb;
h_ph((ordre+1)/2) = h_ph((ordre+1)/2)+1;
Hph = fft(h_ph, ordre);

% 5.3 Filtrage
Xph_d = filter(h_ph, 1, [x_perturbe, zeros(1, floor(ordre/2) - 1)]);
Xph = Xph_d(floor(ordre/2):end);


% 5.4 Tracés à réaliser
% 1 Réponse impulsionnelle et réponse en fréquence
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
plot(F_filtre, fftshift(abs(Hph)))
hold off
xlabel("Fréquence (Hz)");
ylabel('Signal');
title("DSP de x et réponse en fréquences du filtre passe-haut" );
legend('DSP', 'Réponse en fréquences');


% 3 Signal de sortie et DSP
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
figure('name', 'Signal de sortie')
Ypb = reshape(Xpb,Ns,n_bits);
energie = sum(Ypb.^2);
K = 10; % Trouvé expérimentalement
bits_restitues = energie > K;
NRZ_sortie = repelem(bits_restitues, Ns)';
nexttile
plot(T, NRZ);
xlabel("temps (s)")
ylabel("NRZ(t) en entrée")
title("NRZ en entrée")
nexttile
plot(T, NRZ_sortie);
xlabel("temps (s)")
ylabel("NRZ(t) en sortie")
title("NRZ en sortie")


% 2 Erreur binaire
erreur = sum(bits_restitues' ~= bits);
taux = erreur/n_bits ; % le taux d'erreur

% Evolution de l'erreur binaire en fonction du rapport signal sur bruit
taux = zeros(1, length(SNR_tab));
for i = 1:length(SNR_tab)
    Xpb_d = filter(h_pb, 1, [x_perturbe_tab(i, :), zeros(1, floor(ordre/2) - 1)]);
    Xpb = Xpb_d(floor(ordre/2):end);

    Ypb = reshape(Xpb,Ns,n_bits);
    energie = sum(Ypb.^2, 1);
    bits_restitues = energie > K;
    erreur = sum(bits_restitues' ~= bits);
    taux(i) = erreur/n_bits;
end

nexttile
semilogx(SNR_tab, taux);
xlabel("SNR")
ylabel("Taux d'erreur binaire")
title("TEB en fonction du rapport signal / bruit")


% 5.6 Modification du démodulateur
% 1 Ordre = 201

% On trouve les mêmes résultats



% 6.1 Contexte de synchronisation ideale
figure('name', 'Modem V21')
% 1 Principe de fonctionnement du récepteur


% 2 Implementation du demodulateur

bits_restitues = modem_V21(x_perturbe, phi0, phi1);

NRZ_sortie = repelem(bits_restitues, Ns)';
nexttile
plot(T, NRZ);
xlabel("temps (s)")
ylabel("NRZ(t) en entrée")
title("NRZ en entrée")
nexttile
plot(T, NRZ_sortie);
xlabel("temps (s)")
ylabel("NRZ(t) en sortie")
title("NRZ en sortie")

erreur = sum(bits_restitues' ~= bits);
taux = erreur/n_bits ; % le taux d'erreur


% 6.2 Gestion d'une erreur de synchronisation de phase porteuse
% 1 Introduction de l'erreur de phase porteuse
phi2 = rand*2*pi;
phi3 = rand*2*pi;
bits_non_synch = modem_V21(x_perturbe, phi2, phi3);

taux_non_synch = sum(bits_non_synch' ~= bits)/n_bits

% Si la différence de phase entre le modulateur V21 et le démodulateur est
% non nulle, alors les intégrales perdent leur propriété de négligeabilité


% 2 Gestion d'une erreur de phase porteuse



function bits_res_GE = Demodulateur_FSK_GE(x, t, F0, F1, Ns)
        x_reshaped = reshape(x, Ns, length(x)/Ns);
        t_reshaped = reshape(t, Ns, length(x)/Ns);
        x0_cos = x_reshaped .* cos(2*pi*F0*t_reshaped);
        x0_sin = x_reshaped .* sin(2*pi*F0*t_reshaped);
        x1_cos = x_reshaped .* cos(2*pi*F1*t_reshaped);
        x1_sin = x_reshaped .* sin(2*pi*F1*t_reshaped);
        x0 = sum(x0_cos).^2 + sum(x0_sin).^2;
        x1 = sum(x1_cos).^2 + sum(x1_sin).^2;
        H = x0 - x1;
        bits_res_GE = H<0;
end    


function [S_NRZ] = Signal_S_NRZ(f, t)
    S_NRZ = (1/4)*t*(sinc(pi*f*t).^2) + (1/4)*(f==0);
end