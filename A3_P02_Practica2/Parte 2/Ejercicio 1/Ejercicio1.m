clear all; close all; clc;

Ts = 100e-3;
x_0 = 0; y_0 = 0; th_0 = 0;

refx = 5;  refy = 5;
obsx = 3; obsy =3;

disp('Ejecutando simulación con obstáculo...');
sim('PositionControlFuzzyParte2.slx');
disp('Simulación finalizada.');

figure;
set(gcf, 'Color', [0.95 0.95 1]);
hold on; grid on;
set(gca, 'Color', [1 1 1]);

x = salida_x.signals.values;
y = salida_y.signals.values;

plot(x, y, '-', 'Color', [0.8 0.2 0.2], 'LineWidth', 3);
plot(refx, refy, 'p', 'Color', [1 0.84 0], 'MarkerSize', 18, 'LineWidth', 2, 'MarkerFaceColor', [1 0.84 0]);
text(obsx, obsy, '❄', 'FontSize', 24, 'Color', [0.3 0.7 1], 'HorizontalAlignment', 'center');

title('Trayectoria con Evasión de Obstáculo', 'FontName', 'Arial', 'FontSize', 14, 'Color', [0.8 0.2 0.2]);
xlabel('Posición X (m)', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Posición Y (m)', 'FontName', 'Arial', 'FontSize', 12);
legend('Camino', 'Estrella', 'FontName', 'Arial', 'FontSize', 11);
set(gca, 'FontName', 'Arial', 'FontSize', 11);
axis equal;
hold off;