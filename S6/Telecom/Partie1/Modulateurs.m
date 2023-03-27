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
D = 3000; % Débits de la transmission
Ns = Fe/D; % Nombre d'échantillons par bits
Ts = Ns/Fe; % Période par bits
Fs = 1/Ts; %% Fréquence des bits


%% 2. Etude de modulateurs bande de base
% Modulateur 1 ----------------------
% 1. Mapping
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
    title('Densité spectrale de puissance du signal s(t)');
    
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
    title('Densité spectrale de puissance du signal s(t)');
    
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
    title('Densité spectrale de puissance du signal s(t)');
    
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


%% 3. Etude des interférences entre symbole et du critère de Nyquist
% 3.1 Etude sans canal de propagation
% Modulateur 1 ----------------------
    % Filtre de réception
    figure('name', 'Modulateur 1')
    
    hr1 =h1;
    z1 = filter(hr1,1,x1);
    nexttile
    plot(z1);
    %ylim([-10, 10])
    title('Signal en sortie de filtre de récéption');
    ylabel('Signal en sortie');
    xlabel('Temps (s)')
    
    % Réponse impulsionnelle globale
    nexttile
    g1 = conv(h1,hr1);
    plot(g1);
    title('Réponse impulsionnelle totale');
    xlabel('Temps (s)')
    
    % Diagramme de l'oeil
    nexttile
    plot(reshape(z1,Ns,length(z1)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

 
% Modulateur 2 ----------------------
    % Filtre de réception
    figure('name', 'Modulateur 2')
    
    hr2 =h2;
    z2 = filter(hr2,1,x2);
    nexttile
    plot(z2);
    %ylim([-10, 10])
    title('Signal en sortie de filtre de récéption');
    ylabel('Signal en sortie');
    xlabel('Temps (s)')
    
    % Réponse impulsionnelle globale
    nexttile
    g2 = conv(h2,hr2);
    plot(g2);
    title('Réponse impulsionnelle totale');
    xlabel('Temps (s)')
    
    % Diagramme de l'oeil
    nexttile
    plot(reshape(z2,Ns,length(z2)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

    % Modulateur 3 ----------------------
    % Filtre de réception
    figure('name', 'Modulateur 3')
    
    hr3 =h3;
    z3 = filter(hr3,1,x3);
    nexttile
    plot(z3);
    %ylim([-10, 10])
    title('Signal en sortie de filtre de récéption');
    ylabel('Signal en sortie');
    xlabel('Temps (s)')
    
    % Réponse impulsionnelle globale
    nexttile
    g3 = conv(h3,hr3);
    plot(g3);
    title('Réponse impulsionnelle totale');
    xlabel('Temps (s)')
    
    % Diagramme de l'oeil
    nexttile
    plot(reshape(z3,Ns,length(z3)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

 