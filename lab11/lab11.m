
clc;
clear;
close all;

% Matrizes discretas do Lab 6
Ad = [0.8672 -0.0496;
      0.0836  0.9977];

Bd = [0.0836;
      0.0038];

% Polos dominantes do PID (Lab 7)
p1 = 0.9204 + 0.0597j;
p2 = 0.9204 - 0.0597j;

polos_desejados = [p1 p2];

% Calculo do ganho de realimentacao
K = place(Ad, Bd, polos_desejados);

disp('Ganho de realimentacao K:');
disp(K);

% Matriz da malha fechada
Amf = Ad - Bd*K;

% Verificacao dos polos obtidos
polos_obtidos = eig(Amf);

disp('Polos da malha fechada:');
disp(polos_obtidos);
