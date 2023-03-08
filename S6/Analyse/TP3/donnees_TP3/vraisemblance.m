function [V] = vraisemblance(valeurs_carac_1,valeurs_carac_2,mu,Sigma)
% Fonction qui estime la vraisemblance de chaque classe au nuage de points 2D.

    x = [valeurs_carac_1; valeurs_carac_2];
    V = (1/(2*pi*sqrt(det(Sigma)))) * exp(-1/2 * (x-mu)' * inv(Sigma) * (x-mu));
end

