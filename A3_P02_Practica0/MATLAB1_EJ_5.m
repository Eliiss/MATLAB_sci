% Transformadas de señales
syms k z a; % Declarar las variables simbólicas (k, z, y la constante a)
%Symbolic Math Toolbox necesita saber que k, z y a son variables simbólicas
%para poder realizar las operaciones de forma simbólica

% 1. f(k) = 2 + 5k + k^2
fk1 = 2 + 5*k + k^2;
Tz1 = ztrans(fk1, k, z); % ztrans calcula la transformada Z
disp('Transformada Z de f(k) = 2 + 5k + k^2:');
disp(Tz1);

% 2. f(k) = sin(k) * e^(-ak)
fk2 = sin(k) * exp(-a*k);
Tz2 = ztrans(fk2, k, z); % Calcula la transformada Z
disp('Transformada Z de f(k) = sin(k) * e^(-ak):');
disp(Tz2);

% 3. Dada la función de transferencia discreta 
% T(z) = (0.4*z^2) / (z^3 - z^2 + 0.1z + 0.02)
%La forma en que MATLAB representa las funciones de transferencia es usando los coeficientes del numerador y del denominador.
num_T = [0.4 0 0]; % Numerador: 0.4*z^2
den_T = [1 -1 0.1 0.02]; % Denominador
Tz = tf(num_T, den_T, 1); % Crear la función de transferencia

% b) Respuesta al impulso
figure;
subplot(2,1,1);
impulse(Tz); % Grafica la respuesta al impulso
title('Respuesta al Impulso');
xlabel('Tiempo (muestras)');
ylabel('Amplitud');
grid on;

% c) Respuesta al escalón
subplot(2,1,2);
step(Tz); % Grafica la respuesta al escalón
title('Respuesta al Escalón');
xlabel('Tiempo (muestras)');
ylabel('Amplitud');
grid on;
sgtitle('Respuesta al Impulso y Escalón de la función de Transferencia');