%% SEL0620 - Laboratorio 9 - Questao 1
% Projeto de dois controladores Dead-Beat de ordens nu e nu+1.
% Baseado na planta nominal utilizada no Lab 3.
% Requer Control System Toolbox.
% MATLAB R2018b ou posterior (funcao local e yline).

clear; clc; close all;
format long g;

% -------------------------------------------------------
% exercicio 1
% -----------------------------------------------------------

%% 1) Dados da planta e do enunciado
wn = 0.77;             % rad/s
zeta = 1.013;
K_planta = 1;          % Nao confundir com Kp do controle proporcional!
R = 1.17;              % Degrau de referencia (amplitude anterior)
u0_alvo = 9.45;       % Interpretacao de 'ligeiramente inferior a 9.5'

% Informe o ultimo digito do numero do grupo quando solicitado.
gamma = 0.85;

G = K_planta * tf(wn^2, [1 2*zeta*wn wn^2]);
nu = 2;  % Planta de ordem 2

fprintf('\n===== DADOS DO PROJETO =====\n');
fprintf('gamma = %.2f\n', gamma);
fprintf('Referencia R = %.5f; alvo u(0) DB(nu) = %.5f\n', R, u0_alvo);
fprintf('Planta continua G(s):\n');
disp(G);

T = 0.2241;
T0 = 3*T;

Gz = c2d(G, T0, 'zoh');
[b, a] = tfdata(Gz, 'v');

SB = sum(b);  % B(1), no sentido de avaliar B(z^-1) em z=1.

fprintf('\n===== DISCRETIZACAO =====\n');
fprintf('T0 = %.9f s\n', T0);
fprintf('fs = %.9f Hz\n', 1/T0);
fprintf('Gz = c2d(G,T0,''zoh''):\n');
disp(Gz);
fprintf('A(z^-1) = '); disp(a);
fprintf('B(z^-1) = '); disp(b);

%% 3) Dead-Beat de ordem nu = 2
% Gz = B/A, Y/R = P, U/R = Q, com P=B/SB e Q=A/SB.
P2 = b / SB;             % Coeficientes da FT desejada Y/R
Q2 = a / SB;             % Coeficientes da FT desejada U/R
DenC2 = [1 -P2(2:end)]; % 1 - P2(z^-1); P2(1) = 0
C2 = tf(Q2, DenC2, T0, 'Variable', 'z^-1');

%% 4) Dead-Beat de ordem nu+1 = 3
% H(z^-1) = gamma + (1-gamma)*z^-1.
% O fator H preserva H(1)=1 e reduz a acao inicial por gamma.
H = [gamma 1-gamma];
P3 = conv(P2, H);
Q3 = conv(Q2, H);
DenC3 = [1 -P3(2:end)];
C3 = tf(Q3, DenC3, T0, 'Variable', 'z^-1');

%% 5) Verificacao das exigencias do Lab 9
u0_2 = R*Q2(1);
u0_3 = R*Q3(1);

fprintf('\n===== DEAD-BEAT ORDEM 2 =====\n');
fprintf('P2 (Y/R): '); disp(P2);
fprintf('Q2 (U/R): '); disp(Q2);
fprintf('Numerador C2(z): '); disp(Q2);
fprintf('Denominador C2(z): '); disp(DenC2);
disp(C2);
fprintf('Acao inicial real u2(0) = %.9f\n', u0_2);

fprintf('\n===== DEAD-BEAT ORDEM 3 =====\n');
fprintf('P3 (Y/R): '); disp(P3);
fprintf('Q3 (U/R): '); disp(Q3);
fprintf('Numerador C3(z): '); disp(Q3);
fprintf('Denominador C3(z): '); disp(DenC3);
disp(C3);
fprintf('Acao inicial real u3(0) = %.9f\n', u0_3);
fprintf('Razao u3(0)/u2(0) = %.9f (exigido: %.2f)\n',u0_3/u0_2,gamma);

% ---------------------------------------------------------------
% exercicio 2
% -----------------------------------------------------------

%% 6) QUESTAO 2 - Polos de malha fechada

% Malha fechada com Dead-Beat de ordem 2
Gmf2 = feedback(Gz*C2, 1);

% Malha fechada com Dead-Beat de ordem 3
Gmf3 = feedback(Gz*C3, 1);

% Calcular os polos
polos2 = pole(Gmf2);
polos3 = pole(Gmf3);
% Calcular os zeros
zeros2 = zero(Gmf2);
zeros3 = zero(Gmf3);

% Apresentar resultados
fprintf('\n===== QUESTAO 2 =====\n');

disp('Funcao de transferencia de malha fechada - DB ordem 2:');
disp(Gmf2);

disp('Polos de malha fechada - DB ordem 2:');
disp(polos2);
disp('Zeros de malha fechada - DB ordem 2:');
disp(zeros2);

disp('Funcao de transferencia de malha fechada - DB ordem 3:');
disp(Gmf3);

disp('Polos de malha fechada - DB ordem 3:');
disp(polos3);
disp('Zeros de malha fechada - DB ordem 3:');
disp(zeros3);
