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
%Sans bruit
%Mapping
LUT = [-3, -1, 3, 1];
An = LUT(1+bi2de(reshape(bits, n_bits/2, 2), 'left-msb'));
At = kron(An, [1, zeros(1, Ns-1)]);
%filtre de mis en forme
signal_emis = filter(h, 1, At);
%filtre de reception
Signal_3_recu=filter(h,1,signal_emis)';
%diagramme de l'oeil en sortie de filtre de reception
diagramme_oeil = reshape(Signal_3_recu, Ns, length(Signal_3_recu) / Ns);
figure;
plot(diagramme_oeil);
title(" Diagramme de l'oeil sans bruit")
%Taux d'erreur binaire
%Echantillonnage en N_s
signal_echantillonne = Signal_3_recu(Ns:Ns:end); 
%détecteur de seuil
symboles_decides = zeros(1,length(signal_echantillonne));
for i=1:length(signal_echantillonne)
    if (signal_echantillonne(i) >= 0)
        if (signal_echantillonne(i) <= 2*Ns)
            symboles_decides(i) = 1;
        elseif (signal_echantillonne(i) > 2*Ns)
            symboles_decides(i) = 3;
        end
    elseif (signal_echantillonne(i) < 0)
        if ( -2*Ns <= signal_echantillonne(i))
            symboles_decides(i) = -1;
        elseif (signal_echantillonne(i) < -2*Ns)
            symboles_decides(i) = -3;
        end
    end
end
bits_decides = reshape(de2bi((symboles_decides + 3)/2).',1,length(bits));
TEB = sum(bits_decides' ~= bits) / n_bits;

%%
%Ajout du bruit
%tableau contenant les différentes valeures de TES estim�es
Tableau_TES=zeros(1,7); 
%tableau contenant les différentes valeures de TES en fonction de Eb_N0_db
Tab_Eb = [0,1,2,3,4,5,6]; 
%valeurs de Eb_N0_db en décibels
for Eb_N0_db =0:6
    %valeur linéaire de Eb_N0
    Eb_N0_lineaire=10^(Eb_N0_db/10); 
    %Puissance du signal modulé =E([x|.^2)
    Px=mean(abs(signal_emis).^2);    
    %Puissance reçue
    Pr=Px; 
    %la puissance du bruit en sortie du filtre de réception
    sigma_n_carre=(Pr*Ns)/(4*Eb_N0_lineaire);
    %Génération du bruit 
    bruit=sqrt(sigma_n_carre)*randn(1,length(signal_emis));
    %signal généré avec bruit
    signal_bruite=signal_emis+bruit;
    %signal reçu à la sortie du filtre de réception 
    signal_recu_1=filter(hr,1,signal_bruite);
    %échantillonnage du signal à T=Ns, le pas= Ns
    signal_echantillonne_2=signal_recu_1(Ns:Ns:end);  
    %détecteur de seuil
    symboles_decides = zeros(1,length(signal_echantillonne_2));
    for j=1:length(signal_echantillonne_2)
        if (signal_echantillonne_2(j) >= 0)
            if (signal_echantillonne_2(j) <= 2*Ns)
                symboles_decides(j) = 1;
            elseif (signal_echantillonne_2(j) > 2*Ns)
                symboles_decides(j) = 3;
            end
        elseif (signal_echantillonne_2(j) < 0)
            if ( -2*Ns <= signal_echantillonne_2(j))
                symboles_decides(j) = -1;
             elseif (signal_echantillonne_2(j) < -2*Ns)
                symboles_decides(j) = -3;
             end
        end
    end 
    bits_decides = reshape(de2bi((symboles_decides+3)/2).',1,n_bits);
    Tableau_TES(1,Eb_N0_db+1)=length(find(bits_decides~=bits))/length(bits);
end
figure;
semilogy(Tab_Eb,Tableau_TES,'r-o');
xlabel('E_s/N_0 en décibels');
ylabel('TES');
title('le taux d erreur symbole');
%%
%Comparaison
%tableau contenant les différentes valeures de TES théoriques
Tes_theorique =(3/2) *qfunc(sqrt((4/5)*(10.^(Tab_Eb/10))));    
figure;
semilogy(Tab_Eb,Tableau_TES,'r-o');
hold on;
semilogy(Tab_Eb,Tes_theorique,'b-*');
hold off;
%tracé le taux d'erreur symboles obtenu en fonction du rapport signal de bruit par bit à l'entrée du récepteur (Es/N0) en décibels.
legend('TES simulé','TES theorique');
xlabel('E_b/N_0 en décibels');
ylabel('TES');
title('le taux d erreur symbole');
%%

%tableau contenant les différentes valeures de TEB estim�es
Tableau_TEB=zeros(1,7); 
%tableau contenant les différentes valeures de TEB en fonction de Eb_N0_db
Tab_Eb = [0,1,2,3,4,5,6]; 
%valeurs de Eb_N0_db en décibels
for Eb_N0_db=0:6
    %valeure linéaire de Eb_N0
    Eb_N0_lineaire=10^(Eb_N0_db/10); 
    %Puissance du signal modulé =E([x|.^2)
    Px=mean(abs(signal_emis).^2);    
    %Puissance reçue
    Pr=Px; 
    %la puissance du bruit en sortie du filtre de réception
    sigma_n_carre=(Pr*Ns)/(4*Eb_N0_lineaire);
    %Génération du bruit 
    bruit=sqrt(sigma_n_carre)*randn(1,length(signal_emis));
    %signal généré avec bruit
    signal_bruite=signal_emis+bruit;
    %signal reçu à la sortie du filtre de réception 
    signal_recu_1=filter(hr,1,signal_bruite);
    %échantillonnage du signal à T=Ns, le pas= Ns
    signal_echantillonne_2=signal_recu_1(Ns:Ns:end);  
    %détecteur de seuil
    symboles_decides = zeros(1,length(signal_echantillonne_2));
    for j=1:length(signal_echantillonne_2)
        if (signal_echantillonne_2(j) >= 0)
            if (signal_echantillonne_2(j) <= 2*Ns)
                symboles_decides(j) = 1;
            elseif (signal_echantillonne_2(j) > 2*Ns)
                symboles_decides(j) = 3;
            end
        elseif (signal_echantillonne_2(j) < 0)
            if ( -2*Ns <= signal_echantillonne_2(j))
                symboles_decides(j) = -1;
             elseif (signal_echantillonne_2(j) < -2*Ns)
                symboles_decides(j) = -3;
             end
        end
    end 
   % BitsDecides = reshape(de2bi((symboles_decides + 3)/2).', 1, length(bits));
   bits_decides = reshape(de2bi((symboles_decides+3)/2).',1,n_bits);
   Tableau_TES(1,Eb_N0_db+1)=length(find(bits_decides~=bits))/length(bits);
end
figure;
semilogy(Tab_Eb,Tableau_TEB,'b-*');
xlabel('E_b/N_0 en décibels');
ylabel('TEB');
title('le taux d erreur binaire');
%%

%tableau contenant les différentes valeures de TEB théoriques
Teb_theorique = (3/4) *qfunc(sqrt((4/5)*(10.^(Tab_Eb/10))));      %TES = log2(M)*TEB
figure;
semilogy(Tab_Eb,Tableau_TEB,'r-o');
hold on;
semilogy(Tab_Eb,Teb_theorique,'b-*');
hold off;
%tracé le taux d'erreur binaire obtenu en fonction du rapport signal à bruit par bit à l'entrée du récepteur (Eb/N0) en décibels.
legend('Teb simulé','Teb theorique');
xlabel('E_b/N_0 en décibels');
ylabel('TEB');
title('le taux d erreur binaire');


