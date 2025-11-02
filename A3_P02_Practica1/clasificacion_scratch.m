%% MLP FROM-SCRATCH para CLASIFICACIÓN (Ejercicio 3)
clc; close all; clearvars; rng(42);

%% ---------------------------
% 1) Datos de la práctica (Clasificación)
%% ---------------------------
[inputs,targets] = cancer_dataset; % Usamos dataset de clasificación
[D, N] = size(inputs);
C = size(targets,1); % Número de Clases (en one-hot)

%% ---------------------------
% 2) Partición 70/15/15
%% ---------------------------
idx    = randperm(N);
nTrain = floor(0.7*N);
nVal   = floor(0.15*N);
nTest  = N - nTrain - nVal;

iTrain = idx(1:nTrain);
iVal   = idx(nTrain+1 : nTrain+nVal);
iTest  = idx(nTrain+nVal+1 : end);

Xtr = inputs(:, iTrain);  Ttr = targets(:, iTrain);
Xva = inputs(:, iVal);    Tva = targets(:, iVal);
Xte = inputs(:, iTest);   Tte = targets(:, iTest);

%% ---------------------------
% 3) Hiperparámetros y modelo
%% ---------------------------
H       = 10;
epochs  = 1000;
lr      = 1e-2;
lambda  = 0.01;
actName = 'tansig'; % Activación oculta
scale   = 1e-2;
printEvery = 10;

% Inicialización (Función de Ejercicio 1)
P = init_params(D, H, C, scale);

% Históricos
lossTr = zeros(1, epochs);
accTr  = zeros(1, epochs);
accVa  = zeros(1, epochs);

%% ---------------------------
% 4) Entrenamiento (batch completo)
%% ---------------------------
for e = 1:epochs
    % FORWARD (Función de Clasificación)
    [Ytr, cacheTr] = forward_classification(Xtr, P, actName);
    % LOSS (Función de Clasificación)
    lossTr(e) = crossentropy_loss(Ytr, Ttr);
    loss = lossTr(e);
    
    % BACKWARD (Función de Clasificación)
    G = backward_classification(Xtr, Ttr, Ytr, cacheTr, P, actName, lambda);
    
    % Actualización de pesos
    P.W1 = P.W1 - lr * G.dW1;
    P.b1 = P.b1 - lr * G.db1;
    P.W2 = P.W2 - lr * G.dW2;
    P.b2 = P.b2 - lr * G.db2;

    % Validación y test
    [Yva, ~] = forward_classification(Xva, P, actName);
    [Yte, ~] = forward_classification(Xte, P, actName);
    
    % Métricas de Clasificación (Accuracy)
    accTr(e) = accuracy_cls(Ytr, Ttr);
    accVa(e) = accuracy_cls(Yva, Tva);

    if mod(e, printEvery) == 0 || e == 1 || e == epochs
        fprintf('Epoch %2d | Loss = %.4f | Train Acc= %.4f | Val Acc= %.4f\n', e, loss, accTr(e), accVa(e));
    end
end

%% ---------------------------
% 5) Evaluación final (Accuracy por partición)
%% ---------------------------
[Yhat_tr, ~] = forward_classification(Xtr, P, actName);
[Yhat_va, ~] = forward_classification(Xva, P, actName);
[Yhat_te, ~] = forward_classification(Xte, P, actName);

accTrain = accuracy_cls(Yhat_tr, Ttr);
accVal   = accuracy_cls(Yhat_va, Tva);
accTest  = accuracy_cls(Yhat_te, Tte);

Ntr = size(Ttr, 2);
Nva = size(Tva, 2);
Nte = size(Tte, 2);
accGlobal = (accTrain*Ntr + accVal*Nva + accTest*Nte) / (Ntr+Nva+Nte);

fprintf('\nFINAL | acc(train)=%.3f acc(val)=%.3f acc(test)=%.3f\n acc(global)=%.3f\n', ...
        accTrain, accVal, accTest, accGlobal);

%% ---------------------------
% 6) Gráfica de performance (Accuracy por época)
%% ---------------------------
figure; 
plot(accTr, '-',  'LineWidth',1.5); hold on;
plot(accVa, '--', 'LineWidth',1.5);
grid on; xlabel('Época'); ylabel('Accuracy');
legend('Train','Val','Location','best');
title('Accuracy por época - MLP from scratch (Clasificación)');

%% ---------------------------
% 7) Matriz de confusión (TEST)
%% ---------------------------
figure('Name', 'Confusion (Test) - From Scratch');
plotconfusion(Tte, Yte);
title(sprintf('Matriz de confusión (Test) - From Scratch (Acc=%.3f)', accTest));

%% =======================================================================
%                          FUNCIONES LOCALES
% =======================================================================

% Función de Ejercicio 1 (sin cambios)
function P = init_params(D, H, C, scale)
    if nargin < 4, scale = 1e-2; end
    P.W1 = randn(H, D) * scale;
    P.b1 = zeros(H, 1);
    P.W2 = randn(C, H) * scale;
    P.b2 = zeros(C, 1);
end

% --- NUEVA FUNCIÓN: FORWARD (Ejercicio 3) ---
function [Y_softmax, cache] = forward_classification(X, P, actName)
    % Z1 y A1 (Capa oculta) son iguales que en regresión
    Z1 = P.W1*X+P.b1;
    switch lower(actName)
        case 'tansig', A1 = tansig(Z1);
        case 'logsig', A1 = logsig(Z1);
        case 'relu',   A1 = max(0, Z1);
        case 'purelin',A1 = Z1;
        otherwise,     A1 = feval(actName, Z1);
    end
    
    % Z2 (Logits) son iguales
    Z2 = P.W2*A1+P.b2;
    
    % Capa de Salida: Softmax
    Z2_stable = Z2 - max(Z2, [], 1); % Evita overflow
    Y_softmax = softmax(Z2_stable);
    
    cache = struct('Z1',Z1,'A1',A1,'Z2',Z2);
end

% --- NUEVA FUNCIÓN: BACKWARD (Ejercicio 3) ---
function G = backward_classification(X, T, Y_softmax, cache, P, actName, lambda)
    m  = size(X,2);
    A1 = cache.A1; Z1 = cache.Z1;

    % Gradiente en la Salida (dZ2)
    % dL/dZ2 = (Y_softmax - T) / m
    dZ2 = (1/m) * (Y_softmax - T);

    % Gradientes Capa de Salida (W2, b2)
    G.dW2 = dZ2 * A1' + lambda*P.W2;
    G.db2 = sum(dZ2,2) + lambda*P.b2;

    % Retropropagación (dA1, dZ1)
    dA1 = P.W2' * dZ2;
    switch lower(actName)
        case 'tansig', dZ1 = dA1 .* (1 - A1.^2); % Derivada de tansig
        case 'logsig', dZ1 = dA1 .* (A1 .* (1 - A1));
        case 'relu',   dZ1 = dA1; dZ1(Z1<=0) = 0;
        case 'purelin',dZ1 = dA1;
        otherwise,     dZ1 = dA1;
    end

    % Gradientes Capa Oculta (W1, b1)
    G.dW1 = dZ1 * X' + lambda * P.W1;
    G.db1 = sum(dZ1,2) + lambda * P.b1;
end

% --- NUEVA FUNCIÓN: LOSS (Ejercicio 3) ---
function loss = crossentropy_loss(Y_softmax, T)
    % L = -1/N * sum(T .* log(Y_softmax))
    N = size(T, 2);
    eps = 1e-12; % Evita log(0)
    loss = -sum(T .* log(Y_softmax + eps), 'all') / N;
end

% --- NUEVA FUNCIÓN: METRIC (Ejercicio 3) ---
function acc = accuracy_cls(Y_softmax, T)
    % Accuracy: argmax(prob) vs argmax(target one-hot)
    [~, pred_idx] = max(Y_softmax, [], 1);
    [~, true_idx] = max(T, [], 1);
    acc = mean(pred_idx == true_idx);
end