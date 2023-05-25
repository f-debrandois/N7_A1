% Projet de Telecommunication : Introduction à l'égalisation
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-E

clear all ; close all;

% Constantes
n_bits = 1000; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre
bits_test = [0 1 1 0 0 1]';

% n_bits = 6;
% bits = bits_test;

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits


%% 2. Impact d’un canal de propagation multitrajets
% 2.1 Etude théorique
figure('name', 'Etude théorique')

    % Signal de réception
    xe1 = (2*bits_test - 1);
    xe2 = 0.5*xe1;
    
    nexttile
    plot(0 : 5, xe1)
    ylim([-1.5, 1.5])
    hold on
    plot(xe2)
    hold off
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Décomposition du signal de réception')
    legend('x(t)', '0.5 * x(t - Ts)')
    xticks(1 : 6)
    xticklabels("Ts")
    grid on;
    
    nexttile
    y = [xe1; 0] + [0; xe2];
    plot(0 : 6, y)
    ylim([-2, 2])
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Décomposition du signal de réception')
    xticks(1 : 6)
    xticklabels("Ts")
    grid on;

    % Diagramme de l'oeil
    nexttile
    d = kron(y, ones(2, 1));
    plot(reshape(d(2:end-1),2, (length(y)-2)/2))
    title('Diagramme de l''oeil')


% 2.2 Implantation sous Matlab
figure('name', 'Implantation sous Matlab')
Ts = Tb;            % Période symbole
Ns = Fe * Ts;       % Nombre d'échantillons par bits
n0 = Ns;            % Choix du t0 pour respecter le critère de Nyquist

h = ones(1, Ns);    % Reponse impulsionnelle du filtre de mise en forme
hr = fliplr(h);  % Reponse impulsionnelle du filtre de réception

alpha0 = 1;
alpha1 = 0.5;
hc = [alpha0 zeros(1,Ns-1) alpha1 zeros(1,Ns-1)]; % Reponse impulsionnelle du filtre canal

An = (2*bits - 1)';
At = [kron(An, [1, zeros(1, Ns-1)])];

x = filter(h, 1, At);
r = filter(hc, 1, x);

% Sans Canal
    z1 = filter(hr, 1, x);

    echantillon = z1(n0:Ns:end);
    bits_sortie1 = (sign(echantillon) + 1) / 2;
    TEB1 = sum(bits_sortie1' ~= bits) / n_bits;

    fprintf("TEB sans canal : " + TEB1 + "\n");

    nexttile
    stem([0:(n_bits*Ns-1)]*Te,At)
    ylim([-1.5, 1.5])
    hold on
    stem([0:(n_bits*Ns-1)]*Te, kron((2*bits_sortie1 - 1), [1, zeros(1, Ns-1)]))
    hold off
    xlabel("temps (s)")
    ylabel("Signal temporel")
    title('Comparaison des bits sans canal')
    legend('Bits de départ', 'Bits d''arrivée')

% Avec Canal
    z2 = filter(hr, 1, r);

    % Signal de sortie
    nexttile
    plot([0:n_bits*Ns - 1] * Te, z2);
    title('Signal de sortie');
    xlabel("temps (s)")
    ylabel("Signal temporel")
    xticks([1 : n_bits] * Ts - Te)
    xticklabels("Ts")
    grid on
    
    % Diagramme de l'oeil
    nexttile
    d = reshape(z2,Ns,length(z2)/Ns);
    plot(d(:,2:end));
    title('Diagramme de l''oeil')

    % Constellation
    nexttile
    echantillon = z2(n0:Ns:end);
    plot(echantillon(2:end), zeros(1, n_bits-1),'*')
    title('Constellation obtenue en réception')

    % TEB obtenu
    bits_sortie2 = (sign(echantillon) + 1) / 2;
    TEB2 = sum(bits_sortie2' ~= bits) / n_bits;
    fprintf("TEB avec canal : " + TEB2 + "\n");

% Avec Bruit
figure('name', 'Chaine avec bruit')

EbN0 = 0:10;

TEB_bruit = zeros(1, length(EbN0));
TEB_sans_canal = zeros(1, length(EbN0));
Px = mean(abs(x).^2);

for i = 1:length(EbN0)
    for j = 1:100

        % Création du bruit
        sigma2 = Px*Ns/(2*10^(EbN0(i)/10));
        bruit = sqrt(sigma2)*randn(1, Ns*n_bits);
    
        z_bruit = filter(hr, 1, r + bruit);
        z_sans_canal = filter(hr, 1, x + bruit);
    
        % TEB chaine avec bruit
        echantillon = z_bruit(n0:Ns:end);
        bits_sortie = (sign(echantillon) + 1) / 2;
        TEB_bruit(i) = TEB_bruit(i) + (sum(bits_sortie' ~= bits) / n_bits);
    
        % TEB chaine sans canal
        echantillon = z_sans_canal(n0:Ns:end);
        bits_sortie = (sign(echantillon) + 1) / 2;
        TEB_sans_canal(i) = TEB_sans_canal(i) + (sum(bits_sortie' ~= bits) / n_bits);
    end
end
    TEB_bruit = TEB_bruit/100;
    TEB_sans_canal = TEB_sans_canal/100;

    % Comparaisons TEB
    TEB_th = (1/2)*(qfunc(sqrt((1/2)*(10.^(EbN0./10)))) + qfunc(3*sqrt((1/2)*(10.^(EbN0./10)))));

    nexttile
    semilogy(EbN0,TEB_bruit)
    hold on
    semilogy(EbN0,TEB_th)
    hold off
    title("Comparaison entre le TEB obtenu et le TEB théorique")
    legend("TEB obtenu","TEB théorique")
    xlabel("Eb/N0 (en dB)")
    ylabel("TEB")

    nexttile
    semilogy(EbN0,TEB_bruit)
    hold on
    semilogy(EbN0,TEB_sans_canal)
    hold off
    title("Comparaison entre le TEB obtenu avec et sans canal de propagation")
    legend("TEB avec canal","TEB sans canal")
    xlabel("Eb/N0 (en dB)")
    ylabel("TEB")


%% 3. Egalisation ZFE
% 3.1 Etude à réaliser
figure('name', 'Egalisation ZFE')
% Sans Bruit
    % Determination des coefs
    Y0 = [1 zeros(1,n_bits)]';
    Ze = toeplitz([alpha0 alpha1 zeros(1,n_bits-1)], [alpha0 zeros(1,n_bits)]);
    C = Ze\Y0;
    disp("Preimers coefficients de l'égalisateur ZFE")
    disp(C(1:10)')

    % Tracé des réponses en fréquence
    Hc = fft(hc,1024);
    Heg = fft(C,1024);
    HcHeg = Hc .* Heg;

    nexttile
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(Hc)/ max(abs(Hc))))
    title('Réponse en fréquence du filtre canal Hc')
    xlabel('Fréquence (Hz)')

    nexttile
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(Heg)/ max(abs(Heg))))
    title('Réponses en fréquence du filtre de l''égaliseur Heg')
    xlabel('Fréquence (Hz)')

    nexttile
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(HcHeg)/ max(abs(HcHeg))))
    title('Produit des réponses en fréquence Hc * Heg')
    xlabel('Fréquence (Hz)')

    % Tracé des réponses impulsionnelles
    figure('name', 'Tracés')
    g1 = conv(h,conv(hc,hr));
    g2 = conv(g1, C);

    nexttile
    plot(g1)
    title("Réponse impulsionnelle de la chaine de transmission avec et sans égalisateur")
    xlabel("Temps (s)");
    hold on
    plot(g2(1:30))
    hold off
    legend("sans égaliseur","avec égaliseur")

    % Comparaison des constellations
    nexttile
    z3 = filter(hr, 1, r);
    echantillon = z3(n0:Ns:end);
    y1 = filter(C, 1, echantillon);
    plot(echantillon(2:end), zeros(1, n_bits-1),'*')
    hold on
    plot(y1(2:end), zeros(1, n_bits-1),'*')
    hold off
    title('Constellation obtenue avant et après égalisateur')
    legend("Avant égalisateur","Après égalisateur")
    grid on

% Avec bruit
TEB_bruit = zeros(1, length(EbN0));
TEB_egalisateur = zeros(1, length(EbN0));
Px = mean(abs(x).^2);

for i = 1:length(EbN0)
    for j = 1:100

        % Création du bruit
        sigma2 = Px*Ns/(2*10^(EbN0(i)/10));
        bruit = sqrt(sigma2)*randn(1, Ns*n_bits);
    
        z_bruit = filter(hr, 1, r + bruit);
    
        % TEB sans égalisateur
        echantillon = z_bruit(n0:Ns:end);
        bits_sortie = (sign(echantillon) + 1) / 2;
        TEB_bruit(i) = TEB_bruit(i) + (sum(bits_sortie' ~= bits) / n_bits);

        % TEB avec égalisateur
        y = filter(C, 1, echantillon);
        bits_sortie = (sign(y) + 1) / 2;
        TEB_egalisateur(i) = TEB_egalisateur(i) + (sum(bits_sortie' ~= bits) / n_bits);
    end
end
    TEB_bruit = TEB_bruit/100;
    TEB_egalisateur = TEB_egalisateur/100;

    % Comparaison des TEB
    nexttile
    semilogy(EbN0,TEB_egalisateur)
    hold on
    semilogy(EbN0,TEB_bruit)
    hold off
    title("Comparaison entre le TEB obtenu avec et sans égalisateur")
    legend("Avec égalisateur","Sans égalisateur")
    xlabel("Eb/N0 (en dB)")
    ylabel("TEB")


%% 4. Egalisation MMSE
% 4.1 Etude à réaliser
figure('name', 'Egalisation MMSE')
% Sans Bruit
    % Determination des coefs
    %z4=[alpha0 alpha1 zeros(1,nb_bits-1)] ,[alpha0 zeros(1,nb_bits)];
    Xe = [alpha0 alpha1 zeros(1,n_bits-2)];
    rz = xcorr(Xe, Xe);
    Rz = toeplitz(rz, rz);
    Ra = xcorr(Xe, An(end:-1:1))';
    C = inv(Rz)*Ra;

    disp("Preimers coefficients de l'égalisateur MMSE")
    disp(C(1:10)')

    % Tracé des réponses en fréquence
    Hc = fft(hc,1024);
    Heg = fft(C,1024);
    HcHeg = Hc .* Heg;

    nexttile
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(Hc)/ max(abs(Hc))))
    title('Réponse en fréquence du filtre canal Hc')
    xlabel('Fréquence (Hz)')

    nexttile
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(Heg)/ max(abs(Heg))))
    title('Réponses en fréquence du filtre de l''égaliseur Heg')
    xlabel('Fréquence (Hz)')

    nexttile
    plot(linspace(-Fe/2, Fe/2, 1024), fftshift(abs(HcHeg)/ max(abs(HcHeg))))
    title('Produit des réponses en fréquence Hc * Heg')
    xlabel('Fréquence (Hz)')

    % Tracé des réponses impulsionnelles
    figure('name', 'Tracés')
    g1 = conv(h,conv(hc,hr));
    g2 = conv(g1, C);

    nexttile
    plot(g1)
    title("Réponse impulsionnelle de la chaine de transmission avec et sans égalisateur")
    xlabel("Temps (s)");
    hold on
    plot(g2(1:30))
    hold off
    legend("sans égaliseur","avec égaliseur")

    % Comparaison des constellations
    nexttile
    z4 = filter(hr, 1, r);
    echantillon = z4(n0:Ns:end);
    y2 = filter(C, 1, echantillon);
    plot(echantillon(2:end), zeros(1, n_bits-1),'*')
    hold on
    plot(y2(2:end), zeros(1, n_bits-1),'*')
    hold off
    title('Constellation obtenue avant et après égalisateur')
    legend("Avant égalisateur","Après égalisateur")
    grid on

% Avec bruit
TEB_bruit = zeros(1, length(EbN0));
TEB_egalisateur = zeros(1, length(EbN0));
Px = mean(abs(x).^2);

for i = 1:length(EbN0)
    for j = 1:100

        % Création du bruit
        sigma2 = Px*Ns/(2*10^(EbN0(i)/10));
        bruit = sqrt(sigma2)*randn(1, Ns*n_bits);
    
        z_bruit = filter(hr, 1, r + bruit);
    
        % TEB sans égalisateur
        echantillon = z_bruit(n0:Ns:end);
        bits_sortie = (sign(echantillon) + 1) / 2;
        TEB_bruit(i) = TEB_bruit(i) + (sum(bits_sortie' ~= bits) / n_bits);

        % TEB avec égalisateur
        y = filter(C, 1, echantillon);
        bits_sortie = (sign(y) + 1) / 2;
        TEB_egalisateur(i) = TEB_egalisateur(i) + (sum(bits_sortie' ~= bits) / n_bits);
    end
end
    TEB_bruit = TEB_bruit/100;
    TEB_egalisateur = TEB_egalisateur/100;

    % Comparaison des TEB
    nexttile
    semilogy(EbN0,TEB_egalisateur)
    hold on
    semilogy(EbN0,TEB_bruit)
    hold off
    title("Comparaison entre le TEB obtenu avec et sans égalisateur")
    legend("Avec égalisateur","Sans égalisateur")
    xlabel("Eb/N0 (en dB)")
    ylabel("TEB")
