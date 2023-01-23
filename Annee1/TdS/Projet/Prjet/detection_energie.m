function [bits_restitues] = detection_energie(x_filter, Ns)
    taille = length(x_filter);      
    K = 5;
    x_m = reshape(x_filter, [Ns, (taille/Ns)]); % on reforme x_m à partir de x_filter dans ce cas x_m aura 
    energies = sum(x_m.^2);                     % Ns lignes et taille/Ns colonnes
    bits_restitues = energies > K;              % il faut donc que Ns divise taille
    bits_restitues = bits_restitues';           % sum(x_m.^2)   fait la somme des carrés des entrées de chaque colonne de x_m
end                                             % A = B > K retourne un vecteur ligne A de meme taille que B tel que pour
                                                % toute entrée ds B si elle est sup à K elle est 
                                                % remplacée par 1 sinon par 0
                                               
