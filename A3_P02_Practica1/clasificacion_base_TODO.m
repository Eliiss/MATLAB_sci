%% CLASIFICACIÓN con red feedforward (patternnet) – Script base 
% Objetivo:
%   - Cargar un dataset de clasificación (targets en one-hot)
%   - Crear y entrenar una MLP para reconocimiento de patrones (patternnet)
%   - Evaluar rendimiento: cross-entropy, accuracy (train/val/test)
%   - Visualizar curva de performance y matriz de confusión
%
% Notas:
%   * patternnet está pensada para CLASIFICACIÓN.
%   * Por defecto: salida con softmax y pérdida cross-entropy.
%   * Las muestras van por columnas (inputs: [Nfeatures x Nsamples]).

clc; close all; clearvars; rng(42);   % Limpia, cierra figuras y fija semilla (reproducibilidad)

%% 1) Carga de datos de ejemplo (clasificación)
% Cada columna es una muestra. 'targets' viene codificado one-hot.
[inputs, targets] = cancer_dataset;      % binaria (maligno/benigno)
%[inputs, targets] = simpleclass_dataset;    % multiclase (2 features sintéticos)

% Comprobación rápida de dimensiones
fprintf('inputs:  %d x %d (features x muestras)\n', size(inputs,1), size(inputs,2));
fprintf('targets: %d x %d (clases  x muestras)\n', size(targets,1), size(targets,2));

%% 2) Definición de la red
hiddenLayerSize = 10;                      % nº de neuronas en capa oculta (hiperparámetro)
net = patternnet(hiddenLayerSize);         % MLP para clasificación (softmax + crossentropy)

% (Opcional) Algoritmo de entrenamiento:
% net.trainFcn = 'trainscg';               % por defecto en patternnet (bueno y robusto)
% net.trainFcn = 'trainlm';                % LM: muy rápido en datasets pequeños
net.trainFcn = 'traingdm';                 % descenso gradiente con momento  

% División aleatoria 70/15/15 (train/val/test) para early stopping y evaluación final
net.divideFcn = 'dividerand';              % división aleatoria por defecto
net.divideParam.trainRatio = 0.70;
net.divideParam.valRatio   = 0.15;
net.divideParam.testRatio  = 0.15;

% (Opcional) Preprocesado de entrada (por defecto incluye 'mapminmax' y 'removeconstantrows')
% net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};

% (Opcional) Regularización de la función de pérdida (reduce sobreajuste)
% net.performParam.regularization = 0.1;   % 0..1 (equilibra error/penalización de pesos)

% (Opcional) Plots integrados (también los puedes llamar luego a mano)
net.plotFcns = {'plotperform','plottrainstate','plotconfusion','plotroc'};

%% 3) Entrenamiento
% 'train' gestiona el bucle de entrenamiento y usa 'val' para early stopping.
[net, tr] = train(net, inputs, targets);

%% 4) Inferencia y métricas
outputs = net(inputs);                     % salidas (probabilidades por clase, columnas = muestras)

% Accuracy global (one-hot -> índices de clase)
tAll   = vec2ind(targets);                % clases verdaderas  (1..C)
yAll   = vec2ind(outputs);                % clases predichas   (1..C)
accAll = mean(tAll == yAll);

% Accuracy por partición usando los índices guardados en 'tr'
iTrain = tr.trainInd; iVal = tr.valInd; iTest = tr.testInd;

tTrain = vec2ind(targets(:, iTrain));
yTrain = vec2ind(outputs(:, iTrain));
accTrain = mean(tTrain == yTrain);

tVal = vec2ind(targets(:, iVal));
yVal = vec2ind(outputs(:, iVal));
accVal = mean(tVal == yVal);

tTest = vec2ind(targets(:, iTest));
yTest = vec2ind(outputs(:, iTest));
accTest = mean(tTest == yTest);

% Pérdida global (cross-entropy) con la performFcn de la red
perfAll = perform(net, targets, outputs);

fprintf('Accuracy  |  Train: %.3f   Val: %.3f   Test: %.3f   (Global: %.3f)\n', ...
        accTrain, accVal, accTest, accAll);
fprintf('Cross-entropy (perform) global: %.4f\n', perfAll);

%% 5) Visualizaciones principales (Opcional)
% Curva de performance (pérdida) por época: train/val/test
%figure('Name','Performance');
%plotperform(tr); title('Performance (Cross-Entropy) por época');

% Matriz de confusión (Test). También puedes trazar la global si quieres.
%figure('Name','Confusion (Test)');
%plotconfusion(targets(:, iTest), outputs(:, iTest));
%title(sprintf('Matriz de confusión (Test) – Acc=%.3f', accTest));

% Curvas ROC (one-vs-all si hay varias clases)
% figure('Name','ROC (Train/Val/Test)');
% plotroc(targets(:,iTrain), outputs(:,iTrain), ...
%         targets(:,iVal),   outputs(:,iVal),   ...
%         targets(:,iTest),  outputs(:,iTest));

% Estado del entrenamiento (gradiente, validation checks, etc.)
% figure('Name','Estado de entrenamiento'); plottrainstate(tr);

% (Opcional) Visualización de la arquitectura
% view(net);
