function y_pre = simPredictor(p, u, y, num_n, den_n, delay)
    den_n = den_n - 1;
    N = size(y, 1);
    y_pre = zeros(N, 1);
    initial_n = max(den_n + 1, num_n + delay);

    for n = initial_n:N
        for m=1:den_n
            y_pre(n) = y_pre(n) + p(m) * y(n-m);
        end

        for m=1:num_n
            y_pre(n) = y_pre(n) + p(m + den_n) * u(n - (m + delay - 1));
        end   
    end
end
