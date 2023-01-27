function [x_filtre, h_bas, ords] = Filtre_bas(x , Fc, Fe, ordre)
    fc_norm = Fc/Fe;   % fréquence normalisée
    Te = 1/Fe;
    ords = -(ordre-1)/2*Te:Te:(ordre-1)/2*Te;
    h_bas = 2*fc_norm*sinc(2*Fc*ords);
    x_padded = [x; zeros((ordre-1)/2, 1)];
    x_filtre = filter(h_bas,1,x_padded);
    x_filtre = x_filtre((ordre+1)/2:end);
end

