% Demodulation par filtrage
%Felix Foucher Foucher de Brandois
%Achraf Marzougui

clear all ; close all;

n_bits = 20 ; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre
bits =[0; 1; 0; 0; 1; 1; 1; 0; 0; 1; 0; 0; 1; 0; 0; 0; 1; 0; 0; 1]

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

% F0 = 1180;
% F1 = 980;

Fc = (F0 + F1)/2;
Fc_norm = Fc/Fe;
ordre = 61;
K = 10; % Trouvé expérimentalement

SNR_dB = 50;
SNR_tab = [1; 2; 10; 15; 20; 25; 30; 40; 50; 70; 100];


T = 0:Te:(n_bits*Ns-1)*Te;

%% 5. Démodulation par filtrage
% Construction du signal d'entrée
NRZ = repelem(bits, Ns)';
T = 0:Te:(n_bits*Ns-1)*Te;
x = modulateur(bits, phi0, phi1, F0, F1);
P_x = mean(abs(x).^2);
P_y = P_x*10.^(-SNR_dB/10);
bruit = sqrt(P_y) * randn(1, length(x));

P_y_tab = P_x*10.^(-SNR_tab/10);
bruit_tab = sqrt(P_y_tab) * randn(1, length(x));

[x_perturbe] =  x + bruit;
[x_perturbe_tab] = x + bruit_tab;


% 5.1 Synthèse du filtre passe-bas
T_filtre = Te*[-(ordre-1)/2:(ordre-1)/2]; % Echelle temporelle du filtre passe bas
h_pb = 2*Fc_norm*sinc(2*Fc_norm*(T_filtre/Te)); % Reponse impulsionnelle du filtre passe bas
Hpb = fft(h_pb, ordre);
F_filtre = -Fe/2:Fe/length(Hpb):Fe/2 - Fe/length(Hpb);

% 5.2 Synthèse du filtre passe-haut
h_ph = -h_pb;
h_ph((ordre+1)/2) = h_ph((ordre+1)/2)+1;
Hph = fft(h_ph, ordre);

% 5.3 Filtrage
Xpb_d = filter(h_pb, 1, [x_perturbe, zeros(1, floor(ordre/2) - 1)]);
Xpb = Xpb_d(floor(ordre/2):end);

Xph_d = filter(h_ph, 1, [x_perturbe, zeros(1, floor(ordre/2) - 1)]);
Xph = Xph_d(floor(ordre/2):end);

% 5.4 Tracés à réaliser
% 1 Réponse impulsionnelle et réponse en fréquence
figure('name', 'Réponse des filtres')
nexttile
plot(T_filtre, h_pb);
hold on
plot(T_filtre, h_ph);
hold off
xlabel("Temps (s)");
ylabel("h(t)");
title("Réponse impulsionelle des filtres" );
legend('Passe-bas', 'Passe-haut');

nexttile
plot(F_filtre, abs(Hpb));
hold on
plot(F_filtre, abs(Hph));
hold off
xlabel("Fréquence (Hz)");
ylabel("H(f)");
title("Réponse fréquencielle des filtres" );
legend('Passe-bas', 'Passe-haut');

% 2 DSP du signal modulé et réponse en fréquence du filtre
figure('name', 'DSP et réponse des filtres')
DSP_x = pwelch(x,[],[],[],Fe,'twosided');
F = -Fe/2 : Fe/length(DSP_x) : Fe/2 - Fe/length(DSP_x);
nexttile
semilogy(F, fftshift(DSP_x))
hold on
semilogy(F_filtre, abs(Hpb))
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
figure('name', 'Signal de sortie et DSP')
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
figure('name', 'Bits de sortie par filtrage')

bits_restitues_pb = demodulateur_filtre(x_perturbe, F0, F1, ordre, K, "pb");
bits_restitues_ph = demodulateur_filtre(x_perturbe, F0, F1, ordre, K, "ph");
NRZ_sortie_pb = repelem(bits_restitues_pb, Ns)';
NRZ_sortie_ph = repelem(bits_restitues_ph, Ns)';

% 2 Erreur binaire
taux_pb = sum(bits_restitues_pb' ~= bits)/n_bits; % le taux d'erreur
taux_ph = sum(bits_restitues_ph' ~= bits)/n_bits;

nexttile
plot(T, NRZ);
hold on
plot(T, NRZ_sortie_pb);
hold off
ylim([-0.5, 1.5])
xlabel("temps (s)")
ylabel("NRZ(t)")
title({['Comparaison des bits pour filtre passe-bas. SNR = ' num2str(SNR_dB)] ['Taux d''erreur = ' num2str(taux_pb)]})
legend('bits d''entrée', 'bits de sortie');

nexttile
plot(T, NRZ);
hold on
plot(T, NRZ_sortie_ph);
hold off
ylim([-0.5, 1.5])
xlabel("temps (s)")
ylabel("NRZ(t)")
title({['Comparaison des bits pour filtre passe-haut. SNR = ' num2str(SNR_dB)] ['Taux d''erreur = ' num2str(taux_ph)]})
legend('bits d''entrée', 'bits de sortie');

% Evolution de l'erreur binaire en fonction du rapport signal sur bruit
taux_tab_pb = zeros(1, length(SNR_tab));
taux_tab_ph = zeros(1, length(SNR_tab));
for i = 1:length(SNR_tab)
    bits_restitues_pb = demodulateur_filtre(x_perturbe_tab(i, :), F0, F1, ordre, K, "pb");
    taux_tab_pb(i) = sum(bits_restitues_pb' ~= bits)/n_bits ; % le taux d'erreur

    bits_restitues_ph = demodulateur_filtre(x_perturbe_tab(i, :), F0, F1, ordre, K, "ph");
    taux_tab_ph(i) = sum(bits_restitues_ph' ~= bits)/n_bits ; % le taux d'erreur
end

nexttile
semilogx(SNR_tab, taux_tab_pb);
xlabel("SNR")
ylabel("Taux d'erreur binaire")
title("TEB en fonction du rapport signal / bruit pour le passe-bas")

nexttile
semilogx(SNR_tab, taux_tab_ph);
xlabel("SNR")
ylabel("Taux d'erreur binaire")
title("TEB en fonction du rapport signal / bruit pour le passe-haut")