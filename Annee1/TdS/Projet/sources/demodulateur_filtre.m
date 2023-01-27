function [bits_restitues] = demodulateur_filtre(signal, F0, F1, ordre, K, type)

    Fe = 48000; % Fréquence d'échantillonnage
    Te = 1/Fe; % Période d'échantillonnage
    D = 300; % Débits de la transmission
    Ns = Fe/D; % Nombre d'échantillons par bits

    Fc = (F0+F1)/2; % Fréquence de coupure
    Fc_norm = Fc/Fe;  % fréquence normalisée

    T_filtre = Te*[-(ordre-1)/2:(ordre-1)/2]; % Echelle temporelle du filtre passe bas
    h_pb = 2*Fc_norm*sinc(2*Fc_norm*(T_filtre/Te)); % Reponse impulsionnelle du filtre passe bas
    h_ph = -h_pb;
    h_ph((ordre+1)/2) = h_ph((ordre+1)/2)+1;

    if type == "pb"
        Xpb_padded = filter(h_pb, 1, [signal, zeros(1, floor(ordre/2) - 1)]);
        Xpb = Xpb_padded(floor(ordre/2):end);

    elseif type == "ph"
        Xpb_padded = filter(h_pb, 1, [signal, zeros(1, floor(ordre/2) - 1)]);
        Xpb = Xpb_padded(floor(ordre/2):end);
    else
        Xpb = 0;
    end

    Ypb = reshape(Xpb,Ns,length(signal)/Ns);
    energie = sum(Ypb.^2, 1);
    bits_restitues = energie > K;

end