%% Script de comparación:

% Limpiar la consola:
clear;
clc;
close all;

%% Parámetros:

% Tiempo de muestreo:
Ts = 100e-3;

% Posición objetivo:
refx = 10.0;
refy = 10.0;

fprintf('=== COMPARACIÓN DE CONTROLADORES ===\n');
fprintf('Objetivo: (%.2f, %.2f) m\n\n', refx, refy);

%% Simulación del controlador original:

fprintf('Simulando controlador original...\n');
sim('PositionControl.slx');

% Extraer datos de la simulación:
x_original = salida_x.signals.values;     
y_original = salida_y.signals.values;     
t_original = salida_x.time;               

%% Simulación del neurocontrolador:

fprintf('Simulando neurocontrolador...\n');
sim('PositionControlNet.slx');

% Extraer datos de la simulación:
x_neuronal = salida_x.signals.values;     
y_neuronal = salida_y.signals.values;      
t_neuronal = salida_x.time;              

%% Ajustar longitudes por si fueran diferentes:

% Tomar el mínimo número de muestras de ambas simulaciones:
n_min = min(length(t_original), length(t_neuronal));

% Recortar ambas trayectorias a la misma longitud:
x_original = x_original(1:n_min);
y_original = y_original(1:n_min);
x_neuronal = x_neuronal(1:n_min);
y_neuronal = y_neuronal(1:n_min);

%% Calcular error entre trayectorias:

% Calcular el error de posición mediante la distancia euclídea:
error_posicion = sqrt((x_original - x_neuronal).^2 + (y_original - y_neuronal).^2);

%% Mostrar estadísticas por consola:

fprintf('\n========================================\n');
fprintf('ESTADÍSTICAS DEL ERROR:\n');
fprintf('========================================\n');
fprintf('Error de posición (distancia euclídea):\n');
fprintf('  Error medio:  %.6f m\n', mean(error_posicion));
fprintf('  Error máximo: %.6f m\n', max(error_posicion));
fprintf('  Error final:  %.6f m\n', error_posicion(end));
fprintf('========================================\n\n');

%% Crear gráficas:

figure('Name', 'Comparación de controladores', 'Position', [100, 100, 1200, 500]);

% ===== Gráfica 1: trayectorias superpuestas =====
subplot(1, 2, 1);
% Trayectoria del controlador original:
plot(x_original, y_original, 'b-', 'LineWidth', 2, 'DisplayName', 'Controlador original');
hold on;
% Trayectoria del neurocontrolador:
plot(x_neuronal, y_neuronal, 'r--', 'LineWidth', 2, 'DisplayName', 'Neurocontrolador');
% Punto de inicio:
plot(0, 0, 'ko', 'MarkerSize', 7, 'MarkerFaceColor', 'k', 'DisplayName', 'Inicio');
% Punto objetivo:
plot(refx, refy, 'rx', 'MarkerSize', 15, 'LineWidth', 3, 'DisplayName', 'Objetivo');
grid on;
xlabel('Posición X (m)', 'FontSize', 11);
ylabel('Posición Y (m)', 'FontSize', 11);
title('Trayectorias', 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);
axis equal;

% ===== Gráfica 2: error de posición =====
subplot(1, 2, 2);
% Gráfica de barras del error:
bar(1:n_min, error_posicion, 'k', 'EdgeColor', 'none');
grid on;
xlabel('Muestra (tiempo discreto)', 'FontSize', 11);
ylabel('Error (m)', 'FontSize', 11);
title('Error de posición', 'FontSize', 12, 'FontWeight', 'bold');
ylim([0, max(error_posicion)*1.1]);

% Mensaje de confirmación:
fprintf('Gráficas generadas correctamente.\n');