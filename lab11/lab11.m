clc;
close all;

clc;
clear;

Ad = [0.8672 -0.0496;
      0.0836  0.9977];

Bd = [0.0836; 0.0038];

p = [0.9204+0.0597j 0.9204-0.0597j];

% Metodo de Ackermann
K = acker(Ad, Bd, p)

% Verificar os polos
eig(Ad - Bd*K)


%-------------------------------
% QUESTÃO 4

figure
plot(out.y_d.Time, out.y_d.Data, 'b')
title("Resposta do sistema ao degrau (simulado no Simulink)")
grid

figure
plot(out.x_d.Time, out.x_d.Data, 'b')
title("Estados discretos do sistema (simulado no Simulink)")
grid

figure
plot(out.u_d.Time, out.u_d.Data, 'b')
title("Entrada do sistema (simulado no Simulink)")
grid
