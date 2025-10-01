% Representación gráfica en 3D
% Realice un script en Matlab que dibuje sobre el área −5 ≤ 𝑥, 𝑦 ≤ 5 la superficie, la superficie en forma de malla
% y el contorno de la función:
% Z = y .* sin(pi * X ./ 10) + 5 * cos((X.^2 + Y.^2) ./ 8) + cos(X + Y) .* cos(3*X - Y);

% Variables independientes (vectores) 
x = linspace(-5, 5, 50);  % 50 puntos espaciados linealmente entre -5 y 5.
y = linspace(-5, 5, 50); 

% Malla de puntos
[X, Y] = meshgrid(x, y);  % coge los vectores x e y y crea dos matrices. Cada columna de la combinación de ambas matrices
% representa un punto en el espacio 

% Evaluar la función para cada par de cordenadas de la malla, determinan la
% "altura" 
Z = y .* sin(pi * X ./ 10) + 5 * cos((X.^2 + Y.^2) ./ 8) + cos(X + Y) .* cos(3*X - Y);
%división elemento a elemento (./) y la potencia elemento a elemento (.^) que asegura que la operación se realice
%para cada elemento de las matrices X e Y

% Crea una nueva ventana de figura
figure; 

subplot(2, 2, 1); % primer subgráfico : Superficie
surf(X, Y, Z); %surf dibuja la superficie en 3D
title('Superficie');
xlabel('x');
ylabel('y');
zlabel('z');

subplot(2, 2, 3); % tercer subgráfico : Malla
mesh(X, Y, Z); % dibuja la superficie en forma de malla= solo dibuja las líneas que conectan los puntos
title('Malla');
xlabel('x');
ylabel('y');
zlabel('z');

subplot(2, 2, 4); % cuarto subgráfico : Contorno
contourf(X, Y, Z, 20); % Dibuja las líneas de contorno con colores. 
% 20 niveles de contorno, cuanto más alto sea este valor más detalle
title('Contorno');
xlabel('x');
ylabel('y');
colorbar;  % Añade la barra de color qu muestra la escala de valores de z 
% correspondientes a los diferentes colores en el gráfico de contorno.

% Añadir un título a la figura
sgtitle('Representación 3D de la función'); 