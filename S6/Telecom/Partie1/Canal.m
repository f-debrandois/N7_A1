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


%% 3. Etude des interférences entre symbole et du critère de Nyquist
% Mapping
Ts = Tb;
Ns = Fe * Ts; % Nombre d'échantillons par bits
An = (2*bits - 1)';
At = kron(An, [1, zeros(1, Ns-1)]);

% Filtre
T = [0:(n_bits*Ns-1)]*Te; % Echelle temporelle
h = ones(1, Ns); % Reponse impulsionnelle du filtre
hr = h; % Reponse impulsionnelle du filtre de réception

x = filter(h, 1, At);
z1 = filter(hr, 1,x);

% Echantillonnage et detecteur à seuil
n0 = Ns;
echantillon = z1(n0:Ns:end);

bits_sortie1 = (sign(echantillon) + 1) / 2;
TEB_1 = sum(bits_sortie1' ~= bits) / n_bits;

% 3.1 Etude sans canal de propagation
% 1. Implantation optimale
figure('name', 'Implantation Optimale')

    % Filtre de réception
    nexttile
    plot([0:length(z1)-1]*Te, z1);
    title('Signal en sortie de filtre de récéption');
    ylabel('Signal en sortie');
    xlabel('Temps (s)')

    % Reponse impulsionnelle de g
    g = conv(h,hr);
    nexttile
    plot([0:length(g)-1]*Te, g);
    title('Réponse impulsionnelle globale');
    xlabel('Temps (s)')

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z1,Ns,length(z1)/Ns));
    title('Diagramme de l''oeil');

% 2. Modification des instants d'échantillonnage
figure('name', 'Modification des instants d''échantillonnage')
n0 = 3;
echantillonBis = z1(n0:Ns:end);

bits_sortie1Bis = (sign(echantillonBis) + 1) / 2;
TEB_1Bis = sum(bits_sortie1Bis' ~= bits) / n_bits;

    nexttile
    stem(T,At)
    ylim([-1.5, 1.5])
    hold on
    stem(T, kron((2*bits_sortie1 - 1), [1, zeros(1, Ns-1)]))
    hold off
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Comparaison des bits pour l''implantation optimale');
    legend('Bits de départ', 'Bits d''arrivée');

    nexttile
    stem(T,At)
    ylim([-1.5, 1.5])
    hold on
    stem(T, kron((2*bits_sortie1Bis - 1), [1, zeros(1, Ns-1)]))
    hold off
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Comparaison des bits pour instants d''échantillonnage modifiés');
    legend('Bits de départ', 'Bits d''arrivée');


% 3.2 Etude avec canal de propagation sans bruit
% Filtre
BW = 1000;

ordre = 101;
hc = 2*(BW/Fe) * sinc(2*(BW/Fe)*(-(ordre-1)/2:1:(ordre-1)/2)); % Filtre du canal
r2 = filter(hc, 1, [x zeros(1, (ordre-1)/2)]);
z2 = filter(hr, 1, r2);
z2 = z2((ordre-1)/2 + 1 : end);

% Echantillonnage et detecteur à seuil
n0 = Ns;
echantillon = z2(n0:Ns:end);

bits_sortie2 = (sign(echantillon) + 1) / 2;
TEB_2 = sum(bits_sortie2' ~= bits) / n_bits;

figure('name', 'Canal de propagation sans bruit')
    
    nexttile
    stem(T,At)
    ylim([-1.5, 1.5])
    hold on
    stem(T, kron((2*bits_sortie2 - 1), [1, zeros(1, Ns-1)]))
    hold off
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Comparaison des bits pour l''implantation optimale');
    legend('Bits de départ', 'Bits d''arrivée');

    % Reponse impulsionnelle de g
    g = conv(conv(h,hc), hr);
    nexttile
    plot([0:length(g)-1]*Te, g);
    title('Réponse impulsionnelle totale');
    xlabel('Temps (s)')

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z2,Ns,length(z2)/Ns));
    title('Diagramme de l''oeil');

    % Réponses en fréquence
    H = fft(h, 1024);
    Hc = fft(hc, 1024);
    Hr = fft(hr, 1024);

    nexttile
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(H .* Hr)/ max(abs(H .* Hr))));
    hold on
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(Hc)/ max(abs(Hc))));
    hold off
    title('Réponses en fréquence du filtre');
    xlabel('Fréquence (Hz)')
    legend('H * Hr', 'Hc');
