%==========================================================================
% CONTROL Y EVALUACIÓN DE SIMULACIÓN
%==========================================================================
clear; clc;
close all;

%% 1. INICIO DE ROS
rosshutdown
ROS_MASTER_IP = '172.22.131.230';
rosinit(ROS_MASTER_IP);

%% 2. SUSCRIPCIÓN Y ESPERA
odom = rossubscriber('/robot0/odom','nav_msgs/Odometry');
% Esperar hasta recibir datos
while isempty(odom.LatestMessage)
    pause(0.1);
end

%% 3. EJECUCIÓN DE LA SIMULACIÓN
% Ejecuta el modelo de Simulink
sim('ackerman_ROS_controller.slx');

%% 4. EVALUACIÓN
% Llama a la función de evaluación, ploteando los resultados (true)
if exist('data.mat', 'file') == 2
    evaluate_controller(true);
else
    warning('No se encontró "data.mat". Verifique la configuración de Simulink.');
end

%% 5. CIERRE DE ROS
rosshutdown;