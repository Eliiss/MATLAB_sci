function evaluate_controller(graficar)
% EVALUAR_CONTROLADOR Analiza el movimiento del robot en un circuito.
%   graficar: bool. Si es TRUE, genera las gráficas de análisis.

    % --- 1. CARGA Y PROCESAMIENTO DE DATOS ---
    load("./data.mat");
    
    % Buscar el primer índice donde la posición X (fila 2) es distinta de 0
    idx_inicio = find(data(2, :) ~= 0, 1, 'first');
    
    % Seguridad: si no encuentra datos (todo es 0), usa el índice 2 por defecto
    if isempty(idx_inicio)
        idx_inicio = 2;
    end
    
    % Asignar variables desde el índice encontrado hasta el final
    tiempo      = data(1, idx_inicio:end);
    pos_x       = data(2, idx_inicio:end);
    pos_y       = data(3, idx_inicio:end);
    % data(4) es theta
    vel_lineal  = data(7, idx_inicio:end);
    vel_angular = data(8, idx_inicio:end);
    
    % Conversiones y estadísticas
    vel_kmh     = vel_lineal; % Asumiendo que el dato original ya es km/h o se trata directo
    tiempo_total = tiempo(end) - tiempo(1);
    
    v_max = max(vel_kmh);   v_min = min(vel_kmh);   v_media = mean(vel_kmh);
    w_max = max(vel_angular); w_min = min(vel_angular); w_media = mean(vel_angular);

    % --- 2. GEOMETRÍA DEL CIRCUITO ---
    ancho_mapa   = 161.28;
    alto_mapa    = 81.18;
    ancho_carril = 4.5;
    num_puntos   = 250;
    
    ancho_pista  = 2 * ancho_carril;
    mitad_pista  = ancho_pista / 2;
    radio_curva  = alto_mapa/2 - mitad_pista;
    long_recta   = ancho_mapa - 2*radio_curva - ancho_pista;
    
    centro_y_curva = radio_curva + mitad_pista;
    centro_x_curva = radio_curva + mitad_pista; 
    
    % Generación de puntos de la línea central
    ang_izq = linspace(pi/2, 3*pi/2, num_puntos);
    ang_der = linspace(-pi/2, pi/2, num_puntos);
    
    % Curva Izquierda
    x_curva_izq = radio_curva * cos(ang_izq) + centro_x_curva;
    y_curva_izq = radio_curva * sin(ang_izq) + centro_y_curva;
    
    % Recta Inferior
    x_recta_ini = radio_curva + mitad_pista; 
    x_recta_fin = radio_curva + long_recta + mitad_pista; 
    x_recta_inf = linspace(x_recta_ini, x_recta_fin, num_puntos);
    y_recta_inf = (centro_y_curva - radio_curva) * ones(1, num_puntos);
    
    % Curva Derecha
    x_curva_der = radio_curva * cos(ang_der) + centro_x_curva + long_recta;
    y_curva_der = radio_curva * sin(ang_der) + centro_y_curva;
    
    % Recta Superior
    x_recta_sup = linspace(x_recta_fin, x_recta_ini, num_puntos);
    y_recta_sup = (centro_y_curva + radio_curva) * ones(1, num_puntos);
    
    % Concatenación de la pista completa
    x_centro_pista = [x_curva_izq, x_recta_inf, x_curva_der, x_recta_sup];
    y_centro_pista = [y_curva_izq, y_recta_inf, y_curva_der, y_recta_sup];
    
    % Cálculo de vectores normales para los bordes
    dx = gradient(x_centro_pista);
    dy = gradient(y_centro_pista);
    norm_x =  dy ./ hypot(dx, dy);
    norm_y = -dx ./ hypot(dx, dy);
    
    % Coordenadas de bordes exterior e interior
    x_exterior = x_centro_pista + mitad_pista * norm_x;
    y_exterior = y_centro_pista + mitad_pista * norm_y;
    x_interior = x_centro_pista - mitad_pista * norm_x;
    y_interior = y_centro_pista - mitad_pista * norm_y;

    % --- 3. EVALUACIÓN DE INVASIÓN DE CARRIL ---
    distancia_signo = zeros(size(pos_x));
    
    for i = 1:length(pos_x)
        % Distancia euclídea al punto más cercano del eje central
        d2 = (pos_x(i) - x_centro_pista).^2 + (pos_y(i) - y_centro_pista).^2;
        [~, idx] = min(d2);
        
        % Producto punto para determinar el signo (invasión)
        vec_x = pos_x(i) - x_centro_pista(idx);
        vec_y = pos_y(i) - y_centro_pista(idx);
        distancia_signo(i) = vec_x * norm_x(idx) + vec_y * norm_y(idx);
    end
    
    % Detección: si la distancia es negativa (con margen 0.5), invade carril opuesto
    en_contrario = distancia_signo < 0.5;
    
    delta_t = median(diff(tiempo));
    tiempo_invasion = sum(en_contrario) * delta_t;
    porc_invasion   = 100 * tiempo_invasion / tiempo_total;

    % Reporte en consola
    fprintf('\n========================================\n');
    fprintf('   EVALUACIÓN DE RENDIMIENTO\n');
    fprintf('========================================\n');
    fprintf('Tiempo total: %.2f s\n', tiempo_total);
    fprintf('Tiempo en carril contrario: %.2f s (%.1f%%)\n', tiempo_invasion, porc_invasion);

    % --- 4. VISUALIZACIÓN ---
    if nargin < 1 || graficar == true
        % Configuración de colores
        c_trayectoria = [0.35 0.6 0.9];
        c_vel         = [0.9 0.7 0.3];
        c_giro        = [0.4 0.7 0.9];
        
        % FIGURA 1: Dashboard de estadísticas
        figure('Name','Analisis Movimiento','NumberTitle','off','Color','w');
        tiledlayout(3,2,'Padding','compact','TileSpacing','compact');
        
        % (1) Trayectoria XY simple
        nexttile([2 1])
        plot(pos_x, pos_y, '-', 'Color', c_trayectoria, 'LineWidth', 2); hold on;
        plot(pos_x(1), pos_y(1), 'o', 'MarkerFaceColor', [0.6 0.9 0.6], 'MarkerEdgeColor', 'none');
        plot(pos_x(end), pos_y(end), 'o', 'MarkerFaceColor', [0.9 0.6 0.6], 'MarkerEdgeColor', 'none');
        xlabel('Posición X [m]'); ylabel('Posición Y [m]');
        title(sprintf('Trayectoria (Total: %.2f s)', tiempo_total));
        axis equal; grid on; box on; legend('Ruta','Inicio','Fin','Location','best');
        
        % (2) Velocidad lineal
        nexttile
        plot(tiempo, vel_kmh, '-', 'Color', c_vel, 'LineWidth', 1.8);
        xlabel('Tiempo [s]'); ylabel('Velocidad [km/h]');
        title('Evolución de Velocidad Lineal');
        grid on; box on; ylim([0 50]); xlim([tiempo(1) tiempo(end)]);
        
        % (3) Velocidad angular (giro)
        nexttile
        plot(tiempo, vel_angular, '-', 'Color', c_giro, 'LineWidth', 1.8);
        xlabel('Tiempo [s]'); ylabel('Giro [grados]');
        title('Evolución del Giro');
        grid on; box on; ylim([-90 90]); xlim([tiempo(1) tiempo(end)]);
        
        % (4) Resumen numérico
        nexttile([1 2])
        axis off; xlim([0 1]); ylim([0 1]);
        text(0.05, 0.70, 'Estadísticas:', 'FontSize', 11, 'FontWeight', 'bold');
        text(0.10, 0.45, sprintf('Velocidad [km/h] -> Max: %.2f | Min: %.2f | Media: %.2f', v_max, v_min, v_media), 'FontSize', 10);
        text(0.10, 0.25, sprintf('Giro [grados]      -> Max: %.2f | Min: %.2f | Media: %.2f', w_max, w_min, w_media), 'FontSize', 10);
        rectangle('Position',[0 0 1 1],'EdgeColor',[0.9 0.9 0.9],'LineWidth',1.2);
        sgtitle('Análisis del Movimiento del Robot','FontWeight','bold','FontSize',14);
        
        % FIGURA 2: Mapa del circuito detallado
        figure('Name','Mapa del Circuito','Color', 'w', 'Position', [100 100 1200 600]);
        hold on; axis equal; grid on; box on;
        
        % Dibujo de bordes y centro
        plot(x_exterior, y_exterior, '-', 'Color', [0 0 0], 'LineWidth', 4);
        plot(x_centro_pista, y_centro_pista, '--', 'Color', [0.2 0.8 0.2], 'LineWidth', 1.5);
        plot(x_interior, y_interior, '-', 'Color', [0 0 0], 'LineWidth', 2);
        
        % Relleno visual de la pista
        fill([x_exterior, fliplr(x_interior)], [y_exterior, fliplr(y_interior)], ...
             [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
             
        % Trayectoria del robot
        plot(pos_x, pos_y, '-', 'Color', [0.2 0.4 0.8], 'LineWidth', 1.5, 'DisplayName', 'Trayectoria');
        
        % Marcadores de infracción
        scatter(pos_x(en_contrario), pos_y(en_contrario), 20, [0.9 0.2 0.2], 'filled', 'DisplayName', 'Invasión Carril');
       
        hold off;
    end
end
