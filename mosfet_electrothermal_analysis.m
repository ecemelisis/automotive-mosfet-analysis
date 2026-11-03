
%% Automotive MOSFET - Electrothermal Analysis
clear; clc; close all;

%% 1. Parameters

T_ambient = 25;       % Ambient temperature [deg C]
R_thJA = 23.5;        % Thermal resistance [K/W]
I_D = 10;             % Drain current [A]

R_ref = 2.8e-3;       % Typical R_DS(on) at 25 deg C [Ohm]
T_ref = 25;           % Reference temperature [deg C]
alpha = 0.005550;     % Fitted exponential coefficient [1/K]

%% 2. Iterative electrothermal calculation

T_j = T_ambient;      % Initial junction temperature
tolerance = 1e-6;
max_iterations = 100;

for k = 1:max_iterations

    % Temperature-dependent on-state resistance
    R_DS = R_ref * (1 + alpha)^(T_j - T_ref);

    % Conduction power loss
    P_cond = I_D^2 * R_DS;

    % Updated junction temperature
    T_new = T_ambient + P_cond * R_thJA;

    % Check convergence
    if abs(T_new - T_j) < tolerance
        T_j = T_new;
        break;
    end

    T_j = T_new;
end

%% Recalculate power loss at final temperature
R_DS = R_ref * (1 + alpha)^(T_j - T_ref);
P_cond = I_D^2 * R_DS;

%% 3. Results

fprintf('\n--- Electrothermal Results ---\n');
fprintf('Drain Current: %.1f A\n', I_D);
fprintf('Junction Temperature: %.2f deg C\n', T_j);
fprintf('Conduction Loss: %.4f W\n', P_cond);
fprintf('Iterations: %d\n', k);

if k == max_iterations
    fprintf('Warning: convergence not confirmed.\n');
end


%% 4. Current Sweep - Electrothermal Analysis

I_values = 0:1:50;

T_results = NaN(size(I_values));
P_results = NaN(size(I_values));

T_limit = 175;  % Upper limit of fitted datasheet range

for n = 1:length(I_values)

    I = I_values(n);
    T = T_ambient;
    converged = false;

    for k = 1:max_iterations

        R = R_ref * (1 + alpha)^(T - T_ref);
        P = I^2 * R;
        T_new = T_ambient + P * R_thJA;

        % Stop if outside the modeled temperature range
        if ~isfinite(T_new) || T_new > T_limit
            break;
        end

        if abs(T_new - T) < tolerance
            T = T_new;
            converged = true;
            break;
        end

        T = T_new;
    end

    if converged
        T_results(n) = T;
        P_results(n) = I^2 * R_ref * ...
            (1 + alpha)^(T - T_ref);
    end
end

%% 5. Plot Junction Temperature vs. Current

fig = figure;

plot(I_values, T_results, 'b-', 'LineWidth', 2);

grid on;
xlabel('Drain Current [A]');
ylabel('Junction Temperature [°C]');
title('Electrothermal Analysis - Junction Temperature vs. Current');

yline(T_limit, 'r--', 'Model Range Limit (175 °C)');

exportgraphics(fig, 'mosfet_electrothermal_temperature.png', ...
    'Resolution', 300);


%% 6. Conduction Loss vs. Drain Current

fig2 = figure;

plot(I_values, P_results, 'r-', 'LineWidth', 2);

grid on;

xlabel('Drain Current [A]');
ylabel('Conduction Power Loss [W]');

title('Electrothermal Analysis - Conduction Loss vs. Current');

exportgraphics(fig2, 'mosfet_electrothermal_power_loss.png', ...
    'Resolution', 300);
