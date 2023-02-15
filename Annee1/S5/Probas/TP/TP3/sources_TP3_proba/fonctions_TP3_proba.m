
% TP3 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom :
% Prénom : 
% Groupe : 1SN-

function varargout = fonctions_TP3_proba(nom_fonction,varargin)

    switch nom_fonction
        case 'ensemble_E_recursif'
            [varargout{1},varargout{2},varargout{3}] = ensemble_E_recursif(varargin{:});
        case 'matrice_inertie'
            [varargout{1},varargout{2}] = matrice_inertie(varargin{:});
        case 'calcul_proba'
            [varargout{1},varargout{2},varargout{3}] = calcul_proba(varargin{:});
    end
    
end

% Fonction ensemble_E_recursif (exercie_1.m) ------------------------------
function [E,contour,G_somme] = ensemble_E_recursif(E,contour,G_somme,i,j,voisins,G_x,G_y,card_max,cos_alpha)

    % Mise à 0 de la valeur contour du pixel courant pour ne pas retourner dessus
    contour(i,j) = 0;
    % Nombre de voisins (ici 8)
    nb_voisins = size(voisins,1);
    % Initialisation du comptage des 8 voisins a parcourir
    k = 1;
    % Parcours des differents voisins si E n'est pas deja trop grand
    while (k < nb_voisins + 1) && (size(E, 1)<=card_max)
        i_v = i + voisins(k, 1);
        j_v = j + voisins(k, 2);

        if contour(i_v, j_v) == 1
            Grad_k = [G_x(i_v, j_v),G_y(i_v, j_v)];
            Grad_k_norme = sqrt(Grad_k(1)^2 + Grad_k(2)^2);
            G_somme_norme = sqrt(G_somme(1).^2+G_somme(2).^2);
            
            if sum(Grad_k.*G_somme) >= cos_alpha*Grad_k_norme*G_somme_norme
                E = [E; i_v, j_v];
                G_somme = G_somme + Grad_k;
                [E, contour, G_somme] = ensemble_E_recursif(E,contour,G_somme,i_v, j_v,voisins,G_x,G_y,card_max,cos_alpha);
            end
        end
        k = k+1;
    end

end

% Fonction matrice_inertie (exercice_2.m) ---------------------------------
function [M_inertie,C] = matrice_inertie(E,G_norme_E)
    pi = sum(G_norme_E);
    E_x = E(:, 2);
    E_y = E(:, 1);

    x_bar = sum(E_x.*G_norme_E)/pi;
    y_bar = sum(E_y.*G_norme_E)/pi;
    C = [x_bar y_bar]

    M_inertie = zeros(2);
    M_inertie(1, 1) = sum(G_norme_E.*((E_x - x_bar).^2))/pi;
    M_inertie(1, 2) = sum(G_norme_E.*((E_x - x_bar).*(E_y - y_bar)))/pi;
    M_inertie(2, 1) = sum(G_norme_E.*((E_x - x_bar).*(E_y - y_bar)))/pi;
    M_inertie(2, 2) = sum(G_norme_E.*((E_y - y_bar).^2))/pi;
    
    

   

end

% Fonction calcul_proba (exercice_2.m) ------------------------------------
function [x_min,x_max,probabilite] = calcul_proba(E_nouveau_repere,p)


    
end
