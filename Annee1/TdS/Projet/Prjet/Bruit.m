function [x_bruit] = Bruit(x,SNR_dB)
    
    P_x = mean(abs(x).^2);
    P_y = P_x*10^(-SNR_dB/10);
    bruit = sqrt(P_y) * randn(1, size(x, 1))';
    x_bruit = x + bruit;
    
end
