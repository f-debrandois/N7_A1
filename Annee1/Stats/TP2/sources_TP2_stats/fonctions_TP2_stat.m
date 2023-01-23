
% TP2 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Foucher de Brandois
% Prénom : Félix
% Groupe : 1SN-E

function varargout = fonctions_TP2_stat(nom_fonction,varargin)

    switch nom_fonction
        case 'tirages_aleatoires_uniformes'
            [varargout{1},varargout{2}] = tirages_aleatoires_uniformes(varargin{:});
        case 'estimation_Dyx_MV'
            [varargout{1},varargout{2}] = estimation_Dyx_MV(varargin{:});
        case 'estimation_Dyx_MC'
            [varargout{1},varargout{2}] = estimation_Dyx_MC(varargin{:});
        case 'estimation_Dyx_MV_2droites'
            [varargout{1},varargout{2},varargout{3},varargout{4}] = estimation_Dyx_MV_2droites(varargin{:});
        case 'probabilites_classe'
            [varargout{1},varargout{2}] = probabilites_classe(varargin{:});
        case 'classification_points'
            [varargout{1},varargout{2},varargout{3},varargout{4}] = classification_points(varargin{:});
        case 'estimation_Dyx_MCP'
            [varargout{1},varargout{2}] = estimation_Dyx_MCP(varargin{:});
        case 'iteration_estimation_Dyx_EM'
            [varargout{1},varargout{2},varargout{3},varargout{4},varargout{5},varargout{6},varargout{7},varargout{8}] = ...
            iteration_estimation_Dyx_EM(varargin{:});
    end

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)

    x_G = mean(x_donnees_bruitees); % moyenne des abscisse des points
    y_G = mean(y_donnees_bruitees); % moyenne des ordonnées des points

    x_donnees_bruitees_centrees = x_donnees_bruitees - x_G; % abscisses des données centrées
    y_donnees_bruitees_centrees = y_donnees_bruitees - y_G; % ordonée des données centrées

end

% Fonction tirages_aleatoires_uniformes (exercice_1.m) ------------------------
function [tirages_angles,tirages_G] = tirages_aleatoires_uniformes(n_tirages,taille)
    % n_tirages tirages uniformes dans l'intervalle [-pi/2, pi/2]
    tirages_angles = pi*(rand(n_tirages, 1)) - pi/2; 

    % Tirages aleatoires de points pour se trouver sur la droite (sur [-20,20])
    tirages_G = 2*taille*rand(n_tirages, 2) - taille;
end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)

    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    m = length(tirages_psi);
    n = length(x_donnees_bruitees_centrees);

    Psi = repmat(tirages_psi, 1, n); % Matrice formée par la colonne tirage_psi répétée n fois
    X = repmat(x_donnees_bruitees_centrees, m, 1); % Matrice formée par la ligne x_donnees_bruitees_centrees répétée m fois
    Y = repmat(y_donnees_bruitees_centrees, m, 1); % Matrice formée par la ligne y_donnees_bruitees_centrees répétée m fois

    % Les matrices Psi, X et Y sont de meme dimension (m lignes, n colonnes)

    % On calcule a avec la matrice eps : % Chaque coefficient de la matrice eps contient un couple ((X, Y) , Psi) différent
    % Entre les lignes, c'est la valeur de psi qui varie et entre les colonnes, c'est les valeurs de x et y qui varient
    eps = (Y - tan(Psi).*X).^2; 
    
    S = sum(eps, 2); % On somme toutes les colonnes de la matrice eps (on obtient une matrice colonne)
    [~, i] = min(S); % i correcpond à l'indice de la matrice S dont la valeur est la plus petite

    % On retrouve les coefficients a et b de la droite y = ax + b
    a_Dyx = tan(tirages_psi(i)); % tirages_psi(i) est la valeur de psi pour laquelle la somme calculée est la plus faible
    b_Dyx = y_G - a_Dyx*x_G; % La droite passe par le centre de gravité des points
end

% Fonction estimation_Dyx_MC (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)

    % On construit les matrices A et B
    A = [transpose(x_donnees_bruitees) ones(length(x_donnees_bruitees), 1)];
    B = transpose(y_donnees_bruitees);

    X = A\B; % X = (A'A)−1 A' B
    a_Dyx = X(1);
    b_Dyx = X(2);
end

% Fonction estimation_Dyx_MV_2droites (exercice_2.m) -----------------------------------
function [a_Dyx_1,b_Dyx_1,a_Dyx_2,b_Dyx_2] = ... 
         estimation_Dyx_MV_2droites(x_donnees_bruitees,y_donnees_bruitees,sigma, ...
         tirages_G_1,tirages_psi_1,tirages_G_2,tirages_psi_2)  

    m = size(tirages_G_1, 1);
    n = length(x_donnees_bruitees);
   

    G1_X = repmat(tirages_G_1(:, 1), 1, n); % Matrice formée par la colonne des abscisses de tirages_G_1 répétée n fois
    G1_Y = repmat(tirages_G_1(:, 2), 1, n); % Matrice formée par la colonne des ordonnées de tirages_G_1 répétée n fois
    G2_X = repmat(tirages_G_2(:, 1), 1, n); % Matrice formée par la colonne des abscisses de tirages_G_2 répétée n fois
    G2_Y = repmat(tirages_G_2(:, 2), 1, n); % Matrice formée par la colonne des ordonnées de tirages_G_2 répétée n fois
    X = repmat(x_donnees_bruitees, m, 1); % Matrice formée par la ligne x_donnees_bruitees répétée m fois
    Y = repmat(y_donnees_bruitees, m, 1); % Matrice formée par la ligne y_donnees_bruitees répétée m fois

    % Les matrices G1_X, G1_Y, G2_X, G2_Y, X et Y sont de meme dimension (m lignes, n colonnes)

    % Calcul des résidus
    R1 = (Y - G1_Y) - tan(tirages_psi_1).*(X - G1_X);
    R2 = (Y - G2_Y) - tan(tirages_psi_2).*(X - G2_X);

    D = log(exp(-(R1.^2)/(2*sigma^2)) + exp(-(R2.^2)/(2*sigma^2)));
    S = sum(D, 2);
    [~, i] = max(S); % i correcpond à l'indice de la matrice S dont la valeur est la plus grande

    a_Dyx_1 = tan(tirages_psi_1(i)); % tirages_psi_1(i) est la valeur de psi_1 pour laquelle la somme calculée est la plus forte
    a_Dyx_2 = tan(tirages_psi_2(i)); % idem pour psi_2
    b_Dyx_1 = tirages_G_1(i, 2) - a_Dyx_1*tirages_G_1(i, 1); % y = ax + b et la droite passe par le centre de gravité G1(i)
    b_Dyx_2 = tirages_G_2(i, 2) - a_Dyx_2*tirages_G_2(i, 1); % y = ax + b et la droite passe par le centre de gravité G2(i)
end

% Fonction probabilites_classe (exercice_3.m) ------------------------------------------
function [probas_classe_1,probas_classe_2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,...
                                                                 a_1,b_1,proportion_1,a_2,b_2,proportion_2)
    
    % Calcul des résidus
    R1 = y_donnees_bruitees - a_1*x_donnees_bruitees - b_1;
    R2 = y_donnees_bruitees - a_2*x_donnees_bruitees - b_2;

    probas_classe_1 = proportion_1*exp(-(R1.^2)/(2*sigma^2));
    probas_classe_2 = proportion_2*exp(-(R2.^2)/(2*sigma^2));

end

% Fonction classification_points (exercice_3.m) ----------------------------
function [x_classe_1,y_classe_1,x_classe_2,y_classe_2] = classification_points ...
              (x_donnees_bruitees,y_donnees_bruitees,probas_classe_1,probas_classe_2)

    classe_1 = probas_classe_1 > probas_classe_2;
    classe_2 = probas_classe_1 < probas_classe_2;

    % On sépare les données x et y en deux classes
    x_classe_1 = x_donnees_bruitees(classe_1);
    y_classe_1 = y_donnees_bruitees(classe_1);
    x_classe_2 = x_donnees_bruitees(classe_2);
    y_classe_2 = y_donnees_bruitees(classe_2);
end

% Fonction estimation_Dyx_MCP (exercice_4.m) -------------------------------
function [a_Dyx,b_Dyx] = estimation_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe)
    
    % On construit les matrices A et B
    A = transpose(probas_classe) .* [transpose(x_donnees_bruitees) ones(length(x_donnees_bruitees), 1)];
    B = transpose(probas_classe) .* transpose(y_donnees_bruitees);

    X = A\B; % X = (A'A)−1 A' B

    a_Dyx = X(1);
    b_Dyx = X(2); 
end

% Fonction iteration_estimation_Dyx_EM (exercice_4.m) ---------------------
function [probas_classe_1,proportion_1,a_1,b_1,probas_classe_2,proportion_2,a_2,b_2] =...
         iteration_estimation_Dyx_EM(x_donnees_bruitees,y_donnees_bruitees,sigma,...
         proportion_1,a_1,b_1,proportion_2,a_2,b_2)

    % Etape E
    [p1,p2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,a_1,b_1,proportion_1,a_2,b_2,proportion_2); 
    probas_classe_1 = p1./(p1 + p2);
    probas_classe_2 = p2./(p1 + p2);

    % Etape M
    proportion_1 = mean(probas_classe_1);
    proportion_2 = mean(probas_classe_2);
    
    % Estimation des paramètres
    [a_1, b_1] = estimation_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe_1);
    [a_2, b_2] = estimation_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe_2);    
end
