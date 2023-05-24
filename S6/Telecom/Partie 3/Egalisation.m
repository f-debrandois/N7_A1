% Projet de Telecommunication : Introduction à l'égalisation
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Fraine Sofiane
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-EF

clear all ; close all;

% Constantes
n_bits = 1000; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre
bits_test = [0 1 1 0 0 1]';

n_bits = 6;
bits = bits_test;

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits


%% 2. Impact d’un canal de propagation multitrajets
% 2.1 Etude théorique
figure('name', 'Etude théorique')

    % Signal de réception
    xe1 = (2*bits_test - 1);
    xe2 = 0.5*xe1
    
    nexttile
    plot([0 : 5], xe1)
    ylim([-1.5, 1.5])
    hold on
    plot(xe2)
    hold off
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Décomposition du signal de réception');
    legend('x(t)', '0.5 * x(t - Ts)');
    xticks([1 : 6])
    xticklabels("Ts")
    grid on;
    
    nexttile
    y = [xe1; 0] + [0; xe2]
    plot([0 : 6], y)
    ylim([-2, 2])
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Décomposition du signal de réception');
    xticks([1 : 6])
    xticklabels("Ts")
    grid on;

    % Diagramme de l'oeil
    nexttile
    y = kron(y, ones(2, 1));
    plot(reshape(y(2:end-1),2, (length(y)-2)/2));
    title('Diagramme de l''oeil');


% 2.2 Implantation sous Matlab
figure('name', 'Implantation sous Matlab')
Ts = Tb;            % Période symbole
Ns = Fe * Ts;       % Nombre d'échantillons par bits
n0 = Ns;            % Choix du t0 pour respecter le critère de Nyquist

h = ones(1, Ns);    % Reponse impulsionnelle du filtre de mise en forme
hr = fliplr(h);  % Reponse impulsionnelle du filtre de réception

alpha0 = 1;
alpha1 = 0.5;
hc = [alpha0 zeros(1,Ns-1) alpha1 zeros(1,Ns-1)]; % Reponse impulsionnelle du filtre canal

An = (2*bits - 1)';
At = [kron(An, [1, zeros(1, Ns-1)])];

x = filter(h, 1, At);

% Sans Canal
    z1 = filter(hr, 1, x);

    echantillon = z1(n0:Ns:end);
    bits_sortie1 = (sign(echantillon) + 1) / 2;
    TEB1 = sum(bits_sortie1' ~= bits) / n_bits;

    fprintf("TEB 1 : " + TEB1 + "\n");

    nexttile
    stem([0:(n_bits*Ns-1)]*Te,At)
    ylim([-1.5, 1.5])
    hold on
    stem([0:(n_bits*Ns-1)]*Te, kron((2*bits_sortie1 - 1), [1, zeros(1, Ns-1)]))
    hold off
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Comparaison des bits sans canal');
    legend('Bits de départ', 'Bits d''arrivée');

% Avec Canal
    z2 = filter(hr, 1, filter(hc, 1, x));

    % Signal de sortie
    nexttile
    plot([0:n_bits*Ns - 1] * Te, z2);
    title('Signal de sortie');
    xlabel("temps (s)")
    ylabel("Signal temporel")
    xticks([1 : n_bits] * Ts - Te)
    xticklabels("Ts")
    grid on;
    
    % Diagramme de l'oeil
    nexttile
    plot(reshape(z2,Ns,length(z2)/Ns));
    title('Diagramme de l''oeil');

    % Constellation


    % TEB obtenu


% Avec Bruit





%% 3. Egalisation ZFE
% 3.1 Etude à réaliser





%% 4. Egalisation MMSE
% 4.1 Etude à réaliser

r = filter(hc, 1, x);
z = filter(hr, 1, r);

g = conv(h, conv(hc, hr));

    % Signal de sortie
    nexttile
    plot([0:29] * Te, g);
    title('Réponse impulsionnelle globale');
    xticks([1 : 8] * Ts - Te)
    xticklabels("Ts")
    xlabel("temps (s)")
    grid on;

    nexttile
    plot([0:(n_bits+2)*Ns - 1] * Te, z);
    title('Signal de sortie');
    xticks([1 : 8] * Ts - Te)
    xticklabels("Ts")
    xlabel("temps (s)")
    ylabel("Signal temporel")
    grid on;

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z,Ns,length(z)/Ns));
    title('Diagramme de l''oeil');

    n0 = Ns;            % Choix du t0 pour respecter le critère de Nyquist



