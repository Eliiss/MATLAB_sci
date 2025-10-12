% Transformadas de señales
syms k z a; % Declarar las variables simbólicas (k, z, y la constante a)
%Symbolic Math Toolbox necesita saber que k, z y a son variables simbólicas
%para poder realizar las operaciones de forma simbólica

% 1.Obtenga la transformada z de la siguiente función: f(k) = 2 + 5k + k^2
fk1 = 2 + 5*k + k^2;
Tz1 = ztrans(fk1, k, z); % ztrans calcula la transformada Z
disp('Transformada Z de f(k) = 2 + 5k + k^2:');
disp(Tz1);

%Represente gráficamente las señales original y transformada.

% Visualización de la señal original:
k_valores = 0:10; % Valores discretos de k
fk1_valores = subs(fk1, k, k_valores); % Sustituir k con los valores para obtener los valores de fk1
figure;
subplot(3, 1, 1);
stem(k_valores, fk1_valores, 'filled'); % 'stem'para representar datos discretos
title('Señal Original f(k) = 2 + 5k + k^2');
xlabel('k (Tiempo Discreto)');
ylabel('Amplitud');
grid on;

% Visualización de la señal transformada:
ztrans_plot1 = ezplot(Tz1); 

% 2.Obtenga la transformada z de la siguiente función: f(k) = sin(k) * e^(-ak)
fk2 = sin(k) * exp(-a*k);
Tz2 = ztrans(fk2, k, z); % Calcula la transformada Z
disp('Transformada Z de f(k) = sin(k) * e^(-ak):');
disp(Tz2);

% Visualización de la señal original:
k_valores = 0:10;
%necesitamos un valor para 'a'
a_valor = 0.1;  %valor de 'a' (constante)
fk2_valores = subs(fk2, {k, a}, {k_valores, a_valor}); % Sustituir k y a con los valores
figure;
subplot(3, 1, 1); 
stem(k_valores, fk2_valores, 'filled');
title('Señal Original f(k) = sin(k) * e^{-ak}, a = 0.1');
xlabel('k (Tiempo Discreto)');
ylabel('Amplitud');
grid on;

% Visualización de la señal transformada:
ztrans_plot2 = ezplot(Tz2); 

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