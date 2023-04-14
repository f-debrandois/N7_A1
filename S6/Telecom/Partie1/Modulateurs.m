% Projet de Telecommunication : Etude de modulateurs bande de base
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-E

clear all ; close all;

% Constantes
n_bits = 1000; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits


%% 2. Etude de modulateurs bande de base
% Modulateur 1 ----------------------
% 1. Mapping
Ts = Tb; % Période symbole
Ns = Fe * Ts; % Nombre d'échantillons par bits

An = (2*bits - 1)';
At = kron(An, [1, zeros(1, Ns-1)]);

% 2. Filtre
T1 = 0:Te:(n_bits*Ns-1)*Te; % Echelle temporelle
h1 = ones(1, Ns); % Reponse impulsionnelle du filtre
x1 = filter(h1, 1, At);

% 3. Tracés
figure('name', 'Modulateur 1')

    % Signal généré
    nexttile
    stem(T1,At)
    ylim([-1.5, 1.5])
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Tracé du signal temporel');
    
    nexttile
    plot(T1,x1)
    ylim([-1.5, 1.5])
    xlabel("temps (s)")
    ylabel("Signal filtré")
    title('Tracé du signal temporel filtré');
    
    % DSP du signal généré
    [DSP_x1, F1] = pwelch(x1,[],[],[],Fe,'twosided', 'centered');

    nexttile
    semilogy(F1, DSP_x1)
    xlabel("fréquence (Hz)")
    ylabel("DSP")
    title('Densité spectrale de puissance du signal x(t)');
    
    % Comparaison DSP estimée et théorique
    DSP_th_x1 = Ts * sinc(F1*Ts).^2;
    
    nexttile
    semilogy(F1, DSP_x1)
    hold on
    semilogy(F1, DSP_th_x1)
    hold off
    xlabel('fréquence (Hz)');
    ylabel('signal');
    title('Tracé de la DSP estimée et de la DSP théorique');
    legend('DSP estimée', 'DSP théorique');


% Modulateur 2 ----------------------
% 1. Mapping
Ts = 2 * Tb; % Période symbole
Ns = Fe * Ts; % Nombre d'échantillons par bits

LUT = [-3, -1, 3, 1];
An = LUT(1+bi2de(reshape(bits, n_bits/2, 2), 'left-msb'));
At = kron(An, [1, zeros(1, Ns-1)]);

% 2. Filtre
T2 = 0:Te:(n_bits*Ns-1)*Te/2; % Echelle temporelle
h2= ones(1, Ns); % Reponse impulsionnelle du filtre
x2 = filter(h2, 1, At);

% 3. Tracés
figure('name', 'Modulateur 2')

    % Signal généré
    nexttile
    stem(T2,At)
    ylim([-3.5, 3.5])
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Tracé du signal temporel');

    nexttile
    plot(T2,x2)
    ylim([-3.5, 3.5])
    xlabel("temps (s)")
    ylabel("Signal filtré")
    title('Tracé du signal temporel filtré');
    
    % DSP du signal généré
    [DSP_x2, F2] = pwelch(x2,[],[],[],Fe,'twosided', 'centered');
    
    nexttile
    semilogy(F2, DSP_x2)
    xlabel("fréquence (Hz)")
    ylabel("DSP")
    title('Densité spectrale de puissance du signal x(t)');
    
    % Comparaison DSP estimée et théorique
    DSP_th_x2 = 5 * Ts * sinc(F2*Ts).^2;
    
    nexttile
    semilogy(F2, DSP_x2)
    hold on
    semilogy(F2, DSP_th_x2)
    hold off
    xlabel('fréquence (Hz)');
    ylabel('signal');
    title('Tracé de la DSP estimée et de la DSP théorique');
    legend('DSP estimée', 'DSP théorique');



% Modulateur 3 ----------------------
% 1. Mapping
Ts = Tb; % Période symbole
Ns = Fe * Ts; % Nombre d'échantillons par bits

An = (2*bits - 1)';
At = kron(An, [1, zeros(1, Ns-1)]);

% 2. Filtre
alpha = 0.5;
L = 10;

T3 = 0:Te:(n_bits*Ns-1)*Te; % Echelle temporelle
h3 = rcosdesign(alpha, L, Ns); % Reponse impulsionnelle du filtre
x3 = filter(h3, 1, At);

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
    plot(T3,x3)
    ylim([-1.5, 1.5])
    xlabel("temps (s)")
    ylabel("Signal filtré")
    title('Tracé du signal temporel filtré');
    
    % DSP du signal généré
    [DSP_x3, F3] = pwelch(x3,[],[],[],Fe,'twosided', 'centered');
    
    nexttile
    semilogy(F3, DSP_x3)
    xlabel("fréquence (Hz)")
    ylabel("DSP")
    title('Densité spectrale de puissance du signal x(t)');
    
    % Comparaison DSP estimée et théorique
    DSP_th_x3 = zeros(1, length(F3));
    I1 = find(abs(F3) < (1-alpha)/(2*Ts));
    DSP_th_x3(find(abs(F3) < (1-alpha)/(2*Ts))) = Ts;
    I2 = find(abs(F3) >= (1-alpha)/(2*Ts) & abs(F3) <= (1+alpha)/(2*Ts));
    DSP_th_x3(find(abs(F3) >= (1-alpha)/(2*Ts) & abs(F3) <= (1+alpha)/(2*Ts))) = (Ts/2)*(1 + cos(pi* Ts / alpha*(abs(F3(I2)) - (1-alpha)/(2*Ts))));

    nexttile
    semilogy(F3,DSP_x3)
    hold on
    semilogy(F3, DSP_th_x3)
    hold off
    xlabel('fréquence (Hz)');
    ylabel('signal');
    title('Tracé de la DSP estimée et de la DSP théorique');
    legend('DSP estimée', 'DSP théorique');

% Comparaison des modulateurs -------
    figure('name', 'Comparaison des modulateurs')
    nexttile
    semilogy(F1,DSP_x1)
    hold on
    semilogy(F2, DSP_x2)
    hold on
    semilogy(F3, DSP_x3)
    hold off
    xlabel('fréquence (Hz)');
    ylabel('signal');
    title('Tracé de la DSP estimée des 3 modulateurs');
    legend('Mod 1', 'Mod 2', 'Mod 3');
