%%
clear all
close all
bdclose('all');
%Tiempo de muestreo 
Ts=100e-3;

% Referencia de posicion
refx=10*rand-5;
refy=10*rand-5;
% % Posicion y orientacion inicial robot
x0=0;
y0=0;
th0=0;

sim('PositionControlFuzzy.slx')
x=salida_x.signals.values;
y=salida_y.signals.values;

% Visualizacion
figure;
subplot(2,2,[1,2]);
hold on;
plot(x0,y0,'go',refx,refy,'ro');
plot(x,y);
title('PositionControlFuzzy')
grid on;
%axis equal
hold off;
subplot(2,2,3);
plot(E_d.signals.values);
title('E_d')
grid on;
subplot(2,2,4);
plot(E_theta.signals.values)
title('E_{theta}')

%%
clear all
close all
bdclose('all');

Ts=100e-3;
x0=0;
y0=0;
th0=0;
x_0=0.5;
y_0=0.5;
th_0=0.1;

sim('TrajectoryControl_Fuzzy',10)
x=salida_x.signals.values;
y=salida_y.signals.values;
xgt=x_ref.signals.values;
ygt=y_ref.signals.values;























