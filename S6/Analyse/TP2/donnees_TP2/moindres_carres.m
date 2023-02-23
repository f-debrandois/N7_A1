function [parametres] = moindres_carres(d,x,y,beta_0)
    p = length(x);
    % On construit les matrices A et B
    A = zeros(p, d);
    for k = 1:d
        A(:, k) = nchoosek(d, k) * x.^k .* (1-x).^(d-k);
    end

    B = y - (beta_0 * (1-x).^d);

    parametres = A\B; % beta = (A'A)−1 A' B  

end

