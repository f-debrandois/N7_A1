% Projet de Telecommunication : Introduction à l'égalisation
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-E

clear all ; close all;

% Constantes
Fe = 24000;
Rb = 3000;
fp = 2000;
alpha = 0.35;
nb_bits = 120000;
M = 4;
n = log2(M);
Ns = 8;

%% 2. Implantation de la chaîne de transmission avec transposition de fréquence
L = 100;
h = rcosdesign(alpha,L,Ns);
hr=h;
filtre_passe_bas = ones(1,3); % pour éliminer la fréquence porteuse.
dirac = [1 zeros(1,Ns-1)];
Eb_n0 = [0:6];
bits = randi([0 1],1,nb_bits);

%Mapping 
symboles1 = 2*bits(1:2:end)-1;
symboles2 = 2*bits(2:2:end)-1;
Symboles = symboles1 + 1i*symboles2;

%Suite diracs 
Suite_diracs = kron(Symboles,dirac);

%Génération du signal
signal_genere = filter(h,1,[Suite_diracs zeros(1,L*Ns/2)]);
signal_genere = signal_genere(L*Ns/2 +1 : end);

%Affichage du signal généré
figure('name', 'Signaux');
signal_reel = real(signal_genere);
nexttile
plot(signal_reel)
axis([0 4000 -1 1])
title("Signal généré sur la voie en phase")
ylabel("Signal généré")
nexttile
signal_imaginaire = imag(signal_genere);
plot(signal_imaginaire)
axis([0 4000 -1 1])
title("Signal généré sur la voie en quadrature")
ylabel("Signal généré")

% Affichage du signal transmis sur fréquence porteuse
x = real(signal_genere.*exp(2*1i*pi*fp*[1:length(signal_genere)]/Fe));
nexttile
plot(x)
axis([0 4000 -1 1])
title("Signal tranmis sur la fréquence porteuse")
ylabel("Signal transmis")

%Affichage de la DSP des signaux générés sur les voies en phase et en quadrature
% la voie en phase 
figure('name', 'DSP');
N_sup = 2^nextpow2(length(signal_reel));
dsp_reel = 1/length(signal_reel) * abs(fft(signal_reel,N_sup)).^2;
nexttile
semilogy(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_reel));
title("DSP du signal généré sur la voie en phase")
xlabel("Fréquences")
ylabel("DSP")
% la voie en quadrature
N_sup = 2^nextpow2(length(signal_imaginaire));
dsp_imaginaire = 1/length(signal_imaginaire) * abs(fft(signal_imaginaire,N_sup)).^2;
nexttile
semilogy(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_imaginaire));
title("DSP du signal généré sur la voie en quadrature")
xlabel("Fréquences")
ylabel("DSP")

%Affichage de la DSP du signal transmis sur fréquence porteuse
N_sup = 2^nextpow2(length(x));
dsp = 1/length(x) * abs(fft(x,N_sup)).^2;
nexttile
semilogy(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp));
title("DSP du signal transmis sur fréquence porteuse")
xlabel("Fréquences")
ylabel("DSP")

% Affichage du TEB et comparaison entre TEB simulé et théorique 
%Retour en bande de base
x1 = x.*cos(2*pi*fp*[1:length(signal_genere)]/Fe);
x2 = x.*sin(2*pi*fp*[1:length(signal_genere)]/Fe);
%Passage par un filtre passe bas.
x1_filtre = filter(filtre_passe_bas,1,x1);
x2_filtre = filter(filtre_passe_bas,1,x2);
signal_filtre = x1_filtre -1i* x2_filtre;
%Passage par filtre de réception
x_r = filter(h,1,[signal_filtre zeros(1,L*Ns/2)]);
x_r = x_r(L*Ns/2 +1:end);
%Echantillonnage
x_echantillonne = x_r(1:Ns:end);
%Demapping
bits_recu = zeros(1,nb_bits);
symboles_1_r = (sign(real(x_echantillonne))+1)/2;
symboles_2_r = (sign(imag(x_echantillonne))+1)/2; 
bits_recu(1:2:end) = symboles_1_r;
bits_recu(2:2:end) = symboles_2_r;
% TEB 
nb_erreurs = length(find(bits ~= bits_recu));
TEB_obtenu = nb_erreurs/length(bits);
fprintf("Le TEB obtenu sans bruit est  %f \n",TEB_obtenu)

% Rajouter le bruit et tracer TEB.
figure('name', 'TEB');
for i = 1:length(Eb_n0)
    %Calcul de la puissance
    sigma2 = mean(abs(x).^2)*Ns/(2*log2(M)*10^(Eb_n0(i)/10));
    
    %Génération et ajout du bruit
    b = sqrt(sigma2)*randn(1,length(x));
    r = x + b;
    
    %Retour en bande de base
    xi1_retour = r.*cos(2*pi*fp*[1:length(signal_genere)]/Fe);
    xi2_retour = r.*sin(2*pi*fp*[1:length(signal_genere)]/Fe);
    
    %Passage par un filtre passe bas.
    xi1_filtre = filter(filtre_passe_bas,1,xi1_retour);
    xi2_filtre = filter(filtre_passe_bas,1,xi2_retour);
    xi_filtre    = xi1_filtre -1i* xi2_filtre;
    
    %Passage par filtre de réception
    xi_r = filter(h,1,[xi_filtre zeros(1,L*Ns/2)]);
    xi_r = xi_r(L*Ns/2 +1:end);
    
    %Echantillonnage
    xi_ech = xi_r(1:Ns:end);
    
    %Demapping
    bits_recu_i = zeros(1,nb_bits);
    symboles_ai_r = (sign(real(xi_ech))+1)/2;
    symboles_bi_r = (sign(imag(xi_ech))+1)/2; 
    bits_recu_i(1:2:end) = symboles_ai_r;
    bits_recu_i(2:2:end) = symboles_bi_r;
    
    %Calcul du TEB
    nb_erreurs_i = length(find(bits ~= bits_recu_i));
    TEB_qpsk(i) = nb_erreurs_i/length(bits);
    
end
nexttile
semilogy(Eb_n0,TEB_qpsk,'x-');
title("TEB avec bruit");
xlabel("Eb/N0 (dB)");
ylabel("TEB");
grid on;

% Comparaison TEB simulé et TEB théorique.
TEB_theorique = qfunc(sqrt(2*10.^(Eb_n0/10)));
nexttile
semilogy(Eb_n0,TEB_qpsk,'x-')
hold on
semilogy(Eb_n0,TEB_theorique,'o-');
title("Comparaison entre TEB simulé et TEB théorique");
xlabel("Eb/N0 (dB)");
ylabel("TEB");
legend("TEB simulé","TEB théorique");
grid on;
%-------------------------------

%% Implantation de chaine passe-bas équivalente à la chaine de transmission 
% Affichage des signaux générés sur les voies en phase et en quadrature
figure('name', 'Implantation de chaine passe-bas équivalente');
nexttile
plot(signal_reel);
axis([0 4000 -1 1])
title("Signal généré sur la voie en phase");
ylabel("Signal généré");
nexttile
plot(signal_imaginaire);
axis([0 4000 -1 1])
title("Signal généré sur la voie en quadrature");
ylabel("Signal généré");

% DSP de l'enveloppe complexe associée au signal modulé sur fréquence porteuse
x = signal_genere;
N_sup = 2^nextpow2(length(x));
dsp_x_pb = 1/length(x) * abs(fft(x,N_sup)).^2;
nexttile
semilogy(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_x_pb));
title("DSP de l'enveloppe complexe associée au signal modulé sur fréquence porteuse");
xlabel("Fréquences normalisées");
ylabel("Densité spectrale de puissance");

% Comparaison entre DSP de l'enveloppe conplexe et celle du signal sur
% fréquence porteuse
nexttile
semilogy(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_x_pb));
hold on;
semilogy(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp));
title("Comparaison entre les deux DSPs des deux parties");
xlabel("Fréquences normalisées");
ylabel("Densité spectrale de puissance");
legend("Chaine passe-bas équivalente","Chaine sur fréquence porteuse")

% Implantation de la chaine complète sans bruit et vérifier que TEB est nul

%1-Passage par filtre de réception
x_r = filter(hr,1,[x zeros(1,L*Ns/2)]);
x_r = x_r(L*Ns/2 +1:end);

%2-Echantillonnage
x_ech = x_r(1:Ns:end);

%3-Demapping
bits_recu = zeros(1,nb_bits);
symboles_a_r = (sign(real(x_ech))+1)/2;
symboles_b_r = (sign(imag(x_ech))+1)/2; 
bits_recu(1:2:end) = symboles_a_r;
bits_recu(2:2:end) = symboles_b_r;

%4-TEB 
nb_erreurs = length(find(bits ~= bits_recu));
TEB_obtenu = nb_erreurs/length(bits);
fprintf("(3.2.2) 3. Le TEB obtenu sans bruit est bien %f \n",TEB_obtenu)

% (4) - Rajouter le bruit et tracer TEB.
for i = 1:length(Eb_n0)
    %Calcul de la puissance
    sigma2 = mean(abs(x).^2)*Ns/(2*log2(M)*10^(Eb_n0(i)/10));
    
    %Génération et ajout du bruit
    br = sqrt(sigma2)*randn(1,length(real(x)));
    bi = sqrt(sigma2)*randn(1,length(imag(x)));
    b = br + 1i * bi;
    r = x + b;
    
    %Passage par filtre de réception
    xi_r = filter(hr,1,[r zeros(1,L*Ns/2)]);
    xi_r = xi_r(L*Ns/2 +1:end);
    
    %Echantillonnage
    xi_ech = xi_r(1:Ns:end);
    
    %Demapping
    bits_recu_i = zeros(1,nb_bits);
    symboles_ai_r = (sign(real(xi_ech))+1)/2;
    symboles_bi_r = (sign(imag(xi_ech))+1)/2; 
    bits_recu_i(1:2:end) = symboles_ai_r;
    bits_recu_i(2:2:end) = symboles_bi_r;
    
    %Calcul du TEB
    nb_erreurs_i = length(find(bits ~= bits_recu_i));
    TEB_pb(i) = nb_erreurs_i/length(bits);
    
end

% constellations en sortie du mapping et en sortie de
% l'échantillonneur pour valeur donnée de Eb/N0.
scatterplot(Symboles);
title("Les constellations en sortie du mapping");

%Pour une valeur de Eb/N0 égale à 6dB.
scatterplot(xi_ech);
title("Les constellations en sortie de l'échantillonneur");

% Affichage du TEB
figure('name', 'TEB avec bruit');
nexttile
semilogy(Eb_n0,TEB_pb,'x-');
title("Taux d'erreur binaire obtenu avec bruit");
xlabel("Eb/N0 (en dB)");
ylabel("TEB");
grid on;

% Comparaison TEB de la chaine passe-bas équivalente et de la chaine
% sur fréquence porteuse.
nexttile
semilogy(Eb_n0,TEB_pb,'x-');
hold on;
semilogy(Eb_n0,TEB_qpsk,'v-');
title("Taux d'erreur binaire pour les deux chaines");
xlabel("Eb/N0 (en dB)");
ylabel("TEB");
legend("Chaine passe-bas équivalente","Chaine sur fréquence porteuse");
grid on;


%% 4- Comparaison du modulateur DVS-S avec un des modulateurs
%% proposées par le DVB-S2:
% Implantation du modulateur DVB-S2:
%--------------------
% Paramètres du système
Fe = 6000;  % Fréquence d'échantillonnage (Hz)
Rb = 3000;  % Débit binaire (bps)
Ts = 1/Rb;  % Période de symbole (s)
T = 1/Fe;   % Période d'échantillonnage (s)
alpha_dvbs2 = 0.20;  % Roll off pour DVB-S2

% Génération des symboles 8-PSK
nb_symboles = 1000;
symboles = randi([0, 7], 1, nb_symboles);
symboles_8psk = exp(1i * (2*pi/8) * symboles);

% Filtrage de mise en forme avec un filtre en racine de cosinus surélevé pour DVB-S2
filtre_dvbs2 = rcosdesign(alpha_dvbs2, 6, Ts/T);
signal_dvbs2 = upfirdn(symboles_8psk, filtre_dvbs2, Fe);

% Filtrage de réception avec un filtre en racine de cosinus surélevé pour DVB-S2
signal_rx_dvbs2 = upfirdn(signal_dvbs2, filtre_dvbs2, 1, 6);

% Démodulation 8-PSK
symboles_rx_8psk = signal_rx_dvbs2(1:6:end) .* exp(-1i * (2*pi/8));

% Echantillonnage
indices_echantillons = 1:6:length(signal_rx_dvbs2);
echantillons_rx_8psk = signal_rx_dvbs2(indices_echantillons);

% Tracé des constellations
figure('name', 'Constellations');
subplot(2,1,1);
plot(symboles_8psk, 'o');
xlabel('Partie réelle');
ylabel('Partie imaginaire');
title('Constellation en sortie du mapping (8-PSK)');

subplot(2,1,2);
plot(real(echantillons_rx_8psk), imag(echantillons_rx_8psk), 'o');
xlabel('Partie réelle');
ylabel('Partie imaginaire');
title('Constellation en sortie de l''échantillonneur (8-PSK)');
M_PSK= 8;% Ordre de modulation
nb_PSK = log2(M_PSK);% Nombre de bits par symbole

%Génération des symboles binaires
bits_psk = reshape(bits,[nb_bits/nb_PSK,nb_PSK]);

%Mapping
map_psk = pskmod(bi2de(bits_psk).',M_PSK,pi/M_PSK,'gray');

%surechantillonage
Rs_PSK=Rb/nb_PSK;
Ns_PSK=floor(Fe/Rs_PSK);
N0_PSK=L*Ns_PSK/2;
suite_dirac_ak=kron(real(map_psk),[1 zeros(1,Ns_PSK-1)]);
suite_dirac_bk=kron(imag(map_psk),[1 zeros(1,Ns_PSK-1)]);

%Filtrage de mise en forme :
h_PSK=rcosdesign(alpha,L,Ns_PSK,'sqrt'); %reponse impultionnelle

%génération du signal sur les voies en phase:
I=filter(h_PSK,1,[suite_dirac_ak zeros(1,N0_PSK)]);
I=I(N0_PSK+1:end);

%génération du signal sur les voies en quadrarture:
Q=filter(h_PSK,1,[suite_dirac_bk zeros(1,N0_PSK)]);
Q=Q(N0_PSK+1:end);
Enveloppe_PSK=I+1i*Q; %Enveloppe complexe

%Demodulation bande de base :
z=filter(h_PSK,1,[Enveloppe_PSK zeros(1,N0_PSK)]);
z=z(N0_PSK+1:end);

%Echantillonnage:
zm_PSK=z(1:Ns_PSK:end);

%Demapping :
bits_decides_psk = pskdemod(zm_PSK,M_PSK,pi/M_PSK,'gray');
bits_decides_psk = de2bi(bits_decides_psk.');
bits_sortie_psk = bits_decides_psk(:)';

%Calcul du TEB :
TEB_PSK= length(find(bits~=bits_sortie_psk))/nb_bits;
 pre=mean(abs(Enveloppe_PSK).^2); %Puissance de l'enveloppe complexe
     TEB_bruit_PSK=zeros(1,length(Eb_n0));
    for i = 1:length(Eb_n0)
       rsb_dec = 10^(Eb_n0(i)/10);

       %Ajout de bruit :
       p_bruit=pre*Ns_PSK/(2*rsb_dec*log2(M_PSK));
       bruitQ=sqrt(p_bruit)*randn(1,length(Enveloppe_PSK));
       bruitI=sqrt(p_bruit)*randn(1,length(Enveloppe_PSK));
       bruit =(1/sqrt(2))*( bruitI + 1i*bruitQ);
       x_sortie_bruit_PSK=Enveloppe_PSK+bruit;

       %Demodulation de base :
       z_bruit=filter(h_PSK,1,[x_sortie_bruit_PSK zeros(1,N0_PSK)]);
       z_bruit=z_bruit(N0_PSK+1:end);

       %Echantillonnage:
       zm_bruit_PSK=z_bruit(1:Ns_PSK:end);

       %Decision :
       bits_decides_bruit_PSK = pskdemod(zm_bruit_PSK,M_PSK,pi/M_PSK,'gray');
       bits_decides_bruit_PSK = de2bi(bits_decides_bruit_PSK.');
       bits_sortie_bruit_PSK = bits_decides_bruit_PSK(:)';
       
      %Calcul du TEB :
       TEB_bruit_PSK(i) = length(find(bits~=bits_sortie_bruit_PSK))/nb_bits;
   end

    figure;semilogy(Eb_n0, TEB_bruit_PSK,'r-o');
    xlabel('Eb/N0(dB)');
    ylabel('TEB PSK');
    title("TEB en fonction du rapport signal sur bruit");
    figure;semilogy(Eb_n0, TEB_bruit_PSK,'g-o');
    xlabel('Eb/N0(dB)');
    ylabel('TEB PSK');
    title("comparaison entre TEB PSK simulé et théorique");
    hold on;
    rsb_dec=10.^(Eb_n0/10);
    TEB_theorique_PSK=qfunc(sqrt(2*rsb_dec)); 
    semilogy(Eb_n0, TEB_theorique_PSK,'b-*');
    legend('TEB PSK simulé','TEB PSK théorique');
 

 % Comparaison en terme d'efficacité en puissance 
 figure;
 semilogy(Eb_n0,TEB_pb,'b-*');
 xlabel('Eb/N0(dB)');
 ylabel('TEB');
 hold on;
 semilogy(Eb_n0, TEB_bruit_PSK,'r-o');
 legend('TEB_DVB-S2','TEB_DVB-S')