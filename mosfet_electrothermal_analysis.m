
%% Automotive MOSFET - Electrothermal Analysis
% Device: Infineon IAUC100N08S5N034
% Simplified steady-state electrothermal model

clear; clc; close all;

%% 1. Parameters

T_ambient = 25;       % Ambient temperature [deg C]
R_thJA = 23.5;        % Junction-to-ambient resistance [K/W]
I_D = 10;             % Drain current [A]

R_ref = 2.8e-3;       % Typical R_DS(on) at 25 deg C [Ohm]
T_ref = 25;           % Reference temperature [deg C]
alpha = 0.005550;     % Fitted exponential coefficient [1/K]

T_min = -40;          % Lower model temperature limit [deg C]
T_limit = 175;        % Upper model temperature limit [deg C]

tolerance = 1e-6;
max_iterations = 100;

%% 2. Single-Current Electrothermal Calculation

T_j = T_ambient;
converged_single = false;

for k = 1:max_iterations

    % Temperature-dependent on-state resistance
    R_DS = R_ref * (1 + alpha)^(T_j - T_ref);

    % Conduction power loss
    P_cond = I_D^2 * R_DS;

    % Updated junction temperature
    T_new = T_ambient + P_cond * R_thJA;

    % Check model temperature range
    if ~isfinite(T_new) || T_new < T_min || T_new > T_limit
        break;
    end

    % Check convergence
    if abs(T_new - T_j) < tolerance
        T_j = T_new;
        converged_single = true;
        break;
    end

    T_j = T_new;
end

%% 3. Single-Current Results

fprintf('\n--- Electrothermal Results ---\n');
fprintf('Drain Current: %.1f A\n', I_D);
fprintf('Iterations: %d\n', k);

if converged_single

    % Recalculate resistance and power at final temperature
    R_DS = R_ref * (1 + alpha)^(T_j - T_ref);
    P_cond = I_D^2 * R_DS;

    fprintf('Junction Temperature: %.2f deg C\n', T_j);
    fprintf('Conduction Loss: %.4f W\n', P_cond);

else
    fprintf('No valid converged solution found.\n');
end

%% 4. Current Sweep - Electrothermal Analysis

I_values = 0:1:50;

T_results = NaN(size(I_values));
P_results = NaN(size(I_values));

for n = 1:length(I_values)

    I = I_values(n);
    T = T_ambient;
    converged = false;

    for k = 1:max_iterations

        % Calculate resistance at current temperature
        R = R_ref * (1 + alpha)^(T - T_ref);

        % Calculate conduction loss
        P = I^2 * R;

        % Calculate new junction temperature
        T_new = T_ambient + P * R_thJA;

        % Stop outside model range
        if ~isfinite(T_new) || T_new < T_min || T_new > T_limit
            break;
        end

        % Check convergence
        if abs(T_new - T) < tolerance
            T = T_new;
            converged = true;
            break;
        end

        T = T_new;
    end

    % Store only valid converged results
    if converged
        T_results(n) = T;

        R_final = R_ref * (1 + alpha)^(T - T_ref);
        P_results(n) = I^2 * R_final;
    end
end

%% 5. Plot Junction Temperature vs. Current

fig1 = figure;

plot(I_values, T_results, 'b-', 'LineWidth', 2);

grid on;

xlabel('Drain Current [A]');
ylabel('Junction Temperature [deg C]');

title('Electrothermal Analysis - Junction Temperature vs. Current');

yline(T_limit, 'r--', ...
    'Model Range Limit (175 deg C)');

exportgraphics(fig1, ...
    'mosfet_electrothermal_temperature.png', ...
    'Resolution', 300);

%% 6. Plot Conduction Loss vs. Current

fig2 = figure;

plot(I_values, P_results, 'r-', 'LineWidth', 2);

grid on;

xlabel('Drain Current [A]');
ylabel('Conduction Power Loss [W]');

title('Electrothermal Analysis - Conduction Loss vs. Current');

exportgraphics(fig2, ...
    'mosfet_electrothermal_power_loss.png', ...
    'Resolution', 300);

%% 7. Simulation Summary

valid_indices = find(~isnan(T_results));

fprintf('\n--- Current Sweep Summary ---\n');

if ~isempty(valid_indices)

    last_index = valid_indices(end);

    fprintf('Highest simulated current with a valid result: %.1f A\n', ...
        I_values(last_index));

    fprintf('Corresponding junction temperature: %.2f deg C\n', ...
        T_results(last_index));

    fprintf('Corresponding conduction loss: %.4f W\n', ...
        P_results(last_index));

else
    fprintf('No valid converged results found.\n');
end

fprintf('\nNote: These results are model predictions,\n');
fprintf('not manufacturer-rated safe operating limits.\n');
