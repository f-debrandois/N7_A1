% ------------------------------------------------------------------------
% Telecommunications : Etudes de chaines de transmission en bande de base                %
% Auteur : Titah Anas 
% ------------------------------------------------------------------------

clear all, close all

%% Initialisation

%Durée symbole en nombre d’échantillons (Ts=NsTe)
Ns=8; 
%Nombre de bits générés
nb_bits=1000;
%La valeur t0
t0 = Ns;
%Rapport signal à bruit par bit à l'entrée du récepteur, de 0 à 6
Eb_N0_dB = [0 : 6];
%Fonction Dirac
dirac = [1 zeros(1,Ns-1)];

%% 2.2) Chaine en référence

%Le filtre de mise en forme
h = ones(1,Ns);
%Le filtre de réception
hr = h;

%----------------------------- Question 1 -----------------------------%

%Génération de l’information binaire
bits=randi([0,1],1,nb_bits);
%Mapping binaire à  moyenne nulle: 0->-1, 1->1
Symboles=2*bits-1; 
%Génération de la suite de Dirac spondérés par les symboles (suréchantillonnage)
Suite_diracs=kron(Symboles, dirac); 

%Le signal transmis
figure(1),
x=filter(h,1,Suite_diracs);
plot(x)
title("Le signal transmis")
axis([0 150 -2 2])

%DSP du signal transmis
figure(2),
N_sup = 2^nextpow2(length(x)); 
dsp_x = 1/length(x) * abs(fft(x,N_sup)).^2;
plot(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_x));
title("La densité spectrale de puissance du signal transmis")
xlabel("Fréquence normalisée")
ylabel("Densité spectrale de puissance")

%----------------------------------------------------------------------%

%----------------------------- Question 2 -----------------------------%

% (a) Le signal en sortie du filtre de réception
figure(3),
signal_filtre = filter(hr,1,x);
plot(signal_filtre)
axis([0 150 -10 10])
title("Le signal en sortie du filtre de réception")
ylabel("Le signal en sortie du filtre de réception")

% (b) Diagramme de l'oeil en sortie du filtre de réception.
figure(4),
diag_oeil = reshape(signal_filtre,2*Ns,length(x)/(2*Ns));
plot(diag_oeil)
title("Diagramme de l'oeil en sortie du filtre de réception")
xlabel("Temps en seconde")
ylabel("Diagramme de l'oeil")

% (c) TEB Obtenu.
s_ech = signal_filtre(t0:Ns:end);
symb_est = sign(s_ech);
bits_est = (symb_est+1)/2;
nb_erreurs =  length(find(bits_est ~= bits));
TEB_obtenu = nb_erreurs/length(bits);
fprintf("2. (c) Le TEB obtenu est %f \n",TEB_obtenu);

%----------------------------------------------------------------------%

%----------------------------- Question 3 -----------------------------%

figure(5),
for i = 1 : length(Eb_N0_dB)
        %Calcul de la puissance
        sigma2 = mean(x.^2)*Ns/(2*10^(Eb_N0_dB(i)/10));

        %Génération et ajout du bruit
        b = sqrt(sigma2)*randn(1,Ns*nb_bits);
        r = x + b;

        %Génération du signal en sortie du filtre de réception
        signal_filtre = filter(hr,1,r);

        s_ech = signal_filtre(t0:Ns:end);

        symb_est = sign(s_ech);

        bits_est = (symb_est+1)/2;
        
        nb_erreurs = length(find(bits_est ~= bits));
        
        
        TEB(i) = nb_erreurs/nb_bits;

end;
semilogy(Eb_N0_dB,TEB)
title("Taux d'erreur binaire obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%----------------------------- Question 4 -----------------------------%
figure(6),
TEB_th = 1 - normcdf(sqrt(2*10.^(Eb_N0_dB/10)));
semilogy(Eb_N0_dB,TEB); hold on;
semilogy(Eb_N0_dB,TEB_th,'r')
title("Comparaison entre le TEB simulé et TEB théorique")
legend("TEB simulé","TEB théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%% 3.2 ) Impact du choix du filtre de réception

%Le filtre de mise en forme
h = ones(1,Ns);
%Le filtre de réception
hr  = zeros(1,Ns);
hr(1:Ns/2) = ones(1,Ns/2);

%----------------------------- Question 1 -----------------------------%

% (a) Le signal en sortie du filtre de réception
figure(7),
signal_filtre_2 = filter(hr,1,x);
plot(signal_filtre_2)
axis([0 200 -6 6])
title("Le signal en sortie du filtre de réception")
ylabel("Le signal en sortie du filtre de réception")

% (b) Diagramme de l'oeil en sortie du filtre de réception.
figure(8),
diag_oeil = reshape(signal_filtre_2,2*Ns,length(x)/(2*Ns));
plot(diag_oeil)
title("Diagramme de l'oeil en sortie du filtre de réception")
xlabel("Temps en seconde")
ylabel("Diagramme de l'oeil")

% (c) TEB Obtenu.
s_ech = signal_filtre_2(t0:Ns:end);
symb_est = sign(s_ech);
bits_est = (symb_est+1)/2;
nb_erreurs =  length(find(bits_est ~= bits));
TEB_obtenu = nb_erreurs/length(bits);
fprintf("3.2.1 (c) Le TEB obtenu est %f \n",TEB_obtenu);

%----------------------------------------------------------------------%

%----------------------------- Question 2 -----------------------------%

figure(9),
for i = 1 : length(Eb_N0_dB)
        %Calcul de la puissance
        sigma2 = mean(x.^2)*Ns/(2*10^(Eb_N0_dB(i)/10));
        %Génération et ajout du bruit
        b = sqrt(sigma2)*randn(1,Ns*nb_bits);
        r = x + b;

        %Génération du signal en sortie du filtre de réception
        signal_filtre = filter(hr,1,r);

        s_ech = signal_filtre(t0:Ns:end);

        symb_est = sign(s_ech);

        bits_est = (symb_est+1)/2;
        
        nb_erreurs = length(find(bits_est ~= bits));
                
        TEB_2(i) = nb_erreurs/nb_bits;

end;
semilogy(Eb_N0_dB,TEB_2)
title("Taux d'erreur binaire obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%----------------------------- Question 3 -----------------------------%

figure(10);hold on

TEB_th = 1 - normcdf(sqrt(2*10.^(Eb_N0_dB/10)));
semilogy(Eb_N0_dB,TEB_2)
semilogy(Eb_N0_dB,TEB_th,'r')
title("Comparaison entre le TEB simulé et TEB théorique")
legend("TEB simulé","TEB théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%----------------------------- Question 4 -----------------------------%

figure(11);hold on

semilogy(Eb_N0_dB,TEB_2)
semilogy(Eb_N0_dB,TEB,'r')
title("Comparaison entre le TEB de la première chaine et la deuxième")
legend("TEB de la deuxième chaine","TEB de la première chaine")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%----------------------------- Question 5 -----------------------------%

figure(12);hold on
dsp_1 = 1/length(x) * abs(fft(x,N_sup)).^2;
dsp_2 = 1/length(x) * abs(fft(x,N_sup)).^2;
plot(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_1));
plot(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_2),'r');
title("Comparaison entre la DSP du signal transmis de la première chaine et la deuxième")
legend("DSP de la première chaine","DSP de la deuxième chaine")
xlabel("Fréquence normalisée")
ylabel("DSP")

%----------------------------------------------------------------------%

%% 4.2 ) impact du choix du filtre de mise en forme et d'un canal de propagation à bande limitée

%Fréquence d'échantillonnage
Fe = 12000;

%Roll off
alpha = 1/2;

%SPAN 
span = 4;

%Rythm symbole 
Rs = 3000;

%Filtre de mise en forme
h = rcosdesign(alpha,span,Ns);

%Filtre de réception
hr = h;

%----------------------------- Question 2 -----------------------------%

% 2. (b) Le signal en sortie du filtre de réception.
    %Génération de la suite de Dirac spondérés par les symbols (suréchantillonnage)
    Suite_diracs_2 = kron(Symboles,dirac);
    
    %Filtrage 
    x_2 = filter(h,1,[Suite_diracs_2 zeros(1,span*Ns/2)]);
    x_2 = x_2(span*Ns/2 +1:end);
    
    %Affichage du signal en sortie du filtre de réception.
    figure(13),
    signal_filtre_3 = filter(hr,1,[x_2 zeros(1,span*Ns/2)]);
    signal_filtre_3 = signal_filtre_3(span*Ns/2 +1:end);
    plot(signal_filtre_3);
    axis([0 200 -2 2])
    title("Le signal en sortie du filtre de réception")
    
% 2. (c) Diagramme de l'oeil en sortie du filtre de réception.
    figure(14),
    diag_oeil = reshape(signal_filtre_3,2*Ns,length(x)/(2*Ns));
    plot(diag_oeil)
    title("Diagramme de l'oeil en sortie du filtre de réception")
    xlabel("Temps en seconde")
    ylabel("Diagramme de l'oeil")
    
% 2. (d) TEB obtenu.
    s_ech = signal_filtre_3(1:Ns:end);
    symb_est = sign(s_ech);
    bits_est = (symb_est+1)/2;
    nb_erreurs =  length(find(bits_est ~= bits));
    TEB_obtenu = nb_erreurs/length(bits);
    fprintf("4.2. (d) Le TEB obtenu est %f \n",TEB_obtenu);
%----------------------------------------------------------------------%

    
%----------------------------- Question 3 -----------------------------%

figure(15),
for i = 1 : length(Eb_N0_dB)
        %Calcul de la puissance
        sigma2 = mean(x_2.^2)*Ns/(2*10^(Eb_N0_dB(i)/10));
        %Génération et ajout du bruit
        b = sqrt(sigma2)*randn(1,Ns*nb_bits);
        r = x_2 + b;

        %Génération du signal en sortie du filtre de réception
        r_filtre = filter(hr,1,[r zeros(1,span*Ns/2)]);
        r_filtre = r_filtre(span*Ns/2 +1:end);
        
        s_ech = r_filtre(1:Ns:end);

        symb_est = sign(s_ech);

        bits_est = (symb_est+1)/2;
        
        nb_erreurs = length(find(bits_est ~= bits));
                
        TEB_3(i) = nb_erreurs/nb_bits;


end;
semilogy(Eb_N0_dB,TEB_3)
title("Taux d'erreur binaire obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%


%----------------------------- Question 4 -----------------------------%

figure(16);hold on;

TEB_th = 1 - normcdf(sqrt(2*10.^(Eb_N0_dB/10)));
semilogy(Eb_N0_dB,TEB_3);
semilogy(Eb_N0_dB,TEB_th,'r')
title("Comparaison entre le TEB simulé et TEB théorique")
legend("TEB simulé","TEB théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%----------------------------- Question 5 -----------------------------%

figure(17);hold on

semilogy(Eb_N0_dB,TEB_3)
semilogy(Eb_N0_dB,TEB,'r')
title("Comparaison entre le TEB de la première chaine et la troisième")
legend("TEB de la troisième chaine","TEB de la première chaine")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%----------------------------- Question 6 -----------------------------%

figure(18);hold on
dsp_1 = 1/length(x) * abs(fft(x,N_sup)).^2;
dsp_2 = 1/length(x_2) * abs(fft(x_2,N_sup)).^2;
plot(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_1));
plot(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_2),'r');
title("Comparaison entre la DSP du signal transmis de la première chaine et la troisième")
legend("DSP de la première chaine","DSP de la troisième chaine")
xlabel("Fréquence normalisée")
ylabel("DSP")

%----------------------------------------------------------------------%

%----------------------------- Question 7 -----------------------------%

%Filtre passe-bas d'ordre 61
%BW = 1500 Hz%
figure(19);
F0 = 1500/2;
N_61 = 30;
Morceau_61 = -N_61*1/Fe:1/Fe:N_61*1/Fe;
Y_61 = 2*(F0/Fe)*sinc(2*F0*Morceau_61);
signal_canal=filter(Y_61,1,x_2);
signal_filtre_canal = filter(hr,1,[signal_canal zeros(1,span*Ns/2)]);
signal_filtre_canal = signal_filtre_canal(span*Ns/2 +1:end);
diag_oeil = reshape(signal_filtre_canal,2*Ns,length(signal_filtre)/(2*Ns));
plot(diag_oeil)
title("Diagramme de l'oeil en sortie du filtre de réception avec BW = 1500 Hz")
xlabel("Temps en seconde")
ylabel("Diagramme de l'oeil")
%BW = 3000 Hz%
figure(20);
F0= 3000/2;
Y_61 = 2*(F0/Fe)*sinc(2*F0*Morceau_61);
signal_canal=filter(Y_61,1,x_2);
signal_filtre_canal = filter(hr,1,[signal_canal zeros(1,span*Ns/2)]);
signal_filtre_canal = signal_filtre_canal(span*Ns/2 +1:end);
diag_oeil = reshape(signal_filtre_canal,2*Ns,length(signal_filtre)/(2*Ns));
plot(diag_oeil)
title("Diagramme de l'oeil en sortie du filtre de réception avec BW = 3000 Hz")
xlabel("Temps en seconde")
ylabel("Diagramme de l'oeil")

%----------------------------------------------------------------------%

%% 5.2 ) Impact du choix de mapping

%Filtre de mise en forme.
h = ones(1,Ns);
%Filtre de réception
hr = h;

%----------------------------- Question 1 -----------------------------%

%1. (a) Signal en sortie du filtre d'émission

    %Mapping
    Symboles_2 =(2*bi2de(reshape(bits, 2,length(bits)/2).') - 3).';
    
    %Génération de la suite de Dirac spondérés par les symbols (suréchantillonnage)
    Suite_diracs_3 = kron(Symboles_2,[1 zeros(1,Ns-1)]);
    
    %Filtrage
    x_3 = filter(h,1,Suite_diracs_3);
    
    %Affichage du signal en sortie du filtre d'émission
    figure(21);
    plot(x_3)
    axis([1 200 -5 5])
    title("Le signal en sortie du filtre d'émission")

    %DSP du signal en sortie du filtre d'émission
    figure(22),
    N_sup_2 = 2^nextpow2(length(x_3)); 
    dsp_x_3 = 1/length(x_3) * abs(fft(x_3,N_sup_2)).^2;
    plot(linspace(-1/Ns,1/Ns,N_sup_2),fftshift(dsp_x_3));
    title("La densité spectrale de puissance du signal en sortie du filtre d'émission")
    xlabel("Frésquence normalisée")
    ylabel("Densité spectrale de puissance")



%1. (b) Comparaison des DSP des signaux transmis de la quatrième chaine et
%la permière

figure(23);hold on
plot(linspace(-1/Ns,1/Ns,N_sup),fftshift(dsp_1));
plot(linspace(-1/Ns,1/Ns,N_sup_2),fftshift(dsp_x_3),'r');
title("Comparaison entre la DSP du signal transmis de la première chaine et la quatrième")
legend("DSP de la première chaine","DSP de la quatrième chaine")
xlabel("Fréquence normalisée")
ylabel("DSP")

%1. (c)  Diagramme de l'oeil en sortie du filtre de réception
figure(24);
signal_filtre_4 = filter(hr,1,x_3);
diag_oeil = reshape(signal_filtre_4,Ns,length(x)/(2*Ns));
plot(diag_oeil)
title("Diagramme de l'oeil en sortie du filtre de réception")
xlabel("Temps en seconde")
ylabel("Diagramme de l'oeil")


%1. (d) TEB Obtenu
    s_ech = signal_filtre_4(t0:Ns:end);
    symb_est = zeros(1,length(s_ech));
    for i=1:length(s_ech)
        if (s_ech(i)>2*Ns)
            symb_est(i) = 3;
        elseif (s_ech(i) >= 0)
            symb_est(i) = 1;
        elseif (s_ech(i) < -2*Ns)
            symb_est(i) = -3;
        else
            symb_est(i) = -1;
        end
    end
    bits_est = reshape(de2bi((symb_est+3)/2).',1,nb_bits);
    nb_erreurs =  length(find(bits_est ~= bits));
    TEB_obtenu = nb_erreurs/length(bits);
    fprintf("5.2.1 (d) Le TEB obtenu est %f \n",TEB_obtenu);
%----------------------------------------------------------------------%


    
%----------------------------- Question 2 -----------------------------%
figure(25),
for j = 1 : length(Eb_N0_dB)
        %Calcul de la puissance
        sigma2 = mean(x_3.^2)*Ns/(4*10^(Eb_N0_dB(j)/10));
        %Génération et ajout du bruit
        b = sqrt(sigma2)*randn(1,length(x_3));
        r = x_3 + b;

        %Génération du signal en sortie du filtre de réception
        r_filtre = filter(hr,1,r);
        
        s_ech = r_filtre(t0:Ns:end);

        symb_est = zeros(1,length(s_ech));
        for i=1:length(s_ech)
            if (s_ech(i)>2*Ns)
                symb_est(i) = 3;
            elseif (s_ech(i) >= 0)
                symb_est(i) = 1;
            elseif (s_ech(i) < -2*Ns)
                symb_est(i) = -3;
            else
                symb_est(i) = -1;
            end
        end
    nb_erreurs =  length(find(Symboles_2 ~= symb_est));
    
    TES_4(j) = nb_erreurs/length(Symboles_2);


end;
semilogy(Eb_N0_dB,TES_4)
title("Taux d'erreur symbolique obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TES")

%----------------------------------------------------------------------%


%----------------------------- Question 3 -----------------------------%

figure(26);hold on;
TES_th_2 = 3/2 * qfunc(sqrt(4/5*10.^(Eb_N0_dB/10)));
semilogy(Eb_N0_dB,TES_4);
semilogy(Eb_N0_dB,TES_th_2,'r')
title("Comparaison entre le TES simulé et TES théorique")
legend("TES simulé","TES théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TES")

%----------------------------------------------------------------------%

%----------------------------- Question 4 -----------------------------%
figure(27),
TEB_4 = TES_4/2
semilogy(Eb_N0_dB,TEB_4)
title("Taux d'erreur binaire obtenu")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")

%----------------------------------------------------------------------%

%----------------------------- Question 5 -----------------------------%

figure(28);hold on;

TEB_th_2 = 3/4 * qfunc(sqrt(4/5*10.^(Eb_N0_dB/10)));
semilogy(Eb_N0_dB,TEB_4);
semilogy(Eb_N0_dB,TEB_th_2,'r')
title("Comparaison entre le TEB simulé et TEB théorique")
legend("TEB simulé","TEB théorique")
xlabel("Eb/N0 (en dB)")
ylabel("TEB")
%----------------------------------------------------------------------%