clear;
clc;
close all;

% Infineon IAUC100N08S5N034
% Reference conduction loss calculation

R_DS_on = 3.4e-3;    % Maximum RDS(on) at specified conditions [Ohm]
I_D = 40;            % Drain current [A]

P_cond = I_D^2 * R_DS_on;

fprintf('Conduction loss: %.2f W\n', P_cond);

% Temperature model comparison

T = 25:5:150;          % Junction temperature [deg C]
T_ref = 25;            % Reference temperature [deg C]
alpha = 0.004;         % Assumed coefficient [1/K]

R_linear = R_DS_on .* (1 + alpha .* (T - T_ref));

R_exp = R_DS_on .* (1 + alpha).^(T - T_ref);

fig1 = figure;

plot(T, R_linear * 1000, 'b', 'LineWidth', 2);
hold on;
plot(T, R_exp * 1000, 'r', 'LineWidth', 2);

xlabel('Junction Temperature [deg C]');
ylabel('On-State Resistance [mOhm]');
title('MOSFET Temperature Model Comparison');

legend('Linear Model', 'Exponential Model', ...
       'Location', 'northwest');

grid on;
hold off;

exportgraphics(fig1, 'mosfet_resistance_comparison.png');

% Conduction loss comparison at constant current

P_linear = I_D^2 .* R_linear;
P_exp = I_D^2 .* R_exp;

fig2 = figure;
plot(T, P_linear, 'b', 'LineWidth', 2);
hold on;
plot(T, P_exp, 'r', 'LineWidth', 2);

xlabel('Junction Temperature [deg C]');
ylabel('Conduction Loss [W]');
title('Conduction Loss: Linear vs Exponential');

legend('Linear Model', 'Exponential Model', ...
       'Location', 'northwest');

grid on;
hold off;

exportgraphics(fig2, 'mosfet_power_loss_comparison.png');