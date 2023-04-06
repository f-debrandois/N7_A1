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
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits


%% 3. Etude des interférences entre symbole et du critère de Nyquist
% Mapping
Ts = Tb;
Ns = Fe * Ts; % Nombre d'échantillons par bits
An = (2*bits - 1)';
At = kron(An, [1, zeros(1, Ns-1)]);

% Filtre
T = 0:Te:(n_bits*Ns-1)*Te; % Echelle temporelle
h = ones(1, Ns); % Reponse impulsionnelle du filtre
hr = h; % Reponse impulsionnelle du filtre de réception

x = filter(h, 1, At);
z = filter(hr, 1,x);

TEB = 0;

% 3.1 Etude sans canal de propagation
% 1. Implantation optimale
figure('name', 'Implantation Optimale')

    % Filtre de réception
    nexttile
    plot(z);
    %ylim([-10, 10])
    title('Signal en sortie de filtre de récéption');
    ylabel('Signal en sortie');
    xlabel('Temps (s)')

    % Reponse impulsionnelle de g
    g = conv(h,hr);
    nexttile
    plot(g);
    title('Réponse impulsionnelle totale');
    xlabel('Temps (s)')

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z,Ns,length(z)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

% Implantation avec des instants d'échantillonnage modifiés



% 3.2 Etude avec canal de propagation sans bruit
% Filtre
BW = 8000;

ordre = 61;
hc = 2*(BW/Fe)* sinc(2*BW/Fe*(-(ordre-1)/2:1:(ordre-1)/2)); % Filtre du canal

z = filter(hr, 1, filter(hc, 1,x));

    % Reponse impulsionnelle de g
    g = conv(conv(h,hc), hr);
    nexttile
    plot(g);
    title('Réponse impulsionnelle totale');
    xlabel('Temps (s)')

    % Diagramme de l'oeil
    nexttile
    plot(reshape(z,Ns,length(z)/Ns));
    title('Diagramme de l''oeil');
    xlabel('Temps (s)')

    % Réponses en fréquence
    H = fft(h);
    Hc = fft(hc);
    Hr = fft(hr);

    nexttile
    plot(abs(H .* Hr));
    hold on
    plot(abs(Hc));
    hold off
    title('Réponses en fréquence du filtre');
    xlabel('Temps (s)')
    legend('H * Hr', 'Hc');

TEB = 0;
