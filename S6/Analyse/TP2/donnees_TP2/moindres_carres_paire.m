function [parametres] = moindres_carres_paire(d,x,y1,y2,beta_0,gamma_0)

    p = length(x);
    
    % On construit les matrices A et B
    A = zeros(2*p, 2*d - 1);
    for k = 1:d-1
        A(1:p, k) = nchoosek(d, k) * x.^k .* (1-x).^(d-k);
    end
    for k = 1:d
        A(p+1:end, d - 1 + k) = nchoosek(d, k) * x.^k .* (1-x).^(d-k);
    end
    A(1:p, 2*d - 1) = x.^d;

    B = [y1 - (beta_0 * (1-x).^d); y2 - (gamma_0 * (1-x).^d)];

    parametres = A\B; % parametres = (A'A)−1 A' B

end

