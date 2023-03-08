function pourcentage = classif_MV(X,mu_1,Sigma_1,mu_2,Sigma_2)
% Renvoie permettant de calculer le pourcentage d images d’apprentissage correctement classées.

    n_app = size(X, 1);
    nb_bonne_classification = 0;

    for i = 1:n_app

        V1_classe1 = vraisemblance(X(i, 1, 1), X(i, 2, 1), mu_1, Sigma_1);
        V1_classe2 = vraisemblance(X(i, 1, 2), X(i, 2, 2), mu_1, Sigma_1);
        V2_classe1 = vraisemblance(X(i, 1, 1), X(i, 2, 1), mu_2, Sigma_2);
        V2_classe2 = vraisemblance(X(i, 1, 2), X(i, 2, 2), mu_2, Sigma_2);

        if V1_classe1 > V2_classe1
            nb_bonne_classification = nb_bonne_classification + 1;
        end
        if V1_classe2 > V2_classe2
            nb_bonne_classification = nb_bonne_classification + 1;
        end
    end

    pourcentage = nb_bonne_classification / (2 * n_app);

    
end

