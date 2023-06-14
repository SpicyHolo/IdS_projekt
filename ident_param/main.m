clc; clear; close all;

% Load data
load('dane.mat')

% Remove mean value from measurement
u_z = in - mean(in);
y_z = out - mean(out);

% Measurement's data parameters
Tp = 0.08; % Sampling Time
N = size(in, 1); % Number of samples
t = linspace(0, (N-1)*Tp, N); % Measurement's time vector

% Divide data into estimation and verification
half = N/2;
t = t(1:half);

u_est = u_z(1:half);
y_est = y_z(1:half);

u_wer = u_z(half + 1:end);
y_wer = y_z(half + 1:end);

% Estymacja parametrów metodą LS
delay = 2;
max_num = 6;
max_den = 6;

models(max_num, max_den) = struct('p', [], 'jfit_pre', [], "jfit_m", [], "y_pre", [], "y_m", []);
jfit_pre_array = zeros(max_num, max_den);

fprintf("A_n\tB_n\tDelay\tJFIT_model\tJFIT_pre\n");

% Uwaga num_n to stopien licznika + 1, a den_n to stopien mianownika + 1
for num_n = 1:max_num
    for den_n = 1:max_den
        
        p = p_LS(u_est, y_est, num_n, den_n, delay);
        
        % Symulacja
        y_pre = simPredictor(p, u_wer, y_wer, num_n, den_n, delay); % predyktor (y[n-1|n])
        y_m = simModel(p, u_wer, num_n, den_n, delay); % Model estymowany (y_m)
        
        % Wskaźniki jakości
        jfit_pre = J_FIT(y_wer, y_pre);
        jfit_m = J_FIT(y_wer, y_m);
        jfit_pre_array(num_n, den_n) = jfit_pre;
        fprintf("%d\t%d\t%d\t\t%f\t%f\n", num_n - 1, den_n - 1, delay, jfit_m, jfit_pre);
        models(num_n, den_n) = struct('p', p, "jfit_pre", jfit_pre, "jfit_m", jfit_m, "y_pre", y_pre, "y_m", y_m);
    end
end

%%% Wykresy LS
figure;
hold on;
plot(t, models(3, 5).y_pre, 'black');
plot(t, y_wer, 'red'); 
plot(t, models(3, 5).y_m, 'blue');
hold off;
legend('$\hat y(n|n-1)$', '$y_{WER}$', '$y_m$',  'interpreter', 'Latex', 'Location', 'best', 'fontSize', 12);
grid on;
xlabel("t[s]");
ylabel("y");

disp("Wybrany model:")
disp(models(3, 5).jfit_pre);
disp(models(3, 5).jfit_m);
disp(models(3, 5).p);

