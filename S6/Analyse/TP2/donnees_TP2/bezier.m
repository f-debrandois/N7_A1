function [Y] = bezier(x, param)
    p = length(x);
    d = length(param) - 1;

    A = zeros(p, d);
    for k = 0:d
        A(:, k+1) = nchoosek(d, k) * x.^k .* (1-x).^(d-k);
    end
    Y = A*param;
end

