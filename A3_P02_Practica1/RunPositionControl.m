%
% APARTADO C
%
fprintf("Apartado C\n");
%Tiempo de muestreo 
Ts=100e-3;  
% Referencia x-y de posicion 
refx=2.0;     
refy=2.0; 
% Ejecutar Simulacion 
sim('PositionControl.slx')

%
% APARTADO D
%
fprintf("Apartado D\n");
% Mostrar 
x=salida_x.signals.values; 
y=salida_y.signals.values; 
figure; 
plot(x,y); 
grid on; 
hold on;  

%
% APARTADO E
%

fprintf("Apartado E\n");
% Generar N posiciones aleatorias, simular y guardar en variables 
N=30; 
E_d_vec=[]; 
E_theta_vec=[]; 
V_vec=[]; 
W_vec=[]; 
for i=1:N 
refx=10*rand-5; 
refy=10*rand-5; 
sim('PositionControl.slx') 
E_d_vec=[E_d_vec;E_d.signals.values]; 
E_theta_vec=[E_theta_vec;E_theta.signals.values]; 
V_vec=[V_vec; V.signals.values]; 
W_vec=[W_vec; W.signals.values]; 
end 
inputs=[E_d_vec'; E_theta_vec']; 
outputs=[V_vec'; W_vec']; 

%
% APARTADO F
%
fprintf("Apartado F\n");
% Entrenar red neuronal con 10 neuronas en la capa oculta 
net = feedforwardnet(9); 
net = configure(net,inputs,outputs); 
net = train(net,inputs,outputs); 

%%
% APARTADO G
%

% Generar bloque de Simulink con el controlador neuronal 
gensim(net,Ts) 
