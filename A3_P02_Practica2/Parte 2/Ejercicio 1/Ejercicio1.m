clear all; close all; clc;

% --- Parámetros de Simulación ---
Ts = 100e-3;
x_0 = 0; y_0 = 0; th_0 = 0;

% --- Definición del Escenario ---
refx = 5;  refy = 5;  % Objetivo
obsx = 2.5; obsy = 2.5; % Obstáculo

% --- Ejecutar Simulación ---
disp('Ejecutando simulación con obstáculo...');
sim('PositionControlFuzzyParte2.slx');
disp('Simulación finalizada.');

% --- Visualización ---
figure;
hold on; grid on;
x = salida_x.signals.values;
y = salida_y.signals.values;

plot(x, y, 'b-', 'LineWidth', 2); % Trayectoria del robot
plot(refx, refy, 'gx', 'MarkerSize', 12, 'LineWidth', 3); % Objetivo
plot(obsx, obsy, 'ro', 'MarkerSize', 10, 'LineWidth', 3, 'MarkerFaceColor', 'r'); % Obstáculo

title('Trayectoria con Evasión de Obstáculo');
xlabel('Posición X (m)'); ylabel('Posición Y (m)');
legend('Robot', 'Objetivo', 'Obstáculo');
axis equal;
hold off;