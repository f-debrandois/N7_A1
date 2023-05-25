clear all;
close all;

%% Paramètres
%alpha = 0.5;
Fe = 24000;
Rb = 6000;
N = 10000;
Rs = Rb/1;
Ns = Fe/Rs;
ordre = 121;
L = (ordre-1)/Ns;
Te = 1/Fe;
M = 2;
Ts = 1/Rs;

%% Implantation de la chaîne sans erreur de phase et sans bruit

% Génération du message
msg = randi([0 1], 1, N);

% Mapping
mapping = 2*msg - 1;

% Suréchantillonnage
suiteDirac = kron(mapping, [1 zeros(1, Ns-1)]);

% Filtrage
h = ones(1, Ns);
signalFiltre = filter(h, 1, suiteDirac);

% Démodulateur bande de base
signal_recu = filter(h, 1, signalFiltre);

% Diagramme de l'oeil
figure
plot(reshape(signal_recu,2*Ns,length(signal_recu)/2/Ns))
title("Diagramme de l'oeil en sortie du filtre de réception")

% Echantillonnage
signal_ech = signal_recu(Ns:Ns:end);

% Tracé de la constellation
figure
scatter(real(sign(signal_ech)), imag(sign(signal_ech)))
grid on
title("Tracé de la constellation en sortie de l'échantillonneur")
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
xlabel("ak");
ylabel("bk");
xlim([-1.5 1.5])
ylim([-1.5 1.5])

% Démapping
signal_dem = (sign(signal_ech) + 1)/2;
Taux_erreur = (sum(abs(signal_dem - msg))/length(msg))

%% Implantation de la chaîne avec erreur de phase et sans bruit

% Génération du message
msg = randi([0 1], 1, N);

% Mapping
mapping = 2*msg - 1;

% Suréchantillonnage
suiteDirac = kron(mapping, [1 zeros(1, Ns-1)]);

% Filtrage
h = ones(1, Ns);
signalFiltre = filter(h, 1, suiteDirac);

% Ajout de l'erreur de phase
phases = [0.7 1.7 pi];

numero = 1;
figure
for phi = phases
    % Ajout de l'erreur de phase
    signal_erreur = signalFiltre*exp(1i*phi);

    % Démodulateur bande de base
    signal_recu = filter(h, 1, signal_erreur);

    % Echantillonnage
    signal_ech = signal_recu(Ns:Ns:end);

    % Tracé de la constellation
    subplot(1,3,numero)
    scatter(real(sign(signal_ech)), imag(sign(signal_ech)))
    grid on
    sgtitle("Tracé de la constellation en sortie de l'échantillonneur")
    if numero == 1
        subtitle("phi = 40°")
    elseif numero == 2
        subtitle("phi = 100°")
    else
        subtitle("phi = 180°")
    end
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    xlabel("ak");
    ylabel("bk");
    grid on
    xlim([-1.5 1.5])   
    ylim([-1.5 1.5])
    numero = numero + 1;

    % Décision
    signal_decide = sign(real(signal_ech));

    % Démapping
    signal_dem = (signal_decide + 1)/2;
    Taux_erreur = (sum(abs(signal_dem - msg))/length(msg))
end


%% Implantation de la chaîne avec erreur de phase et avec bruit

% Génération du message
msg1 = randi([0 1], 1, N);

% Mapping
mapping = 2*msg1 - 1;

% Suréchantillonnage
suiteDirac = kron(mapping, [1 zeros(1, Ns-1)]);

% Filtrage
h = ones(1, Ns);
signalFiltre = filter(h, 1, suiteDirac);

% Ajout de l'erreur de phase
phi1 = (pi/2);
phi2 = 0;
phi3 = 1.7;

% Tracer le TEB en fonction du SNR
pas = 0.001;
SNR_abscisse_dB = [0:pas:6];
SNR_abscisse = 10.^(SNR_abscisse_dB/10);
for i = 1:length(SNR_abscisse)
    k = SNR_abscisse(i);
    sigma = sqrt(mean(abs(signalFiltre).^2)*Ns/(2*log2(M)*k));
    bruit = sigma*randn(1, length(signalFiltre));
    signal_bruite = signalFiltre + bruit;

    % Ajout de l'erreur de phase
    signal_erreur1 = signal_bruite*exp(1i*phi1);
    signal_erreur2 = signal_bruite*exp(1i*phi2);
    signal_erreur3 = signal_bruite*exp(1i*phi3);

    % Démodulateur bande de base
    signal_recu1 = filter(h, 1, signal_erreur1);
    signal_recu2 = filter(h, 1, signal_erreur2);
    signal_recu3 = filter(h, 1, signal_erreur3);

    % Echantillonnage
    signal_ech1 = signal_recu1(Ns:Ns:end);
    signal_ech2 = signal_recu2(Ns:Ns:end);
    signal_ech3 = signal_recu3(Ns:Ns:end);

    % Décision
    signal_decide1 = sign(real(signal_ech1));
    signal_decide2 = sign(real(signal_ech2));
    signal_decide3 = sign(real(signal_ech3));

    % Démapping
    signal_dem1 = (1+signal_decide1)/2;
    signal_dem2 = (1+signal_decide2)/2;
    signal_dem3 = (1+signal_decide3)/2;
    Taux_erreur1(i) = (sum(abs(signal_dem1 - msg1))/length(msg1));
    Taux_erreur2(i) = (sum(abs(signal_dem2 - msg1))/length(msg1));
    Taux_erreur3(i) = (sum(abs(signal_dem3 - msg1))/length(msg1));
end
figure
semilogy(SNR_abscisse_dB, Taux_erreur1, 'DisplayName', "phi = 40°");
title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")

% Tracé théorique
for i = 1:length(SNR_abscisse)
    k = SNR_abscisse(i);
    TEB_th(i) = qfunc(sqrt(2*k));
end
hold on
semilogy(SNR_abscisse_dB, TEB_th, 'g', 'DisplayName',"TEB théorique");
title("Taux d'erreur binaire théorique en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")
legend show

figure
semilogy(SNR_abscisse_dB, Taux_erreur1, 'DisplayName',"phi = 40°");
title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")
hold on
semilogy(SNR_abscisse_dB, Taux_erreur2, 'DisplayName',"phi = 0°");
title("Taux d'erreur binaire théorique en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")
legend show

figure
semilogy(SNR_abscisse_dB, Taux_erreur2, 'DisplayName',"phi = 40°");
title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")
hold on
semilogy(SNR_abscisse_dB, Taux_erreur3, '.', 'DisplayName',"phi = 100°");
title("Taux d'erreur binaire théorique en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")
legend show

%% Partie 3 : estimateur de l'erreur de phase

% Implantation de la chaîne avec erreur de phase et avec bruit

% Génération du message
msg1 = randi([0 1], 1, N);

% Mapping
mapping = 2*msg1 - 1;

% Suréchantillonnage
suiteDirac = kron(mapping, [1 zeros(1, Ns-1)]);

% Filtrage
h = ones(1, Ns);
signalFiltre = filter(h, 1, suiteDirac);

% Ajout de l'erreur de phase
phi1 = 0.7;
phi2 = 1.7;

% Tracer le TEB en fonction du SNR
pas = 0.001;
SNR_abscisse_dB = [0:pas:6];
SNR_abscisse = 10.^(SNR_abscisse_dB/10);
for i = 1:length(SNR_abscisse)
    k = SNR_abscisse(i);
    sigma = sqrt(mean(abs(signalFiltre).^2)*Ns/(2*log2(M)*k));
    bruit = sigma*randn(1, length(signalFiltre));
    signal_bruite = signalFiltre + bruit;

    % Ajout de l'erreur de phase
    signal_erreur1 = signal_bruite*exp(1i*phi1);
    signal_erreur2 = signal_bruite*exp(1i*phi2);

    % Démodulateur bande de base
    signal_recu1 = filter(h, 1, signal_erreur1);
    signal_recu2 = filter(h, 1, signal_erreur2);

    % Echantillonnage
    signal_ech1 = signal_recu1(Ns:Ns:end);
    signal_ech2 = signal_recu2(Ns:Ns:end);

    % Estimation de phi
    somme1 = sum(imag(signal_ech1.^2))/sum(real(signal_ech1.^2));
    somme2 = sum(imag(signal_ech2.^2))/sum(real(signal_ech2.^2));
    phi1_estime = 0.5*atan(somme1);
    phi2_estime = 0.5*atan(somme2);

    % Redresser l'axe des imaginaires d'un angle phi
    signal_redresse1 = signal_ech1*exp(-1i*phi1_estime);
    signal_redresse2 = signal_ech2*exp(-1i*(phi2_estime+(pi/2)));

    % Décision
    signal_decide1 = sign(real(signal_redresse1));
    signal_decide2 = sign(real(signal_redresse2));

    % Démapping
    signal_dem1 = (1+signal_decide1)/2;
    signal_dem2 = (1+signal_decide2)/2;
    Taux_erreur1(i) = (sum(abs(signal_dem1 - msg1))/length(msg1));
    Taux_erreur2(i) = (sum(abs(signal_dem2 - msg1))/length(msg1));
end
figure
semilogy(SNR_abscisse_dB, Taux_erreur1, 'DisplayName',"phi = 40°");
title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")

% Tracé théorique
hold on
for i = 1:length(SNR_abscisse)
    k = SNR_abscisse(i);
    TEB_th(i) = qfunc(sqrt(2*k));
end
hold on
semilogy(SNR_abscisse_dB, TEB_th, 'g', 'DisplayName',"TEB théorique");
title("Taux d'erreur binaire théorique en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")

hold on
semilogy(SNR_abscisse_dB, Taux_erreur2, 'DisplayName',"phi = 100°");
title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
xlabel("SNR")
ylabel("TEB")
legend show

%% Partie 4 : codage par transisition
% Tentative infructrueuse
% 
% % Implantation de la chaîne avec erreur de phase et avec bruit
% figure
% semilogy(SNR_abscisse_dB, Taux_erreur1, 'DisplayName',"phi = 40°");
% title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
% xlabel("SNR")
% ylabel("TEB")
% hold on
% semilogy(SNR_abscisse_dB, Taux_erreur2, 'DisplayName',"phi = 100°");
% title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
% xlabel("SNR")
% ylabel("TEB")
% 
% % Génération du message
% msg1 = randi([0 1], 1, N);
% 
% % Mapping
% mapping = 2*msg1 - 1;
% c(1) = 1;
% for i = 2:length(mapping)
%     c(i) = mapping(i)*c(i-1);
% end
% 
% % Suréchantillonnage
% suiteDirac = kron(c, [1 zeros(1, Ns-1)]);
% 
% % Filtrage
% h = ones(1, Ns);
% signalFiltre = filter(h, 1, suiteDirac);
% 
% % Ajout de l'erreur de phase
% phi1 = 0.7;
% phi2 = 1.7;
% 
% % Tracer le TEB en fonction du SNR
% pas = 0.001;
% SNR_abscisse_dB = [0:pas:6];
% SNR_abscisse = 10.^(SNR_abscisse_dB/10);
% for i = 1:length(SNR_abscisse)
%     k = SNR_abscisse(i);
%     sigma = sqrt(mean(abs(signalFiltre).^2)*Ns/(2*log2(M)*k));
%     bruit = sigma*randn(1, length(signalFiltre));
%     signal_bruite = signalFiltre + bruit;
% 
%     % Ajout de l'erreur de phase
%     signal_erreur1 = signal_bruite*exp(1i*phi1);
%     signal_erreur2 = signal_bruite*exp(1i*phi2);
% 
%     % Démodulateur bande de base
%     signal_recu1 = filter(h, 1, signal_erreur1);
%     signal_recu2 = filter(h, 1, signal_erreur2);
% 
%     % Echantillonnage
%     signal_ech1 = signal_recu1(Ns:Ns:end);
%     signal_ech2 = signal_recu2(Ns:Ns:end);
% 
%     % Décision
%     signal_decide1 = sign(real(signal_ech1));
%     signal_decide2 = sign(real(signal_ech2));
% 
%     % Décodage
%     for i = 2:length(signal_decide1)
%        a1(i) = signal_decide1(i)*signal_decide1(i-1);
%     end
%     for i = 2:length(signal_decide2)
%        a2(i) = signal_decide2(i)*signal_decide2(i-1);
%     end
% 
%     % Démapping
%     signal_dem1 = (1+a1)/2;
%     signal_dem2 = (1+a2)/2;
%     Taux_erreur1(i) = (sum(abs(signal_dem1 - msg1))/length(msg1));
%     Taux_erreur2(i) = (sum(abs(signal_dem2 - msg1))/length(msg1));
% end
% hold on
% semilogy(SNR_abscisse_dB, Taux_erreur1, 'DisplayName',"phi = 40°");
% title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
% xlabel("SNR")
% ylabel("TEB")
% 
% hold on
% semilogy(SNR_abscisse_dB, Taux_erreur2, 'DisplayName',"phi = 100°");
% title("Taux d'erreur binaire en fonction du rapport signal sur bruit")
% xlabel("SNR")
% ylabel("TEB")
% legend show


