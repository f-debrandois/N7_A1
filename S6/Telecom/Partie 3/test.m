% Télécommunication Séquence 1 : projet
% auteurs : Gonthier Priscilia et JMAL Yessine
% Groupe : 1SN-M

clear;
close all;

%# Données du problème :
Fe = 24000; % Fréquene d'échantillonnage
Rb = 3000; % Débit binaire
Te = 1/Fe; % Période d'échantillonnage
Tb = 1/Rb; % Période binaire
alpha0 = 1;
alpha1 = 0.5;

%# Information binaire à transmettre :
% nb_bits = 1000; % Nombre de bits générés
% bits = randi([0,1],1,nb_bits); % Message de nb_bits bits
bits = [0 1 1 0 0 1];
nb_bits = 6;
%% Modulation en bande de base 1 :
%## Données spécifiques à la modulation en bande de base 1 :
M1 = 2; % Ordre de modulation
l1 = log2(M1); % Nombre de bits codants par symbole
Ts1 = l1 * Tb; % Période symbole
Rs1 = 1/Ts1; % Débit symbole
Ns1 = Ts1 / Te; % Nombre de bit par symbole(facteur de suréchantillonage)
long1 = nb_bits * Ns1 / l1; % Longueur du signal
T1 = long1 * Te; % Durée du signal

%## Mapping binaire à moyenne nulle : 0->-1, 1->1
Symboles1 = 2*bits-1;

%## Suréchantillonnage :
Suite_diracs1 = kron(Symboles1, [1 zeros(1,Ns1-1)]); % Suite de Diracs pondérés par les symboles

%## Filtrage de mise en forme :
h1 = ones(1,Ns1); % Réponse impulsionnelle du filtre (rectangulaire de durée Ts1)
x1 = filter(h1,1,Suite_diracs1); % Signal transmis

%%%sans canal
%# Implantation du démodulateur
h_r =  fliplr(h1); % Réponse impulsionnelle du filtre de réception (rectangulaire de durée Ts)
z = filter(h_r,1,x1);

z_bis = reshape(z,Ns1,length(z)/Ns1);
figure("Name", "Diagramme de l'oeil");
plot(z_bis(:,2:end));% à partir de 2 pour éviter de voir le premier symbole émis
xlabel("Indice");
ylabel("z (v)");
title("Diagramme de l'oeil en sortie du filtre de réception sans canal");
grid on;

%%% on ne peut pas respecter le critère de Nyquist 
n0 = Ns1;
%# 7. Echantillonnage du signal en sortie de filtre de réception
z_echant =z(n0:Ns1:end);% z(t0 + mTs) m€N
BitsRecuperes=(sign(z_echant)+1)/2; % Demapping
erreur = abs(bits-BitsRecuperes); % Vecteur de la même taille que l'information binaire, contenant des 0 si pas d'erreur et des 1 sinon
TEB = mean(erreur); % Taux d'erreur binaire, TEB = nombre de bits reçus erronés / nombre de bits transmis


%## canal 
hc = [alpha0 zeros(1,Ns1-1) alpha1 zeros(1,Ns1-1)];
r = filter(hc,1,x1);


%# Implantation du démodulateur
h_r =  fliplr(h1); % Réponse impulsionnelle du filtre de réception (rectangulaire de durée Ts)
z = filter(h_r,1,r); % Filtrage de réception

g1 = conv(h1,hc);
g = conv(g1,h_r);
figure("Name", "reponse globale");
plot(g);
xlabel("Indice");
ylabel("g (v)");
title("Réponse impulsionnelle globale de la chaine de transmission");
grid on;

figure("Name", "signal");
plot(z);
xlabel("temps(s)");
ylabel("x(v)");
title("Signal en sortie du filtre de réception");
grid on;

z_bis = reshape(z,Ns1,length(z)/Ns1);
figure("Name", "Diagramme de l'oeil");
plot(z_bis(:,2:end));% à partir de 2 pour éviter de voir le premier symbole émis
xlabel("Indice");
ylabel("z (v)");
title("Diagramme de l'oeil en sortie du filtre de réception avec canal");
grid on;

%%% on ne peut pas respecter le critère de Nyquist 
n0 = Ns1;
%# 7. Echantillonnage du signal en sortie de filtre de réception
z_echant =z(n0:Ns1:end);% z(t0 + mTs) m€N
BitsRecuperes=(sign(z_echant)+1)/2; % Demapping
erreur = abs(bits-BitsRecuperes); % Vecteur de la même taille que l'information binaire, contenant des 0 si pas d'erreur et des 1 sinon
TEB2 = mean(erreur); % Taux d'erreur binaire, TEB = nombre de bits reçus erronés / nombre de bits transmis


SNRdb = linspace(0,10,16);
TEB = zeros(1,length(SNRdb));
SNR = 10 .^ (SNRdb / 10);
TEB_th = zeros(1,length(SNRdb));
TEB_moy = zeros(1,100);
TEB_sans = zeros(1,length(SNRdb));
TEB_moy_sans = zeros(1,100);

%## Tracé du TEB en fonction du SNR
for i = 1 : length(SNRdb)
    rapport = SNR(i);
    Px = mean(abs(x1).^2);
    sigmacarre = (Px * Ns1)/(2 * log2(M1) * rapport);
    for j = 1 : 100  % on ajoute cette boucle for pour generer plus de points. 
        bruit = sqrt(sigmacarre) * randn(1, length(r));
        r_bruit = r + bruit;
    
        z_bruit=filter(h_r,1,r_bruit);
        n0 = Ns1 ;
        z_echant_bruit = z_bruit(n0:Ns1:end);
        BitsRecuperes_bruit = (sign(z_echant_bruit)+1)/2; 
        erreur_bruit = abs(bits-BitsRecuperes_bruit); 
        TEB_moy(j) = mean(erreur_bruit);

        x1_bruit = x1 + bruit;
        z_bruit_sans=filter(h_r,1,x1_bruit);
        n0 = Ns1 ;
        z_echant_sans = z_bruit_sans(n0:Ns1:end);
        BitsRecuperes_sans = (sign(z_echant_sans)+1)/2; 
        erreur_sans = abs(bits-BitsRecuperes_sans); 
        TEB_moy_sans(j) = mean(erreur_sans);
    end 
    TEB(i) = mean(TEB_moy);
    TEB_sans(i) = mean(TEB_moy_sans);
    %TEB_th(i) = 2 * ((M-1)/(M * log2(M))) * (1-normcdf(sqrt(2 * rapport)));
end
TEB_th = 0.5 * qfunc(sqrt(0.5*(10.^(SNRdb./10)))) + 0.5 * qfunc(sqrt(4.5*(10.^(SNRdb./10))));
figure("Name", "teb en fonction de SNR");
semilogy(SNRdb,TEB);
grid on;
hold on 
semilogy(SNRdb,TEB_th);
grid on;
leg = legend('TEB',...
      'TEBth',..., 
    'location', 'NorthWest');

figure("Name", "TEB en fonction de SNR");
semilogy(SNRdb,TEB);
grid on;
hold on 
semilogy(SNRdb,TEB_sans);
grid on;
leg = legend('TEB',...
      'TEB sans',..., 
    'location', 'NorthWest');

figure()
plot(z_echant(1,2:end), zeros(1, nb_bits-1),'*');
title('Constellation obtenue en réception')
xlabel("Indice");
ylabel("(v)");
grid on;
Y0 = zeros(nb_bits+1,1);
Y0(1) = 1;
Z = toeplitz([alpha0 alpha1 zeros(1,nb_bits-1)] ,[alpha0 zeros(1,nb_bits)]);
C = Z\Y0;
% Y0 = [1 zeros(1,nb_bits-1)];
% Z = toeplitz(z_echant);
% C = inv(Z'*Z)*Z'*Y0';
SignalRecuEchEgal = filter(C, 1, z_echant);
BitsRecuperes = (sign(SignalRecuEchEgal)+1)/2; 
erreur = abs(bits-BitsRecuperes); 
TEB2 = mean(erreur);
figure()
plot(SignalRecuEchEgal(1,2:end), zeros(1, nb_bits-1),'*');
title('Constellation apres l''égaliseur 1 ')
xlabel("Indice");
ylabel("(v)");
grid on;
z4=[alpha0 alpha1 zeros(1,nb_bits-1)] ,[alpha0 zeros(1,nb_bits)]
auto = xcorr(z4,z4);
R = toeplitz(auto);
inter = xcorr(z4,Symboles1);
C2 = R\inter';
SignalRecuEchEgal = real(filter(C2, 1, z_echant));
BitsRecuperes = (sign(SignalRecuEchEgal)+1)/2; 
erreur = abs(bits-BitsRecuperes); 
TEB3 = mean(erreur);
figure()
plot(SignalRecuEchEgal(1,2:end), zeros(1, nb_bits-1),'*');
title('Constellation +egal2')
%Réponse impulsionnelle de la chaine de transmission sans égalisateur :
g1 = conv(hc,conv(h1,h_r));
figure();
plot(g1);
title("Réponse impulsionnelle de la chaine de transmission sans égalisateur");
xlabel("Indice");
ylabel("g(v)");
grid on;
g2 = conv(g1,C);
figure();
plot(g2);
title("Réponse impulsionnelle de la chaine de transmission avec égalisateur");
xlabel("Indice");
ylabel("g(v)");
grid on;
g3 = conv(g1,C2);
figure();
plot(g3);
title("Réponse impulsionnelle de la chaine de transmission avec égalisateur 2");
xlabel("Indice");
ylabel("g(v)");
grid on;
%%canal + bruit
SNR= 0.01;

Px = mean(abs(x1).^2);
sigmacarre = (Px * Ns1)/(2 * log2(M1) * SNR);
bruit = sqrt(sigmacarre) * randn(1, length(r));
r_bruit = r + bruit;
z_bruit=filter(h_r,1,r_bruit);
n0 = Ns1 ;
z_echant = z_bruit(n0:Ns1:end);
BitsRecuperes = (sign(z_echant)+1)/2; 
erreur = abs(bits-BitsRecuperes); 
TEB4 = mean(erreur);

SignalRecuEchEgal = real(filter(C, 1, z_echant));
BitsRecuperes = (sign(SignalRecuEchEgal)+1)/2; 
erreur = abs(bits-BitsRecuperes); 
TEB5 = mean(erreur);
SignalRecuEchEgal = real(filter(C2, 1, z_echant));
BitsRecuperes = (sign(SignalRecuEchEgal)+1)/2; 
erreur = abs(bits-BitsRecuperes); 
TEB6 = mean(erreur);
% 
%Réponses en fréquence :
F = ((0:500-1)/500 - 0.5)*Fe;
repCanal = fft(hc,500);
repEgalisateur = fft(C,500);
repEgalisateur2 = fft(C2,500);
repProd = repCanal.*repEgalisateur;
repProd2 = repCanal.*repEgalisateur2;
figure();

subplot(3,1,1)
plot(F,fftshift(repCanal));
title("Réponse en fréquence du filtre canal");
xlabel("frequence(Hz)");
ylabel("H");
grid on;
subplot(3,1,2)
plot(F,fftshift(repEgalisateur));
title("Réponse en fréquence de l'égalisateur");
xlabel("frequence(Hz)");
ylabel("H");
grid on;
subplot(3,1,3)
plot(F,fftshift(repProd));
title("Produit des réponses en fréquence");
xlabel("frequence(Hz)");
ylabel("H");
grid on;

figure();
subplot(3,1,1)
plot(F,fftshift(repCanal));
title("Réponse en fréquence du filtre canal");
xlabel("frequence(Hz)");
ylabel("H");
grid on;
subplot(3,1,2)
plot(F,fftshift(repEgalisateur2));
title("Réponse en fréquence de l'égalisateur");
xlabel("frequence(Hz)");
ylabel("H");
grid on;
subplot(3,1,3)
plot(F,fftshift(repProd2));
title("Produit des réponses en fréquence");
xlabel("frequence(Hz)");
ylabel("H");
grid on;

SNRdb = linspace(0,10,16);

SNR = 10 .^ (SNRdb / 10);
TEB_avec = zeros(1,length(SNRdb));
TEB_moy = zeros(1,100);
TEB_sans_bruit = zeros(1,length(SNRdb));
TEB_moy_sans_bruit = zeros(1,100);
%## Tracé du TEB en fonction du SNR
for i = 1 : length(SNRdb)
    rapport = SNR(i);
    Px = mean(abs(x1).^2);
    sigmacarre = (Px * Ns1)/(2 * log2(M1) * rapport);
    for j = 1 : 100  % on ajoute cette boucle for pour generer plus de points. 
        bruit = sqrt(sigmacarre) * randn(1, length(r));
        r_bruit = r + bruit;
    
        z_bruit=filter(h_r,1,r_bruit);
        n0 = Ns1 ;
        z_echant_bruit = z_bruit(n0:Ns1:end);
        SignalRecuEchEgal = real(filter(C, 1, z_echant_bruit));
        BitsRecuperes = (sign(SignalRecuEchEgal)+1)/2; 
        erreur = abs(bits-BitsRecuperes); 
        BitsRecuperes2 = (sign(z_echant_bruit)+1)/2; 
        erreur2 = abs(bits-BitsRecuperes2);
        TEB_moy(j) = mean(erreur);
        TEB_moy_sans_bruit(j) = mean(erreur2);

         
       
    end 
    TEB_avec(i) = mean(TEB_moy);
    TEB_sans_bruit(i) = mean (TEB_moy_sans_bruit);
end
figure("Name", "teb en fonction de SNR");
semilogy(SNRdb,TEB_avec);
grid on;
hold on 
semilogy(SNRdb,TEB_sans_bruit);
grid on;
leg = legend('TEB avec egaliseur',...
      'TEB sans egaliseur',..., 
    'location', 'NorthWest');