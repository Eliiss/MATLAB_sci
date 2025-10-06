%% REGRESIÓN con red feedforward (fitnet) – Script base 
% Objetivo:
%   - Cargar un dataset de regresión de la toolbox
%   - Crear y entrenar una MLP con una capa oculta (fitnet)
%   - Evaluar el rendimiento (MSE) y errores
%   - (Opcional) visualizar la red y curvas de entrenamiento
%
% Notas:
%   * fitnet está pensado para REGRESIÓN (salida lineal por defecto).
%   * Por defecto: capa oculta 'tansig' y capa de salida 'purelin'.
%   * La métrica por defecto es MSE (net.performFcn = 'mse').

clc; close all; clearvars; rng(42);   

%% Carga de datos de ejemplo disponibles en la toolbox
[inputs,targets] = simplefit_dataset;   % 1 entrada -> 1 salida (seno perturbado)
% [inputs,targets] = bodyfat_dataset;     % varias entradas -> % de grasa corporal

%% Creación de la red
hiddenLayerSize = 10;                     % nº de neuronas en la capa oculta (hiperparámetro)

% fitnet crea una red para REGRESIÓN:  [inputs] -> [tansig(H)] -> [linear output]
net = fitnet(hiddenLayerSize);            % net.layers{1}.transferFcn = 'tansig'; net.layers{2}.transferFcn = 'purelin'

% (Opcional) Alternativas:
% net = feedforwardnet(hiddenLayerSize);  % Similar; configurable a mano

% Algoritmo de entrenamiento (optimizador):
% Por defecto en fitnet suele ser 'trainlm' (Levenberg-Marquardt), muy rápido en problemas pequeños.
% Aquí forzamos explícitamente 'traingdm' (descenso gradiente con momento).
net.trainFcn = 'traingdm';    

% (Opcional) Otros hiperparámetros del optimizador:
%net.trainParam.lr       = 1e-2;         % tasa de aprendizaje (relevante en traingdm)
%net.trainParam.mc       = 0.01;         % momentum (traingdm)
%net.trainParam.epochs   = 1000;         % nº máx. de épocas
%net.trainParam.max_fail = 6;            % early stopping

%% División del conjunto de datos para entrenamiento, validación y test
net.divideFcn = 'dividerand';              % división aleatoria por defecto
net.divideParam.trainRatio = 70/100;      % 70% para entrenar (ajuste de pesos)
net.divideParam.valRatio   = 15/100;      % 15% para validación (early stopping)
net.divideParam.testRatio  = 15/100;      % 15% para test (evaluación final)

%% Entrenamiento de la red
% 'train' gestiona el bucle de entrenamiento, normalización de entradas (mapminmax por defecto),
% y early stopping usando el conjunto de validación.
[net,tr] = train(net,inputs,targets);

%% Inferencia
outputs = net(inputs);                    % predicción (misma forma que targets)
% outputs = sim(net, inputs);             % equivalente a la línea anterior

%% Errores y métricas
errors     = gsubtract(outputs,targets);  % error = y_pred - y_true (vector columna por muestra)
meanerror  = mean(errors)                 % media del error (puede ser ~0 por cancelación de signos)
performance = perform(net,targets,outputs) % MSE global (net.performFcn='mse')

%% Visualización (opcional)
% Curva de rendimiento por época (train/val/test):
%figure; plotperform(tr); title('Performance (MSE) por época');

% Regresión objetivo vs predicción (scatter + recta ideal):
%figure; plotregression(targets, outputs, 'Regression (All)');

% Estado del entrenamiento (gradiente, valid checks, etc.):
%figure; plottrainstate(tr);

% Visualización de la arquitectura de la red:
% view(net)

% Ploteo de los datos estimados vs targets en la regresión
figure;
plot(inputs, outputs, '+');hold on;
plot(inputs, targets,'-r'); hold off;
title('Ajuste de la regresión');
xlabel('Vector de entrada');
ylabel('Vector targets vs outputs');
