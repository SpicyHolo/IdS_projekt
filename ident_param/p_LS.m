function [p] = p_LS(u, y, num_n, den_n, delay)
    N = size(u, 1);
    Phi_N = num_n + den_n;
    initial_n = max(den_n + delay, num_n + 1);
    Phi = zeros(N, Phi_N);
    
    for n = initial_n:N
        Phi_temp = zeros(1, Phi_N);

        for m=1:num_n
            Phi_temp(1, m) = y(n - m);
        end

        for m=1:den_n
            Phi_temp(1, num_n+m) = u(n - (m + delay - 1));
        end

        Phi(n, :) = Phi_temp;
    end
    
    p = pinv(Phi)*y;
end
