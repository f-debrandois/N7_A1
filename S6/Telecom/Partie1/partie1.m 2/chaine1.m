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
Ts=Tb;
Ns=Fe*Ts;
h=ones(1,Ns);
hr=h;
% 1. Sans bruit
 
    % Mapping
An = (2*bits - 1)';
Signal_1 = kron(An, [1, zeros(1, Ns-1)]);
    %filtre de mis en forme rectangulaire
signal_emis=filter(h,1,Signal_1);    
     % Filtre de réception
Signal_1_recu = filter(hr,1,signal_emis);  
      %Tracé de diagramme de l'oeil
oeil = reshape(Signal_1_recu,Ns,length(Signal_1_recu)/Ns);
figure;
plot(oeil);
title('diagramme de l oeil');
xlabel('temps en s');

%echantillonnage du signal  T=Ts
signal_echantillonne=Signal_1_recu(Ns:Ns:end);  
%Detecteur de seuil
symboles_decides=sign(signal_echantillonne);
bits_decides=(symboles_decides+1)/2;
TEB=length(find(bits_decides~=bits))/length(bits);

% 2. Avec bruit
%rapport signal  bruit par bit à l'entrée du récepteur en décibels
Eb_N0_db=10;  
%rapport linéaire signal  bruit par bit à l'entrée du récepteur
Eb_N0=10^(Eb_N0_db/10);
%Puissance du signal modulé =E([x|.^2)
Px=mean(abs(signal_emis).^2); 
%Puissance du signal reçu
Pr=Px;  
%la puissance du bruit en sortie du filtre de réception
sigma_n_carre=(Pr*Ns)/(2*Eb_N0);
%génération du signal bruit AWGN
bruit=sqrt(sigma_n_carre)*randn(1,length(signal_emis));
%signal généré avec bruit
signal_emis_1=signal_emis+bruit;
%signal reçu à la sortie du filtre de réception
signal_recu_1=filter(hr,1,signal_emis_1);

%tableau contenant les différentes valeures de TEB estimées
Tableau_TEB=zeros(1,7);
%tableau contenant les différentes valeures de TEB en fonction de Eb_N0_db
Tab_Eb = [0,1,2,3,4,5,6];
%valeurs de Eb_N0_db en décibels
for Eb_N0_db=0:6
    %valeur linéaire de Eb_N0
    Eb_N0_lineaire=10^(Eb_N0_db/10); 
    %Puissance du signal modulé =E([x|.^2)
    Px_0=mean(abs(signal_emis).^2);    
    Pr_0=Px_0; 
    %la puissance du bruit en sortie du filtre de réception
    sigma_n_carre_0=(Pr_0*Ns)/(2*Eb_N0_lineaire);
    %Génération du bruit 
    bruit=sqrt(sigma_n_carre_0)*randn(1,length(signal_emis));
    %signal généré avec bruit
    signal_bruite=signal_emis+bruit;
    %signal reçu à la sortie du filtre de réception
    signal_recu_2=filter(hr,1,signal_bruite);
    %Echantillonnage en N_s
    signal_echantillonne=signal_recu_2(Ns:Ns:end);   
    %Détecteur de seuil
    symboles_decides=sign(signal_echantillonne);
    bits_decides=(symboles_decides+1)/2;
    TEB_bruit=length(find(bits_decides~=bits));
    Tableau_TEB(1,Eb_N0_db+1)=TEB_bruit/length(bits);
end
figure;
semilogy(Tab_Eb,Tableau_TEB,'r-o');
xlabel('E_b/N_0 en décibels');
ylabel('TEB');
title('le taux d erreur binaire');

%tableau contenant les différentes valeures de TEB théoriques
Teb_theorique = qfunc(sqrt(2*(10.^(Tab_Eb/10)))); 
%tracé le taux d'erreur binaire obtenu en fonction du rapport signal du bruit par bit à l'entrée du récepteur (Eb/N0) en d�cibels.
figure;
semilogy(Tab_Eb,Tableau_TEB,'r-o');
hold on;
semilogy(Tab_Eb,Teb_theorique,'b-*');
hold off;
legend('Teb simulé','Teb theorique');
xlabel('E_b/N_0 en décibels');
ylabel('TEB');
title('le taux d erreur binaire');

