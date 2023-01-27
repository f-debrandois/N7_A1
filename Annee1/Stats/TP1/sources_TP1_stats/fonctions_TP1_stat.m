
% TP1 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Foucher de Brandois
% Prénom : Félix
% Groupe : 1SN-E

function varargout = fonctions_TP1_stat(nom_fonction,varargin)

    switch nom_fonction
        case 'tirages_aleatoires_uniformes'
            varargout{1} = tirages_aleatoires_uniformes(varargin{:});
        case 'estimation_Dyx_MV'
            [varargout{1},varargout{2}] = estimation_Dyx_MV(varargin{:});
        case 'estimation_Dyx_MC'
            [varargout{1},varargout{2}] = estimation_Dyx_MC(varargin{:});
        case 'estimation_Dorth_MV'
            [varargout{1},varargout{2}] = estimation_Dorth_MV(varargin{:});
        case 'estimation_Dorth_MC'
            [varargout{1},varargout{2}] = estimation_Dorth_MC(varargin{:});
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


% Fonction tirages_aleatoires (exercice_1.m) ------------------------------
function tirages_angles = tirages_aleatoires_uniformes(n_tirages)
    tirages_angles = pi*(rand(n_tirages, 1)) - pi/2; % n_tirages tirages uniformes dans l'intervalle [-pi/2, pi/2]
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

% Fonction estimation_Dyx_MC (exercice_2.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)

    % On construit les matrices A et B
    A = [transpose(x_donnees_bruitees) ones(length(x_donnees_bruitees), 1)];
    B = transpose(y_donnees_bruitees);

    X = A\B; % X = (A'A)−1 A' B
    a_Dyx = X(1);
    b_Dyx = X(2);
end

% Fonction estimation_Dorth_MV (exercice_3.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
         estimation_Dorth_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_theta)

    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);
    
    m = length(tirages_theta);
    n = length(x_donnees_bruitees_centrees);

    Theta = repmat(tirages_theta, 1, n); % Matrice formée par la colonne tirages_theta répétée n fois
    X = repmat(x_donnees_bruitees_centrees, m, 1); % Matrice formée par la ligne x_donnees_bruitees_centrees répétée m fois
    Y = repmat(y_donnees_bruitees_centrees, m, 1); % Matrice formée par la ligne y_donnees_bruitees_centrees répétée m fois

    % Les matrices Theta, X et Y sont de meme dimension (m lignes, n colonnes)

    eps = (cos(Theta).*X + sin(Theta).*Y).^2;
    S = sum(eps, 2);
    [~, i] = min(S);

    % On retrouve les coefficients θ et ρ de la droite x cos θ + y sin θ = ρ
    theta_Dorth = tirages_theta(i);
    rho_Dorth = x_G*cos(theta_Dorth) + y_G*sin(theta_Dorth);
end

% Fonction estimation_Dorth_MC (exercice_4.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
                 estimation_Dorth_MC(x_donnees_bruitees,y_donnees_bruitees)

    [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    % On construit la matrice C
    C = [transpose(x_donnees_bruitees_centrees) transpose(y_donnees_bruitees_centrees)];
    
    [V, D] = eig(transpose(C)*C);
    S(1) = D(1, 1); % λ1
    S(2) = D(2, 2); % λ2

    [~, i] = min(S); % i est l'indice de la valeur propre la plus petite

    Y = V(:, i); % Y est le vecteur propre associé à la valeur propre la plus petite

    % Y = [cos θ sin θ]'
    theta_Dorth = atan(Y(2)/Y(1));
    rho_Dorth = x_G*cos(theta_Dorth) + y_G*sin(theta_Dorth);
end
