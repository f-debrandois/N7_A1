% Modulateur / Demodulateur par filtre
%Felix Foucher
%Achraf Marzougui

function [bits_restitues] = modem_filtre(signal)

    Fe = 48000; % Fréquence d'échantillonnage
    Te = 1/Fe; % Période d'échantillonnage
    D = 300; % Débits de la transmission
    Ns = Fe/D; % Nombre d'échantillons par bits

    Fc = 1080; % Fréquence de coupure
    delta_f = 100;
    F0 = Fc + delta_f;
    F1 = Fc - delta_f;
    Fc_norm = Fc/Fe;  % fréquence normalisée
      
    ordre = 201;
    K = 10;

    T_filtre = Te*[-(ordre-1)/2:(ordre-1)/2]; % Echelle temporelle du filtre passe bas
    h_pb = 2*Fc_norm*sinc(2*Fc_norm*(T_filtre/Te)); % Reponse impulsionnelle du filtre passe bas

    Xpb_padded = filter(h_pb, 1, [signal, zeros(1, floor(ordre/2) - 1)]);
    Xpb = Xpb_padded(floor(ordre/2):end);

    Ypb = reshape(Xpb,Ns,length(signal)/Ns);
    energie = sum(Ypb.^2, 1);
    bits_restitues = energie > K;

end