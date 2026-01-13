%
% ENTRENAMIENTO DE LA RED PARA CIRCUITO SIN OBSTÁCULOS
%

% Limpiar workspace:
clear; 
close all; 
clc;

%
% Establecer los parámetros
%

% Fichero con datos del control borroso:
matfile = 'training_data_obstaculos.mat';

% Arquitectura de la red:
neurons = [40 20 10];  

% Tiempo de muestreo:
Ts = 0.1;

% Cargar los datos y manejar errores:
S = load(matfile);
if ~isfield(S,'training_data')
error('No se encontró la variable training_data en %s', matfile);
end

training_data = S.training_data;

% Aceptar la matriz:
[r,c] = size(training_data);
if r==6
data = training_data; % 6 x N

% Trasponerla si no viene en el formato esperado:
elseif c==6
data = training_data'; % convertir a 6 x N

% Posible error:
else
error('training_data debe tener 6 filas o 6 columnas. Forma actual: %dx%d', r, c);
end

% Preparar las entradas de la red (los 4 sonar):
inputs = data(1:4, :); % 4 x N

% Preparar las salidas de la red (velocidad y ángulo):
outputs = data(5:6, :); % 2 x N

% Configurar la red:
net = feedforwardnet(neurons);
net = configure(net, inputs, outputs);
net = train(net, inputs, outputs);

% Guardar la red:
save('ackerman_net_obstaculos.mat','net');

% Generar el bloque de Simulink para sustituir al controlador borroso:
try
gensim(net, Ts);

% Manejar posibles errores:
catch
warning('No se pudo generar el bloque Simulink con gensim. Comprueba licencia/toolbox.');
end

% Imprimir un mensaje final de confirmación:
fprintf('Entrenamiento finalizado\n');