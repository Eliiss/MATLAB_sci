clear; close all; clc;

% --- Parámetros ---

matfile = 'training_data_v2.mat';

neurons = [20 10]; % cambiar por la arquitectura deseada

Ts = 0.1; % periodo para gensim (si se desea generar bloque)

% --- 1) Cargar datos ---

S = load(matfile);

if ~isfield(S,'training_data')

error('No se encontró la variable training_data en %s', matfile);

end

training_data = S.training_data;

% Aceptar 6xN o N x 6

[r,c] = size(training_data);

if r==6

data = training_data; % 6 x N

elseif c==6

data = training_data'; % convertir a 6 x N

else

error('training_data debe tener 6 filas o 6 columnas. Forma actual: %dx%d', r, c);

end

% --- 2) Preparar inputs/outputs (sin normalizar, tal y como pide el enunciado) ---

inputs = data(1:4, :); % 4 x N (sonares 0..3)

outputs = data(5:6, :); % 2 x N (velocidad; angulo volante)

% --- 3) Generar la red ---

net = feedforwardnet(neurons);

% --- 4) Configurar y entrenar (tal y como en el enunciado) ---

net = configure(net, inputs, outputs);

net = train(net, inputs, outputs);

% --- 5) Guardar red entrenada ---

save('ackerman_net_simple.mat','net');

% --- 6) (Opcional) generar bloque Simulink ---

try

gensim(net, Ts);

catch

warning('No se pudo generar el bloque Simulink con gensim. Comprueba licencia/toolbox.');

end

fprintf('Entrenamiento finalizado. Red guardada en ackerman_net_simple.mat\n');