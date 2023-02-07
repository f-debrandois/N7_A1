% Etude de modulateurs bande de base
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


%% Modulateur 1
% 1. Mapping
An = (2*bits - 1)';
At = kron(An, [1, zeros(1, Ns-1)]);

% 2. Filtre
T1 = 0:Te:(n_bits*Ns-1)*Te; % Echelle temporelle
h = ones(1, Ns); % Reponse impulsionnelle du filtre
St = filter(h, 1, At);

% 3. Tracés
figure('name', 'Modulateur 1')

% Signal généré
% nexttile
% stem(T1,At)
% ylim([-1.5, 1.5])
% xlabel("temps (s)")
% ylabel("Signal temporel")
% title('Tracé du signal temporel');

nexttile
plot(T1,St)
ylim([-1.5, 1.5])
xlabel("temps (s)")
ylabel("Signal filtré")
title('Tracé du signal temporel filtré');

% DSP du signal généré
DSP_St = pwelch(St,[],[],[],Fe,'twosided');
F = -Fe/2 : Fe/length(DSP_St) : Fe/2 - Fe/length(DSP_St); % Echelle fréquentielle

nexttile
semilogy(F, fftshift(DSP_St))
xlabel("fréquence (Hz)")
ylabel("DSP")
title('Densité spectrale de puissance du signal s(t)');

% Comparaison DSP estimée et théorique
S_s = DSP_St;

nexttile
semilogy(F, fftshift(DSP_St))
hold on
semilogy(F, S_s)
hold off
xlabel('fréquence (Hz)');
ylabel('signal');
title('tracé de la DSP estimée et de la DSP théorique');
legend('DSP estimée', 'DSP théorique');


%% Modulateur 2
% Mapping
LUT = [-3, -1, 3, 1];
An = LUT(1+bi2de(reshape(bits, n_bits/2, 2), 'left-msb'));
At = kron(An, [1, zeros(1, Ns-1)]);

% 2. Filtre
T2 = 0:Te:(n_bits*Ns-1)*Te/2; % Echelle temporelle
h = ones(1, Ns); % Reponse impulsionnelle du filtre
St = filter(h, 1, At);

% 3. Tracés
figure('name', 'Modulateur 2')

% Signal généré
nexttile
plot(T2,St)
ylim([-3.5, 3.5])
xlabel("temps (s)")
ylabel("Signal filtré")
title('Tracé du signal temporel filtré');

% DSP du signal généré
DSP_St = pwelch(St,[],[],[],Fe,'twosided');
F = -Fe/2 : Fe/length(DSP_St) : Fe/2 - Fe/length(DSP_St); % Echelle fréquentielle

nexttile
semilogy(F, fftshift(DSP_St))
xlabel("fréquence (Hz)")
ylabel("DSP")
title('Densité spectrale de puissance du signal s(t)');

% Comparaison DSP estimée et théorique
S_s = DSP_St;

nexttile
semilogy(F, fftshift(DSP_St))
hold on
semilogy(F, S_s)
hold off
xlabel('fréquence (Hz)');
ylabel('signal');
title('tracé de la DSP estimée et de la DSP théorique');
legend('DSP estimée', 'DSP théorique');



%% Modulateur 3
% Mapping
LUT = [-3, -1, 3, 1];
An = LUT(1+bi2de(reshape(bits, n_bits/2, 2), 'left-msb'));
At = kron(An, [1, zeros(1, Ns-1)]);

% 2. Filtre
T3 = 0:Te:(n_bits*Ns-1)*Te; % Echelle temporelle
h = ones(1, Ns/2); % Reponse impulsionnelle du filtre
St = filter(h, 1, At);

% 3. Tracés
figure('name', 'Modulateur 3')

% Signal généré
nexttile
stem(T3,At)
ylim([-1.5, 1.5])
xlabel("temps (s)")
ylabel("Signal temporel")
title('Tracé du signal temporel');

nexttile
plot(T3,St)
ylim([-1.5, 1.5])
xlabel("temps (s)")
ylabel("Signal filtré")
title('Tracé du signal temporel filtré');

% DSP du signal généré
DSP_St = pwelch(St,[],[],[],Fe,'twosided');
F = -Fe/2 : Fe/length(DSP_St) : Fe/2 - Fe/length(DSP_St); % Echelle fréquentielle

nexttile
semilogy(F, fftshift(DSP_St))
xlabel("fréquence (Hz)")
ylabel("DSP")
title('Densité spectrale de puissance du signal s(t)');

% Comparaison DSP estimée et théorique
S_s = DSP_St;

nexttile
semilogy(F, fftshift(DSP_St))
hold on
semilogy(F, S_s)
hold off
xlabel('fréquence (Hz)');
ylabel('signal');
title('tracé de la DSP estimée et de la DSP théorique');
legend('DSP estimée', 'DSP théorique');

