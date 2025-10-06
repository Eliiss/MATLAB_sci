%% MLP FROM-SCRATCH para REGRESIÓN 
clc; close all; clearvars; rng(42); %generar la misma semilla

% ---------------------------
% 1) Datos de la práctica
% ---------------------------
[inputs,targets] = simplefit_dataset;   %dataset que nos da matlab ya 
[D, N] = size(inputs);
C = size(targets,1);                       
figure;
% TODO: plotear inputs vs targets
title('Función objetivo de la regresión');
xlabel('Vector de entrada');
ylabel('Vector Target');


%% ---------------------------
% 2) Partición 70/15/15
% ---------------------------
idx    = randperm(N);
nTrain = floor(0.7*N);      % TODO: porcentaje para entrenamiento (70%)
nVal = floor(0.15*N);        % TODO: porcentaje para validación (15%)
nTest  = N - nTrain -nVal ;        % TODO: porcentaje para test (15%) %el floor asegura que sea numero entero

iTrain = idx(1:nTrain); %coloco los indices que se corresponden con los datos 
iVal   = idx(nTrain+1 : nTrain+nVal);
iTest  = idx(nTrain+nVal+1 : end); %posicion de donde esta la muestra, se dicta de forma aleatoria 

Xtr = inputs(:, iTrain);  Ttr = targets(:, iTrain);
Xva = inputs(:, iVal);    Tva = targets(:, iVal);
Xte = inputs(:, iTest);   Tte = targets(:, iTest);

%% ---------------------------
% 3) Hiperparámetros y modelo
% ---------------------------
H       = 10;            % neuronas ocultas 
epochs  = 1000;          % épocas máximas
lr      = 1e-2;          % learning rate
lambda  = 0.01;          % regularización por momento (0 = sin regularización)
actName = 'tansig';      % activación oculta (fitnet usa tansig por defecto)
scale   = 1e-2;          % escala de inicialización, solo al principio
printEvery = 10;         % cada cuántas épocas se imprime el logging (M)

% Inicialización (apartado 2)
P = init_params(D, H, C, scale); %pasamos parametros de entrada y salida 

% Históricos
mseTr = zeros(1, epochs);
mseVa = zeros(1, epochs);
mseTe = zeros(1, epochs); %???

%% ---------------------------
% 4) Entrenamiento (batch completo) parte mas importante
% ---------------------------
for e = 1:epochs
    % FORWARD pass - desde la entrada propago la info hasta la salida(apartado 3)
    [Ytr, cacheTr] = forward_regression(Xtr, P, actName); %entrada xtr, la estructura de la red y el activation name
    % LOSS (apartado 5)
    mseTr(e) = mse_loss(Ytr, Ttr); 
    loss = mseTr(e);   % MSE (para el fprintf)
    
    % BACKWARD propagation - de la salida a la entrada - actaualizar los pesos segun las ecuaciones de la pag 2 final (apartado 4)
    G = backward_regression(Xtr, Ttr, Ytr, cacheTr, P, actName, lambda);
    P.W1 = P.W1 - lr*G.dW1;         % TODO: actualizar pesos capa oculta
    P.b1 = P.W1 - lr*G.db1;         % TODO: actualizar bias capa oculta
    P.W2 = P.W2 - lr*G.dW2;         % TODO: actualizar pesos capa salida
    P.b2 = P.W2 - lr*G.db2;         % TODO: actualizar bias capa salida

    % Validación y test (solo para curvas)
    [Yva, ~] = forward_regression(Xva, P, actName);
    [Yte, ~] = forward_regression(Xte, P, actName);
    mseVa(e) = mse_loss(Yva, Tva); %(apartado 5)
    mseTe(e) = mse_loss(Yte, Tte); %(apartado 5)

    % ---- Logging cada M épocas (usa MSE como "Val acc") ----
    if mod(e, printEvery) == 0 || e == 1 || e == epochs
        acc_val = mseVa(e);  % MSE validación
        fprintf('Epoch %2d | Loss = %.4f | Val acc= %.4f\n', e, loss, acc_val);
    end
end

%% ---------------------------
% 5) Evaluación final 
% ---------------------------
[Yall, ~] = forward_regression(inputs, P, actName);
errors    = Yall - targets;
meanerror = mean(errors(:));
performance = mse_loss(Yall, targets);   % MSE medio (apartado 5)

fprintf('meanerror = %.6f\n', meanerror);
fprintf('performance (MSE) = %.6f\n', performance);

%% ---------------------------
% 6) Gráfica de performance (MSE por época)
% ---------------------------
figure; 
plot(mseTr, '-',  'LineWidth',1.5); hold on;
plot(mseVa, '--', 'LineWidth',1.5);
plot(mseTe, ':',  'LineWidth',1.5);
grid on; xlabel('Época'); ylabel('MSE');
legend('Train','Val','Test','Location','best');
title('Performance (MSE) por época - MLP from scratch');

%% ---------------------------
% 7) Gráfica de inputs/targets vs inputs/Yall
% ---------------------------
figure;
plot(inputs,targets, 'r'); hold on;
plot(inoyts, Yall, '+b'); hold off;
%TODO: plotear inputs vs Yall
%TODO: plotear inputs vs targets
title('Ajuste de la regresión');
xlabel('Vector de entrada');
ylabel('Vector Target vs Estimación');

%% =======================================================================
%                          FUNCIONES LOCALES
% =======================================================================

function P = init_params(D, H, C, scale) %al poner en la cl salen los valores iniciales 
% W1: HxD, b1: Hx1 ; W2: CxH, b2: Cx1
    if nargin < 4, scale = 1e-2; end
    P.W1 = randn(H, D) * scale;     % Pesos capa oculta * scale se pone en los pesos porque funciona mejor cuando empieza por pequeñs
    P.b1 = zeros(H, 1);             % Bias capa oculta, las bias suelen empezar en 0 porqu se van menos
    P.W2 = randn(C, H) * scale;     % Pesos capa salida
    P.b2 = zeros(C, 1);             % Bias capa salida
end

function [Y, cache] = forward_regression(X, P, actName)
% X: D x N  ->  Z1=W1*X+b1 ; A1=act(Z1) ; Y=W2*A1 + b2 (lineal)
    Z1 = P.W1*X+P.b1;       % TODO: calcular combinación lineal capa oculta
    switch lower(actName)
        case 'tansig', A1 = tansig(Z1); % TODO: A1=f(Z1)
        case 'logsig', A1 = logsig(Z1);
        case 'relu',   A1 = max(0, Z1);
        case 'purelin',A1 = Z1;
        otherwise,     A1 = feval(actName, Z1);
    end
    Y = P.W2*A1+P.b2;        % TODO: calcular salida final
    cache = struct('Z1',Z1,'A1',A1); %variables intermedias que tengo que guardar 
end

function G = backward_regression(X, T, Y, cache, P, actName, lambda)
% Gradientes medios para MSE: L = mean( (Y-T).^2 )
% dL/dY = 2*(Y-T)/m
    m  = size(X,2); %tamaño del vector que entre ya sea validacion trainig etc
    A1 = cache.A1; Z1 = cache.Z1;

    dY  = (2/m)  * (Y-T);              % TODO: dY
    G.dW2 = dY * A1' + lambda*P.W2;            % TODO: dW2
    G.db2 = sum(dY, 2) + lambda*P.b2;            % TODO: db2

    dA1 = P.W2'*dY;              % TODO: dA1
    switch lower(actName)
        case 'tansig', dZ1 = dA1 .*(1 - A1.^2); % TODO: dZ1
        case 'logsig', dZ1 = dA1 .* (A1 .* (1 - A1));
        case 'relu',   dZ1 = dA1; dZ1(Z1<=0) = 0;
        case 'purelin',dZ1 = dA1;
        otherwise,     dZ1 = dA1;      % fallback
    end

    G.dW1 = dZ1 * X' + lambda*P.W1;    % TODO: dW1
    G.db1 = sum(dZ1, 2) + lambda*P.b1;    % TODO: db1
end

function m = mse_loss(Y, T)
% MSE medio por muestra y salida (independiente de dimensiones)
    C = size(T,1);
    m = mean(sum((Y-T).^2,1)/C);      % TODO: calcular MSE
end

