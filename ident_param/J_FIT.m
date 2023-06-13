function [percent] = J_FIT(y, y_m_hat)
    N = size(y, 1);
    m_y_hat_vector = sum(y)/N * ones(N, 1);
    percent = 100*(1 - norm(y - y_m_hat)/norm(y - m_y_hat_vector));
end 