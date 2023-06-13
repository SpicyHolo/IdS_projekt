function y = simModel(p, u, num_n, den_n, delay)
    N = size(u, 1);
    y = zeros(N, 1);
    initial_n = max(den_n + delay, num_n + 1);

    for n = initial_n:N
        for m=1:num_n
            y(n) = y(n) + p(m) * y(n-m);
        end

        for m=1:den_n
            y(n) = y(n) + p(m + num_n) * u(n - (m + delay - 1));
        end
    end
end