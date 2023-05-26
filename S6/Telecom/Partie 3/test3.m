clc;
close all;
% Paramètres de la transmission
M = 2;
Fe = 24e3; % Fréquence d'échantillonnage (Hz)
Te=1/Fe;
Rb = 3e3; % Débit binaire (bps)
Rs=Rb/log2(M);
Ts=1/Rs;
fp = 2e3; % Fréquence porteuse (Hz)
rolloff = 0.35; % Roll-off du filtre de mise en forme
EbN0 = 10; % Rapport signal/bruit par bit souhaité (dB)
M = 4; % Ordre de la modulation (QPSK)
Ns=Ts/Te;
% Génération des données binaires
N_Bits = 1000; % Nombre de bits à transmettre
bits = randi([0 1], 1, N_Bits); % Génération aléatoire des bits


% Mapping QPSK
m=floor(N_Bits/ log2(M));
symboles = zeros(1,m);
for i = 1:m
    if bits(2*i-1)==0 && bits(2*i)==0
        symboles(i)=1+1j;
    elseif bits(2*i-1)==1 && bits(2*i)==1
        symboles(i)=-1-1j;
    elseif bits(2*i-1)==0 && bits(2*i)==1
        symboles(i)=1-1j;  
    else
        symboles(i)=-1+1j;
    end
end
%% Modulation
Suite_diracs = kron(symboles, [1 zeros(1,Ns-1)]);

% Filtre de mise en forme
h = rcosdesign(rolloff, 8, Ns); % Filtre en racine de cosinus surélevé
order=sum(h~=0);
delay=floor((order-1)/2)-1;
xe1=filter(h,1,[Suite_diracs zeros(1,delay)]);
% Signal transmis
Signal_transmis=xe1(delay+1:end);
%temps
 t= linspace(0,Rb*N_Bits,(N_Bits/log2(M)*Ns)) ;
%transposition de frequence
Te=1/Fe;
x=real(Signal_transmis.*exp(2*1j*pi*fp*Te*(0:((N_Bits/log2(M)*Ns)-1))));

% Ajout du bruit
Px = mean(abs(Signal_transmis).^2); % Puissance du signal à bruiter

rapport_Eb_N0 = (0:1:6);
EbN0_l = 10.^(rapport_Eb_N0/10);
%taux d'erreur bianire
TEB = ones(1,length(rapport_Eb_N0));
TEB_Theo = zeros(1, length(rapport_Eb_N0));
for i=1:length(rapport_Eb_N0)
      sigma_n = sqrt(Px*Ns/(2*log2(M)*10^(EbN0/10))); % Écart-type du bruit
      bruit = sigma_n * randn(size(Signal_transmis)); % Bruit gaussien
      Signal_recu = Signal_transmis + bruit;
      %% retour en bande de base
     Signal_recu_cos=Signal_recu.*(cos(2*pi*fp*Te*(0:((N_Bits/log2(M)*Ns)-1))));
     Signal_recu_sin=Signal_recu.*(sin(2*pi*fp*Te*(0:((N_Bits/log2(M)*Ns)-1))));
     
     Signal_recu_filtre=Signal_recu_cos-1j*Signal_recu_sin;
     %% Filtrage de reception
     hr=h;

    order = sum(h~=0);
    delay = floor((order-1)/2)-1;
    z1= filter(hr,1, [Signal_recu_filtre zeros(1,delay)]);
    z2 = z1(delay+1 :end);
    %% Echantillonage de signal
     %Décision:
     z = z2(1: Ns: end);
    symboles_decides = zeros(1, length(z));
    for j = 1:length(z)
        if (real(z(j)) <= 0) && (imag(z(j)) <= 0)
            symboles_decides(j) = - 1 - 1j;
        elseif (real(z(j)) <= 0) && (imag(z(j)) > 0)
            symboles_decides(j) = - 1 + 1i; 
        elseif (real(z(j)) > 0) && (imag(z(j)) <= 0)
            symboles_decides(j) = 1 - 1i; 
        else
            symboles_decides(j) = 1 + 1i;
        end
    end

    % Calcul du TEB simulé et théorique
    TES= ones(1,length(rapport_Eb_N0));
    TES(i) = length(find(symboles_decides ~= symboles)) / length(symboles);
    TEB(i) = TES(i) / log2(4);
    TES_Theo= ones(1,length(rapport_Eb_N0));
    TES_Theo(i) = 2*qfunc(sqrt(4* EbN0_l(i)) * sin(pi / 4));
    TEB_Theo(i) = TES_Theo(i)/log2(4);
 end

%%
% Tracé des signaux
figure;
subplot(2, 1, 1);
plot(t, real(Signal_transmis));
xlabel('Temps (s)');
ylabel('In-Phase');
title('Signal sur la voie en phase');
subplot(2, 1, 2);
plot(t, imag(Signal_transmis));
xlabel('Temps (s)');
ylabel('Quadrature');
title('Signal sur la voie en quadrature');
figure;
plot(t, Signal_transmis);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal transmis sur fréquence porteuse');
% Tracé des DSP
figure;
subplot(2, 1, 1);
pwelch(real(Signal_transmis),[],[],[],Fe,'twosided');
xlabel('Fréquence (Hz)');
ylabel('DSP (dB/Hz)');
title('DSP du signal sur la voie en phase');
subplot(2, 1, 2);
pwelch(imag(Signal_transmis),[],[],[],Fe,'twosided');
xlabel('Fréquence (Hz)');
ylabel('DSP (dB/Hz)');
title('DSP du signal sur la voie en quadrature');
figure;
pwelch(Signal_transmis,[],[],[],Fe,'twosided');
xlabel('Fréquence (Hz)');
ylabel('DSP (dB/Hz)');
title('DSP du signal transmis sur fréquence porteuse');

%Tracé du TEB pratique et théorique en fonction du rapport Eb/N0
figure(6)
semilogy(rapport_Eb_N0, TEB, 'r');
hold on;
semilogy(rapport_Eb_N0, TEB_Theo, 'g');
legend('TEB pratique', 'TEB théorique');
title("Comparaison du taux d'erreur binaire pratique et " + ...
 "théorique en fonction du rapport signal à bruit")
xlabel("Db")
ylabel("TEB")