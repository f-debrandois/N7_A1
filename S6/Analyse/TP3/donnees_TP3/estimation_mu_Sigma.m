function [mu,Sigma] = estimation_mu_Sigma(X)
% Fonction qui renvoie la moyenne et la matrice de covariance du vecteur X

    n_app = size(X, 1);
    mu = mean(X, 1)';
    Sigma = (1/n_app) * (X - mu')' * (X - mu');
end

