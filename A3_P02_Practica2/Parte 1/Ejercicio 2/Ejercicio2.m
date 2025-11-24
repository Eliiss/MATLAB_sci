clear all; close all; clc;

%Inicializacion de parametros
Ts = 100e-3; % Tiempo de muestreo
x_0 = 0.1;   % Posicion inicial X (con un pequeno desfase para que no se detenga nada mas empezar)
y_0 = 0.1;   % Posicion inicial Y (con un pequeno desfase)
th_0 = 0;    % Orientacion inicial

disp('Ejecutando simulación de seguimiento de trayectoria...');
sim('TrayectoriaControlFuzzy.slx');
disp('Simulación finalizada.');

% Trayectoria generada (la que se debe seguir)
trayectoria_ref_x = salida_xref.signals.values;
trayectoria_ref_y = salida_yref.signals.values;

% Trayectoria real del robot
trayectoria_robot_x = salida_x.signals.values;
trayectoria_robot_y = salida_y.signals.values;

figure;
hold on;
grid on;

% Dibujar la trayectoria de referencia (la ideal)
plot(trayectoria_ref_x, trayectoria_ref_y, 'r--', 'LineWidth', 2);

% Dibujar la trayectoria que ha seguido el robot
plot(trayectoria_robot_x, trayectoria_robot_y, 'b-', 'LineWidth', 1.5);

title('Comparativa de Seguimiento de Trayectoria');
xlabel('Posición X (m)');
ylabel('Posición Y (m)');
legend('Trayectoria Generada (Ideal)', 'Trayectoria del Robot (Real)');
axis equal;
hold off;