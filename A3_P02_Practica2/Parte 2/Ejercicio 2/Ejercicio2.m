%% SCRIPT PARA PROBAR LA EVASION EN SEGUIMIENTO DE TRAYECTORIA
clear all; close all; clc;

% --- Parámetros de Simulación ---
Ts = 100e-3;
x_0 = 0.1; y_0 = 0.1; th_0 = 0; % Posición inicial con desfase

% --- Definición del Escenario ---
% Coloca el obstáculo en un punto que interfiera con la trayectoria
obsx = 2; obsy = 1.5; 

% --- Ejecutar Simulación ---
disp('Ejecutando simulación de seguimiento con obstáculo...');
sim('TrajectoryControlFuzzyObs.slx');
disp('Simulación finalizada.');

% --- Visualización ---
figure;
hold on; grid on;

% Datos de trayectoria
tray_ref_x = salida_xref.signals.values;
tray_ref_y = salida_yref.signals.values;
tray_robot_x = salida_x.signals.values;
tray_robot_y = salida_y.signals.values;

plot(tray_ref_x, tray_ref_y, 'r--', 'LineWidth', 2);
plot(tray_robot_x, tray_robot_y, 'b-', 'LineWidth', 1.5);
plot(obsx, obsy, 'ro', 'MarkerSize', 10, 'LineWidth', 3, 'MarkerFaceColor', 'r');

title('Seguimiento de Trayectoria con Evasión de Obstáculo');
xlabel('Posición X (m)'); ylabel('Posición Y (m)');
legend('Trayectoria Ideal', 'Robot', 'Obstáculo');
axis equal;
hold off;