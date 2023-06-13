clc; clear; close all;

% Load data
load('dane.mat')
u_z = in;
y_z = out;

% Measurement's data parameters
Tp = 0.08; % Sampling Time
N = size(in, 1); % Number of samples
t = linspace(0, (N-1)*Tp, N); % Measurement's time vector

% Correlation analysis parameters
M = 40; % Number of samples used in correlation analysis
t_M = linspace(0, (M-1)*Tp, M); % Correlation's time vector

% Correlation
r_yu = zeros(M, 1); % Estimator of correlation between input and outpu signal
for tau=1:M
    r_yu(tau, 1) = Covar([y_z, u_z], tau - 1, false, false);
end

R_uu = zeros(M, M); % Correaltion matrix
for i=1:M
    for tau=1:M
       R_uu(tau, i) = Covar([u_z, u_z], abs(tau - i), false, false);
    end
end

% Impulse response
g_M = pinv(R_uu)*r_yu;

% Step response, by integrating impulse response
h_M = zeros(M, 1);
for n=1:M
    h_M(n, 1) = Tp*sum(g_M(1:n, 1));
end

% Continous model approximation of impulse response 
% (as first-order inertial object with delay)
% (Parameters chosen empirically)

k = 0.08; 
T = 0.3;
T0 = 2*Tp;

% Simulation
G = tf(k, [T, 1], 'inputDelay', T0);
u = ones(M, 1);
y = lsim(G, u, t_M);

% Plot input, output data
fig = figure;
fontsize(fig, 14, "points");
subplot(2, 1, 1);
plot(t, u_z);
xlabel("t[s]");
ylabel("u");
grid on;

subplot(2, 1, 2);
plot(t, y_z);
xlabel("t[s]");
ylabel("y");
grid on;


% Plot correlation analysis, model
fig = figure;
fontsize(fig, 14, "points");
plot(t_M, h_M, 'black');
hold on; plot(t_M, y, 'red--'); hold off;
grid on;

xlim([0, t_M(end)])
xlabel("t[s]")
ylabel("y")

legend('y_{corr}', 'y_m', 'Location','best', 'fontSize', 10);




