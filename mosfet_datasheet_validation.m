
%% Automotive MOSFET - Datasheet Validation
clear; clc; close all;

%% 1. Datasheet data (approximate values)

% Junction temperature [deg C]
T_data = [-40 25 60 100 140 175];

% Typical on-state resistance [mOhm]
% V_GS = 10 V, I_D = 50 A
R_data = [2.0 2.8 3.4 4.2 5.3 6.4];

%% 2. Plot datasheet data

figure;

plot(T_data, R_data, 'o-', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 7);

grid on;

xlabel('Junction Temperature [°C]');
ylabel('R_{DS(on)} [m\Omega]');

title('MOSFET On-State Resistance - Datasheet Data');
legend('Datasheet (approx.)', 'Location', 'northwest');

exportgraphics(gcf, 'mosfet_datasheet_points.png', 'Resolution', 300);
%% 3. Linear and exponential models

% Reference conditions
T_ref = 25;          % [deg C]
R_ref = 2.8;         % [mOhm], typical datasheet value
alpha = 0.004;       % [1/K], assumed coefficient

% Temperature range
T_model = -40:1:175;

% Linear model
R_linear = R_ref .* (1 + alpha .* (T_model - T_ref));

% Exponential model
R_exp = R_ref .* (1 + alpha).^(T_model - T_ref);

%% 4. Compare models with datasheet data

figure;

plot(T_data, R_data, 'ko', ...
    'MarkerSize', 8, 'LineWidth', 1.5);
hold on;

plot(T_model, R_linear, 'b-', 'LineWidth', 1.5);
plot(T_model, R_exp, 'r--', 'LineWidth', 1.5);

grid on;

xlabel('Junction Temperature [°C]');
ylabel('R_{DS(on)} [m\Omega]');
title('Datasheet vs. Linear and Exponential Models');

legend('Datasheet (approx.)', ...
       'Linear Model', ...
       'Exponential Model', ...
       'Location', 'northwest');

hold off;
exportgraphics(gcf, 'mosfet_model_validation.png', 'Resolution', 300);


%% 5. Model Error Analysis

% Evaluate both models at datasheet temperatures
R_linear_data = R_ref .* (1 + alpha .* (T_data - T_ref));

R_exp_data = R_ref .* (1 + alpha).^(T_data - T_ref);

% Calculate errors
error_linear = R_linear_data - R_data;
error_exp = R_exp_data - R_data;

% Mean Absolute Error (MAE)
MAE_linear = mean(abs(error_linear));
MAE_exp = mean(abs(error_exp));

% Root Mean Square Error (RMSE)
RMSE_linear = sqrt(mean(error_linear.^2));
RMSE_exp = sqrt(mean(error_exp.^2));

% Display results
fprintf('\n--- Model Validation Results ---\n');

fprintf('Linear Model:\n');
fprintf('MAE  = %.4f mOhm\n', MAE_linear);
fprintf('RMSE = %.4f mOhm\n\n', RMSE_linear);

fprintf('Exponential Model:\n');
fprintf('MAE  = %.4f mOhm\n', MAE_exp);
fprintf('RMSE = %.4f mOhm\n', RMSE_exp);


%% 6. Parameter Fitting - Linear Model

% Temperature difference from reference
delta_T = T_data - T_ref;

% Find optimal alpha using least squares
alpha_fit = sum(delta_T .* (R_data - R_ref)) / ...
            (R_ref * sum(delta_T.^2));

% Calculate fitted resistance
R_linear_fit = R_ref .* (1 + alpha_fit .* delta_T);

% Calculate fitted model errors
MAE_linear_fit = mean(abs(R_linear_fit - R_data));
RMSE_linear_fit = sqrt(mean((R_linear_fit - R_data).^2));

% Display results
fprintf('\n--- Parameter Fitting Results ---\n');
fprintf('Original alpha = %.6f 1/K\n', alpha);
fprintf('Fitted alpha   = %.6f 1/K\n', alpha_fit);
fprintf('Fitted MAE     = %.4f mOhm\n', MAE_linear_fit);
fprintf('Fitted RMSE    = %.4f mOhm\n', RMSE_linear_fit);


%% 7. Fitted Model Comparison

% Calculate fitted model over full temperature range
R_linear_fitted_curve = R_ref .* ...
    (1 + alpha_fit .* (T_model - T_ref));

% Create comparison figure
fig3 = figure;

plot(T_data, R_data, 'ko', ...
    'MarkerSize', 8, 'LineWidth', 1.5);
hold on;

plot(T_model, R_linear, 'b-', 'LineWidth', 1.5);

plot(T_model, R_exp, 'r--', 'LineWidth', 1.5);

plot(T_model, R_linear_fitted_curve, 'g-', ...
    'LineWidth', 2);

grid on;

xlabel('Junction Temperature [°C]');
ylabel('R_{DS(on)} [m\Omega]');

title('MOSFET Resistance - Model Fitting Comparison');

legend('Datasheet (approx.)', ...
       'Linear Model (original)', ...
       'Exponential Model (original)', ...
       'Linear Model (fitted)', ...
       'Location', 'northwest');

hold off;

% Save figure
exportgraphics(fig3, 'mosfet_fitted_model_comparison.png', ...
    'Resolution', 300);

%% 8. Parameter Fitting - Exponential Model

% Define sum of squared errors
SSE_exp = @(a) sum( ...
    (R_ref .* (1 + a).^(T_data - T_ref) - R_data).^2);

% Find best alpha
alpha_exp_fit = fminsearch(SSE_exp, alpha);

% Evaluate fitted exponential model
R_exp_fit = R_ref .* ...
    (1 + alpha_exp_fit).^(T_data - T_ref);

% Calculate errors
MAE_exp_fit = mean(abs(R_exp_fit - R_data));
RMSE_exp_fit = sqrt(mean((R_exp_fit - R_data).^2));

% Display results
fprintf('\n--- Exponential Model Fitting ---\n');
fprintf('Fitted alpha = %.6f 1/K\n', alpha_exp_fit);
fprintf('Fitted MAE   = %.4f mOhm\n', MAE_exp_fit);
fprintf('Fitted RMSE  = %.4f mOhm\n', RMSE_exp_fit);


%% 9. Final Fitted Model Comparison

% Calculate fitted exponential curve
R_exp_fitted_curve = R_ref .* ...
    (1 + alpha_exp_fit).^(T_model - T_ref);

% Create figure
fig4 = figure;

plot(T_data, R_data, 'ko', ...
    'MarkerSize', 8, 'LineWidth', 1.5);
hold on;

plot(T_model, R_linear_fitted_curve, 'b-', ...
    'LineWidth', 1.5);

plot(T_model, R_exp_fitted_curve, 'r--', ...
    'LineWidth', 2);

grid on;

xlabel('Junction Temperature [°C]');
ylabel('R_{DS(on)} [m\Omega]');

title('MOSFET Datasheet-Based Model Fitting');

legend('Datasheet (approx.)', ...
       'Fitted Linear Model', ...
       'Fitted Exponential Model', ...
       'Location', 'northwest');

hold off;

% Save final comparison figure
exportgraphics(fig4, 'mosfet_final_model_fitting.png', ...
    'Resolution', 300);


%% 10. Temperature-Dependent Conduction Losses

% Drain current
I_D = 50;  % [A]

% Convert fitted resistance from mOhm to Ohm
R_fitted_ohm = R_exp_fitted_curve * 1e-3;

% Calculate conduction losses
P_cond = I_D^2 .* R_fitted_ohm;

% Plot conduction losses
fig5 = figure;

plot(T_model, P_cond, 'r-', 'LineWidth', 2);

grid on;

xlabel('Junction Temperature [°C]');
ylabel('Conduction Power Loss [W]');

title('MOSFET Conduction Loss vs. Junction Temperature');

% Save figure
exportgraphics(fig5, 'mosfet_datasheet_conduction_loss.png', ...
    'Resolution', 300);
