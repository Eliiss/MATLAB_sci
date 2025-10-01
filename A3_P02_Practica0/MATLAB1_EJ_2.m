clearvars
% Matrices y vectores. 
% Realice un script de Matlab que permita desarrollar una serie de operaciones con una matriz: 
 
% 1. El script ha de generar una matriz, cuadrada y aleatoria de tamaño indicado por el usuario. En la línea de 
% comandos se ha de visualizar el mensaje: "Indique el tamaño de la matriz". 

tam = input('Indique el tamaño de la matriz: ');
matriz_aleatoria = rand(tam); % Generar la matriz cuadrada y aleatoria 

%2. A partir de la matriz construida, el script deberá calcular y presentar por pantalla los siguientes datos:

% a) Matriz generada. 
disp('La matriz generada es:'); % mostrar matriz generada
disp(matriz_aleatoria); 

% b) Una segunda matriz formada por las columnas impares de la matriz inicial 
num_columnas = size(matriz_aleatoria, 2);  % devuelve el número de columnas
matriz_impares = matriz_aleatoria(:, 1:2:num_columnas);
disp('La matriz formada por las columnas impares es:');
disp(matriz_impares);

% c) El valor de los elementos de la diagonal de la matriz generada. 
elementos_diagonal = diag(matriz_aleatoria); % coge los elementos de la diagonal de la matriz
disp('Los elementos de la diagonal de la matriz son:');
disp(elementos_diagonal);

% d) Valor máximo, mínimo, medio y varianza de cada fila. Estos valores se han de representar gráficamente, indicando en el eje de abscisas el número de fila  
% Inicializar un vector pre-asignando el tamaño
maximos = zeros(1, size(matriz_aleatoria, 1)); % Vector fila de tamaño 1 x número de filas de la matriz generada 
minimos = zeros (1, size(matriz_aleatoria,1)); % minimos = [0 0 0] si el tam = 3
medias = zeros(1, size(matriz_aleatoria, 1));
varianzas = zeros(1,size(matriz_aleatoria,1));

for i = 1:size(matriz_aleatoria, 1) %bucle iterando por todas las filas de la matriz 
    fila = matriz_aleatoria(i, :); % selecciona en cada iteración la fila completa a ser evaluada
    maximos(i) = max(fila);  % asigna el valor máximo de la fila i al elemento i del vector
    minimos(i) = min(fila);
    medias(i) = mean(fila);
    varianzas(i) = var(fila);
end

disp('Máximos:');
disp(maximos);
disp('Mínimos:');
disp(minimos);
disp('Medias:');
disp(medias);
disp('Varianzas:');
disp(varianzas);

%subplot(filas, columnas, número_de_subgráfico)
subplot(2, 2, 1); % dividir ventana en una cuadrícula de 2 filas y 2 columnas = 4 subgráficos y en el primer subgráfico
plot(maximos, 'o-');
title('Máximo por fila');
xlabel('Fila');
ylabel('Valor');

subplot(2, 2, 2); % Subplot 2: min
plot(minimos, 'o-');
title('Mínimo por fila');
xlabel('Fila');
ylabel('Valor');

subplot(2, 2, 3); % Subplot 3: media
plot(medias, 'o-');
title('Media por fila');
xlabel('Fila');
ylabel('Valor');

subplot(2, 2, 4); % Subplot 4: varianza
plot(varianzas, 'o-');
title('Varianza por fila');
xlabel('Fila');
ylabel('Valor');

sgtitle('Análisis por Fila de la Matriz Cuadrada');