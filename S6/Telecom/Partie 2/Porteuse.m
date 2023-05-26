% Projet de Telecommunication : Etude de chaines de transmission sur porteuse
% Nom / Prénom : Foucher de Brandois Félix
% Nom / Prénom : Alioui Ilyasse
% Groupe : 1SN-E

clear all; close all;

% Constantes
n_bits = 100; % Nombre de bits
bits = randi([0 1], n_bits, 1); % Bits à transmettre

Fe = 24000; % Fréquence d'échantillonnage
Te = 1/Fe; % Période d'échantillonnage
Rb = 3000; % Débits de la transmission
Tb = 1/Rb; % Période par bits

fp = 2000;      % Fréquence de la porteuse

%% 2. Implantation de la transmission avec transposition de fréquence
figure('name', 'Implantation de la transmission avec transposition de fréquence')
Ts = 2 * Tb;            % Période symbole
Ns = Fe * Ts;       % Nombre d'échantillons par bits
n0 = Ns;            % Choix du t0 pour respecter le critère de Nyquist

L = 10;
alpha = 0.35;
h = rcosdesign(alpha, L, Ns, 'sqrt');

An = (2*bits - 1)';
I = An(1:2:n_bits);
Q = An(2:2:n_bits);
At = [kron(I + 1i * Q, [1, zeros(1, Ns-1)])];

retard=[At zeros(1,Ns*L+1)];
xe = filter(h,1,retard);

T = [0:length(xe)-1]*Te;
x = real(xe).*cos(2*pi*fp*T) - imag(xe).*sin(2*pi*fp*T);

% Tracé des signaux générés
nexttile
plot(real(xe((L*Ns)/2:end)))
hold on
plot(imag(xe((L*Ns)/2:end)))
hold off
title('Tracé des signaux générés')
legend('I(t)','Q(t)')
grid
xlabel('Temps (s)')

% Tracé du signal transmis
nexttile
plot(x((L*Ns)/2:end))
title('Tracé du signal transmis')
xlabel('Temps (s)')

% Tracé de la DSP des signaux générés
[DSP1, F1] = pwelch(filter(h, 1, I), [], [], [], Fe, 'twosided');
[DSP2, F2] = pwelch(filter(h, 1, Q), [], [], [], Fe, 'twosided');
Freq1 = linspace(-Fe/2, Fe/2, length(F1));
Freq2 = linspace(-Fe/2, Fe/2, length(F2));

nexttile
semilogy(Freq1, DSP1)
hold on
semilogy(Freq2, DSP2)
hold off
xlabel('fréquence (Hz)');
ylabel('DSP');
title('Tracé de la DSP du signal généré en phase et en quadratude');
legend('DSP du signal en phase', 'DSP du signal en quadrature');

% Tracé de la DSP des signaux transmis
[DSPx, Fx] = pwelch(x, [], [], [], Fe, 'twosided');
Freqx = linspace(-Fe/2, Fe/2, length(Fx));

nexttile
semilogy(Freqx,fftshift(DSPx));
xlabel("Fréquence en hertz (Hz)");
ylabel("DSP du signal");
title("Tracé de la densité spectrale du signal transmis sur la fréquence porteuse");

% Tracé du TEB obtenu
EbN0=0:6;

for k=1:length(EbsurN0)

    varb=(mean(abs(x).^2)*Ns)/(2*log2(M)*10^(EbsurN0(k)/10));
    r=x+sqrt(varb)*randn(1,length(x));

    %Demodulateur
    x_modif=r.*cos(2*pi*fp*t) - r.*sin(2*pi*fp*t)*1j;

    z=filter(hr,1,x_modif); % generation de z(t) signal a la sortie du filtre de reception
    
    %decision 
    t0=L*Ns+1;
    echant=z(t0:Ns:length(z)-1);    % sous-echantillonnage pour prendre des decisions
                                    % la decision sur le symbole emis a mTs se
                                    % prend a t0+mTs

    bit_estim(1:2:nb_bits)= (real(echant)<0);
    bit_estim(2:2:nb_bits)= (imag(echant)<0);
    
    % Calcul taux d'erreur :
    TEB_2(k) = sum(bit_estim~=bits)/nb_bits; 

end





% Comparaison des TEB

%% Calcul et affichage des DSP en quadrature et en phase


%% Passage par le canal 

N = 99; 
i = 1; % Indice de parcours
for R = ensemble_R 
    Px = mean(abs(x).^2);
    sigma = sqrt(Px*Ns3/(2*log2(M)*10^(R/10)));
    bruit = sigma * randn(1, length(x));
    %bruit = 0;  % A modifier si on veut du bruit
    x_bruit = x + bruit;
    
    %% Démodulateur
    
    xi = 2*cos(2*pi*fp*t).*x_bruit;
    xq = 2*sin(2*pi*fp*t).*x_bruit;
    
    x_dem = xi -xq*1i;
    
    x_dem = [x_dem, x_dem(1:retard)]; % Gestion du retard
    signal_sortie = filter(h, 1, x_dem);
    signal_sortie = signal_sortie(retard+1:length(signal_sortie));
    
    Mat = reshape(signal_sortie, Ns3, length(signal_sortie)/Ns3);
 
    reception =  Mat(n0,:); 
    
    reel = real(reception);
    im = imag(reception);
    
    %On vérifie le signe de reel ou de im pour savoir si c'est 0 ou 1
    
    im(im > 0) = 1; 
    im(im <= 0) = 0;
    
    reel(reel > 0) = 1;
    reel(reel <= 0) = 0;
    
    bits_reception = zeros(1, n_bits);
    bits_reception(1:2:n_bits) = reel;
    bits_reception(2:2:n_bits) = im;

    erreur = (bits_reception == bits);
    % Calcul du taux d'erreur binaire pour une valeur de Eb/n0
    Taux_erreur = 1-mean(erreur);
    ensemble_TEB_exp(i) = Taux_erreur;
    i = i + 1;
end 

figure;
plot(Mat);

scatterplot(reception);
TEB = 2*qfunc(sqrt(2*log2(M)*10.^(ensemble_R/10))*sin(pi/M))/log2(M);

figure;
semilogy(ensemble_R, ensemble_TEB_exp,'LineWidth',2);
hold on
semilogy(ensemble_R, TEB,'LineWidth',2);
hold off