clear all; close all; clc;

Ts = 100e-3;
x_0 = 0.1; y_0 = 0.1; th_0 = 0;

obsx = 2; obsy = 1.5;

disp('Ejecutando simulación de seguimiento con obstáculo...');
sim('TrayectoriaControlFuzzyObs.slx');
disp('Simulación finalizada.');

figure;
set(gcf, 'Color', [0.95 0.95 1]);
hold on; grid on;
set(gca, 'Color', [1 1 1]);

tray_ref_x = salida_xref.signals.values;
tray_ref_y = salida_yref.signals.values;
tray_robot_x = salida_x.signals.values;
tray_robot_y = salida_y.signals.values;

plot(tray_ref_x, tray_ref_y, '--', 'Color', [1 0.84 0], 'LineWidth', 2);
plot(tray_robot_x, tray_robot_y, '-', 'Color', [0.4 0.2 0], 'LineWidth', 2.5);
text(obsx, obsy, '❄', 'FontSize', 20, 'Color', [0.3 0.7 1], 'HorizontalAlignment', 'center');

title('Seguimiento de Trayectoria Con Obstaculo', 'FontName', 'Arial', 'FontSize', 14, 'Color', [0.8 0.2 0.2]);
xlabel('Posición X (m)', 'FontName', 'Arial', 'FontSize', 12);
ylabel('Posición Y (m)', 'FontName', 'Arial', 'FontSize', 12);
legend('Ruta Ideal', 'Ruta Real', 'FontName', 'Arial', 'FontSize', 11);
set(gca, 'FontName', 'Arial', 'FontSize', 11);
axis equal;
hold off;