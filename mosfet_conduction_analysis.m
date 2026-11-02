clear;
clc;
close all;

% Automotive MOSFET Conduction Loss Analysis
% Part 1: Constant on-state resistance model

R_DS_on = 10e-3;   % On-state resistance [Ohm]
I_D = 0:1:100;     % Drain current [A]
P_cond = I_D.^2 .* R_DS_on;

fig1 = figure;

plot(I_D, P_cond, 'b', 'LineWidth', 2);

xlabel('Drain Current I_D [A]');
ylabel('Conduction Loss P_{cond} [W]');
title('MOSFET Conduction Loss vs Drain Current');

grid on;

exportgraphics(fig1, 'mosfet_current_loss.png');

T = 25:5:150;             % Junction temperature [deg C]
T_ref = 25;               % Reference temperature [deg C]
alpha = 0.004;            % Temperature coefficient [1/K]

R_T = R_DS_on .* (1 + alpha .* (T - T_ref));

I_fixed = 40;             % Constant drain current [A]
P_T = I_fixed^2 .* R_T;

fig2 = figure;
plot(T, P_T, 'r', 'LineWidth', 2);

xlabel('Junction Temperature [deg C]');
ylabel('Conduction Loss [W]');
title('MOSFET Conduction Loss vs Temperature');
grid on;

exportgraphics(fig2, 'mosfet_temperature_loss.png');