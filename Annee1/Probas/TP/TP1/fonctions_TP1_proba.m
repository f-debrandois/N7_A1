
% TP1 de Probabilites : fonctions a completer et rendre sur Moodle
% Nom : de Brandois
% Prénom : Félix
% Groupe : 1SN-E

function varargout = fonctions_TP1_proba(nom_fonction, varargin)

    switch nom_fonction
        case 'G_et_R_moyen'
            [varargout{1},varargout{2},varargout{3}] = G_et_R_moyen(varargin{:});
        case 'tirages_aleatoires_uniformes'
            [varargout{1},varargout{2}] = tirages_aleatoires_uniformes(varargin{:});
        case 'estimation_C'
            varargout{1} = estimation_C(varargin{:});
        case 'estimation_C_et_R'
            [varargout{1},varargout{2}] = estimation_C_et_R(varargin{:});
        case 'occultation_donnees'
            [varargout{1},varargout{2}] = occultation_donnees(varargin{:});
    end

end

% Fonction G_et_R_moyen (exercice_0.m) ------------------------------------
function [G, R_moyen, distances] = G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)
    x_moyen = mean(x_donnees_bruitees);
    y_moyen = mean(y_donnees_bruitees);
    G = [x_moyen y_moyen];

    distances = sqrt((x_donnees_bruitees - x_moyen).^2 + (y_donnees_bruitees - y_moyen).^2);
    R_moyen = mean(distances);
end

% Fonction tirages_aleatoires (exercice_1.m) ------------------------------
function [tirages_C,tirages_R] = tirages_aleatoires_uniformes(n_tirages,G,R_moyen)
    tirages_C = 2*R_moyen*(rand(n_tirages, 2) - 0.5) + repmat(G, n_tirages, 1);
    tirages_R = R_moyen*(rand(n_tirages, 1)+0.5);
end

% Fonction estimation_C (exercice_1.m) ------------------------------------
function C_estime = estimation_C(x_donnees_bruitees,y_donnees_bruitees,tirages_C,R_moyen)
    X_c = repmat(tirages_C(:, 1), 1, length(x_donnees_bruitees));
    Y_c = repmat(tirages_C(:, 2), 1, length(x_donnees_bruitees));
    X = repmat(x_donnees_bruitees, size(tirages_C, 1), 1);
    Y = repmat(y_donnees_bruitees, size(tirages_C, 1), 1);

    D = sqrt((X-X_c).^2 + (Y-Y_c).^2);
    eps = (D - R_moyen).^2;
    S = sum(eps, 2);
    [m, i] = min(S);
    C_estime = tirages_C(i, :);
end

% Fonction estimation_C_et_R (exercice_2.m) -------------------------------
function [C_estime, R_estime] = estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,tirages_C,tirages_R)

    X_c = repmat(tirages_C(:, 1), 1, length(x_donnees_bruitees));
    Y_c = repmat(tirages_C(:, 2), 1, length(x_donnees_bruitees));
    X = repmat(x_donnees_bruitees, size(tirages_C, 1), 1);
    Y = repmat(y_donnees_bruitees, size(tirages_C, 1), 1);

    D = sqrt((X-X_c).^2 + (Y-Y_c).^2);
    eps = (D - repmat(tirages_R, 1, length(x_donnees_bruitees))).^2;
    S = sum(eps, 2);
    [~, i] = min(S);
    C_estime = tirages_C(i, :);
    R_estime = tirages_R(i);
end

% Fonction occultation_donnees (donnees_occultees.m) ----------------------
function [x_donnees_bruitees_visibles, y_donnees_bruitees_visibles] = ...
         occultation_donnees(x_donnees_bruitees, y_donnees_bruitees, ...
                             theta_donnees_bruitees, theta_1, theta_2)
    


end

