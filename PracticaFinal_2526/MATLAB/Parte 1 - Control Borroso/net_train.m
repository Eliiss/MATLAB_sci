% train_ackerman_mejorado.m
clear; close all; clc;

% --- Parámetros ---
matfile = 'training_data_v2.mat';
% Arquitectura más profunda para captar mejor las curvas
neurons = [30 15 5];   
Ts = 0.1;

% --- 1) Cargar datos ---
S = load(matfile);
% Usamos la variable training_data como pides
training_data = S.training_data; 

[r,c] = size(training_data);
if r==6, data = training_data; else data = training_data'; end

% --- 2) Preparar inputs/outputs ---
inputs  = data(1:4, :);   
outputs = data(5:6, :);   

% --- TRUCO: Refuerzo de Curvas (Para que gire de verdad) ---
% Buscamos dónde el giro es mayor a 0.2 (está girando)
idx_giro = find(abs(outputs(2,:)) > 0.2);
% Duplicamos esos datos 4 veces para que la red les de importancia
inputs_final = [inputs, inputs(:,idx_giro), inputs(:,idx_giro), inputs(:,idx_giro)];
outputs_final = [outputs, outputs(:,idx_giro), outputs(:,idx_giro), outputs(:,idx_giro)];

% --- 3) Generar la red con Algoritmo Bayesiano ---
net = feedforwardnet(neurons, 'trainbr'); 

% --- 4) Configurar y entrenar ---
% MATLAB normaliza internamente por defecto (aunque no lo veas),
% esto ayuda a que el giro (-1,1) pese igual que la velocidad (0,40).
net = configure(net, inputs_final, outputs_final);
net.trainParam.epochs = 500; % Dale tiempo a aprender
net = train(net, inputs_final, outputs_final);

% --- 5) Guardar ---
save('ackerman_net_simple.mat','net');

% --- 6) Generar bloque ---
gensim(net, Ts);
fprintf('Entrenamiento finalizado con refuerzo de curvas.\n');