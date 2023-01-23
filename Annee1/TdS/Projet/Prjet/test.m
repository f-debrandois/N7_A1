affichage3 = tiledlayout(2, 2);
figure(3)

sigma = 1;
Ech = sigma*randn(1, n);

P_x = mean(abs(x).^2);
P_y = P_x*10^(-SNR_dB/10);
bruit = sqrt(P_y) * randn(1, size(x, 1))';
x_bruit = x + bruit;

for i=1:4
    subplot(2,2,i)
    SNR_dB = 10 + 10*i;
    x_bruit = Bruit(x, SNR_dB);
    plot(t, x_bruit);
    xlabel("temps")
    ylabel("x bruité")
    title("SNR_d_B = " + SNR_dB)
end


