Ts=100e-3;
N = 5; % Numero de pruebas

figure; % Crear una unica figura para todas las trayectorias
hold on;
grid on;

fprintf('--- Iniciando Pruebas del Controlador Borroso ---\n');

for i=1:N
    refx=10*rand-5;
    refy=10*rand-5;
    
    fprintf('Prueba %d/%d: Objetivo -> (%.2f, %.2f)\n', i, N, refx, refy);

    % Ejecutar Simulacion
    sim('PositionControlFuzzy.slx')

    % Extraer los datos de la trayectoria
    x=salida_x.signals.values;
    y=salida_y.signals.values;
    
    % Calcular el error final
    pos_final_x = x(end);
    pos_final_y = y(end);
    error_final = sqrt((refx - pos_final_x)^2 + (refy - pos_final_y)^2);
    
    fprintf('  -> Posición final: (%.2f, %.2f). Error final: %.4f metros.\n', pos_final_x, pos_final_y, error_final);
    
    % Dibujar la trayectoria y el objetivo
    plot(x,y, 'LineWidth', 1.5);
    plot(refx, refy, 'kx', 'MarkerSize', 10, 'LineWidth', 2);
end

title('Trayectorias del Robot con Controlador Borroso');
xlabel('Posición X (m)');
ylabel('Posición Y (m)');
axis equal;
hold off;
legend('Objetivos', 'Location', 'best');
fprintf('--- Pruebas finalizadas ---\n');