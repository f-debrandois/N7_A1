function [x_fh, h_haut, ords] = Filtre_haut(x, Fc, Fe, ordre)
       
    ordre = 61; 
    fc_norm = Fc/Fe;  % fréquence normalisée
    Te = 1/Fe;
    ords = [-(ordre-1)/2*Te:Te:(ordre-1)/2*Te];
    h_haut = 2*fc_norm*sinc(2*Fc*ords);
    h_haut((ordre+1)/2) = 1-2*fc_norm;
    x_padded = [x; zeros((ordre-1)/2, 1)];
    x_filtre = filter(h_haut,1,x_padded); % permet de filtrer le signal x_padded, la sortie du filtre étant x_filtre. 
    x_filtre = x_filtre((ordre+1)/2:end);

end
