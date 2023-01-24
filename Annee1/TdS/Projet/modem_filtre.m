% Modulateur / Demodulateur par filtre
%Felix Foucher
%Achraf Marzougui

function [signal] = modulateur(bits, phi0, phi1)

    Fe = 48000; % Fréquence d'échantillonnage
    Te = 1/Fe; % Période d'échantillonnage
    D = 300; % Débits de la transmission
    Ns = Fe/D; % Nombre d'échantillons par bits

    Fc = 1080; % Fréquence de coupure
    delta_f = 100;
    F0 = Fc + delta_f;
    F1 = Fc - delta_f;

    T = Te * [0:(length(bits)*Ns-1)]; % Echelle temporelle 
    NRZ = repelem(bits, Ns)'; % Signal NRZ
    signal = (1 - NRZ) .* cos(2*pi*F0*T + phi0) + NRZ .* cos(2*pi*F1*T + phi1);

end



function [bits_restitues] = demodulateur_filtre(signal)

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

    T_filtre = Te*[-(ordre-1)/2:(ordre-1)/2]; % Echelle temporelle du filtre passe bas
    h_pb = 2*Fc_norm*sinc(2*Fc_norm*(T_filtre/Te)); % Reponse impulsionnelle du filtre passe bas

    Xpb_d = filter(h_pb, 1, [x_perturbe, zeros(1, floor(ordre/2) - 1)]);
    Xpb = Xpb_d(floor(ordre/2):end);

    Ypb = reshape(Xpb,Ns,length(signal)/Ns);
    energie = sum(Ypb.^2, 1);
    bits_restitues = energie > 10;

end