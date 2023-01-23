% TP1
% Félix Foucher de Brandois

clear all; close all;
t = tiledlayout(2,1);

%1
N = 90;
Fe = 10000;
Te = 1/Fe;
f0 = 1100;
A = 1;

T1 = [0:Te:(N-1)*Te];
Y1 = A*cos(2*pi*T1*f0);

%2
nexttile
plot(T1, Y1);
xlabel("Temps (s)");
ylabel("Tension (V)");
title("Période cos1")

%3
Fe = 1000;
Te = 1/Fe;
f0 = 1100;
A = 1;

T2 = [0:Te:(N-1)*Te];
Y2 = A*cos(2*pi*T2*f0);

%4
nexttile
plot(T2, Y2);
xlabel("Temps (s)");
ylabel("Tension (V)");
title("Période cos2")

% Fréquence de 100 Hz

%EXERCICE 2
%1
% Un signal échantillonné est périodique

%2
t  = tiledlayout(2,2);
Fe = 10000;
F1 = [-Fe/2 : Fe/(N-1) : Fe/2];
TF1 = fftshift(fft(Y1));
nexttile
semilogy(F1, abs(TF1));
xlabel("Fréquence (Hz)");
ylabel("Signal transformé (V)");
title("Fréquence cos1")

Fe = 1000;
F2 = [-Fe/2 : Fe/(N-1) : Fe/2];
TF2 = fftshift(fft(Y2));
nexttile
semilogy(F2, abs(TF2));
xlabel("Fréquence (Hz)");
ylabel("Signal transformé (V)");
title("Fréquence cos2")

%3
N_prime = 2^16;
Fe = 10000;
F1 = [-Fe/2 : Fe/(N_prime-1) : Fe/2];
TF1 = fftshift(fft(Y1,N_prime));
nexttile
semilogy(F1, abs(TF1));
xlabel("Fréquence (Hz)");
ylabel("Signal transformé (V)");
title("Fréquence cos1 N'")

N_prime = 2^20;
Fe = 10000;
F1 = [-Fe/2 : Fe/(N_prime-1) : Fe/2];
TF1 = fftshift(fft(Y1,N_prime));
nexttile
semilogy(F1, abs(TF1));
xlabel("Fréquence (Hz)");
ylabel("Signal transformé (V)");
title("Fréquence cos1 N'")

%4
t  = tiledlayout(2,1);
Fe = 10000;
F1 = [-Fe/2 : Fe/(N-1) : Fe/2];
TF1 = fftshift(fft(Y1,N));
DSP = pwelch(TF1);
nexttile
plot(F1, DSP);
xlabel("Fréquence (Hz)");
ylabel("Signal transformé (V)");
title("Fréquence cos1 N'");
DSP = pwelch(TF1);