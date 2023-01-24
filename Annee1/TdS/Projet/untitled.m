
SNR_dB = [1; 2; 10; 20; 50; 100];
x = [1 5 10 3 4 12];
P_y = 0.5*10.^(-SNR_dB/10)
bruit = sqrt(P_y) * randn(1, length(x))

x_perturbe = x + bruit
