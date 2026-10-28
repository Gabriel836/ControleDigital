%% SEL0620 - Laboratorio 9 - Questao 1
% Projeto de dois controladores Dead-Beat de ordens nu e nu+1.
% Baseado na planta nominal utilizada no Lab 3.
% Requer Control System Toolbox.
% MATLAB R2018b ou posterior (funcao local e yline).

clc; close all;
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
u0_2 = R*Q2(1);
u0_3 = gamma*R*Q2(1);
q0_3 = u0_3;
q1_3 = u0_3*(a(2) - 1) + 1/SB;
q2_3 = u0_3*(a(3) - a(2)) + a(2)/SB;
q3_3 = a(2)*(-q0_3 + 1/SB);

p1_3 = q0_3*b(2);
p2_3 = q0_3*(b(3) - b(2)) + b(2)/SB;
p3_3 = b(3)*(-q0_3 +1/SB);

DenC3 = [1 -p1_3 -p2_3 -p3_3];
P3 = [0 p1_3 p2_3 p3_3];
Q3 = [q0_3 q1_3 q2_3 q3_3];
C3 = tf(Q3, DenC3, T0, 'Variable', 'z^-1');

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

% ------------------------------------------------
% exercicio 3
% -------------------------------------------------

figure
stairs(out.ydb2.Time, out.ydb2.Data, 'b')
title("Resposta do sistema ao degrau (v)")
grid

figure
stairs(out.edb2.Time, out.edb2.Data, 'b')
title("Erro do sistema ao degrau (v)")
grid

figure
stairs(out.udb2.Time, out.udb2.Data, 'b')
title("Controle do sistema ao degrau (v)")
grid

figure
stairs(out.ydb3.Time, out.ydb3.Data, 'b')
title("Resposta do sistema ao degrau (v+1)")

grid

figure
stairs(out.edb3.Time, out.edb3.Data, 'b')
title("Erro do sistema ao degrau (v+1)")
grid

figure
stairs(out.udb3.Time, out.udb3.Data, 'b')
title("Controle do sistema ao degrau (v+1)")
grid

% ---------------------------------------------------------------
% QUESTAO 4 e QUESTAO 5 - Análise dos dados do Simulink
% --------------------------------------------------------------
% Instante em que o disturbio eh aplicado (Tabela 1)
t1 = 12;

% Erro em regime permanente ANTES do disturbio (v)
% Pega o ultimo instante de e_c antes de t1
idx_antes_2 = find(out.edb2.Time < t1, 1, 'last');
ess_antes_2 = out.edb2.Data(idx_antes_2);

% Erro em regime permanente ANTES do disturbio (v+1)
idx_antes_3 = find(out.edb3.Time < t1, 1, 'last');
ess_antes_3 = out.edb3.Data(idx_antes_3);

% Erro em regime permanente APOS o disturbio (continuo)
% Pega o ultimo instante da simulacao (fim, t = 24s)
ess_depois_2 = out.edb2.Data(end);

% Erro em regime permanente APOS o disturbio (discreto)
ess_depois_3 = out.edb3.Data(end);

disp('Erro absoluto em regime permanente ANTES do disturbio (v):')
disp(ess_antes_2)
disp('Erro absoluto em regime permanente ANTES do disturbio (v+1):')
disp(ess_antes_3)
disp('Erro absoluto em regime permanente APOS o disturbio (v):')
disp(ess_depois_2)
disp('Erro absoluto em regime permanente APOS o disturbio (v+1):')
disp(ess_depois_3)

% Erros em porcentagem em relacao ao degrau de referencia r
disp('Erro percentual ANTES do disturbio (v):')
disp(100*ess_antes_2/R)
disp('Erro percentual ANTES do disturbio (v+1):')
disp(100*ess_antes_3/R)
disp('Erro percentual APOS o disturbio (v):')
disp(100*ess_depois_2/R)
disp('Erro percentual APOS o disturbio (v+1):')
disp(100*ess_depois_3/R)

%% QUESTAO 5: Tempo de Subida, Tempo de Acomodação (2%) e Sobresinal
% Análise feita no trecho ANTES do distúrbio
t2 = out.ydb2.Time;
y2 = out.ydb2.Data;
t3 = out.ydb3.Time;
y3 = out.ydb3.Data;

% Instante em que o distúrbio entra
t_dist = 12;

% Selecionar apenas a resposta ANTES do distúrbio
idx2 = t2 < t_dist;
idx3 = t3 < t_dist;

t_antes2 = t2(idx2);
y_antes2 = y2(idx2);
t_antes3 = t3(idx3);
y_antes3 = y3(idx3);

%% Estimar valor de regime permanente antes do distúrbio
% média dos últimos 10 pontos antes de t = 12 s
N2 = min(10, length(y_antes2));
yss2 = mean(y_antes2(end-N2+1:end));
N3 = min(10, length(y_antes3));
yss3 = mean(y_antes3(end-N3+1:end));

%% Calcular características da resposta
info2 = stepinfo(y_antes2, t_antes2, yss2, ...
    'RiseTimeLimits', [0.1 0.9], ...
    'SettlingTimeThreshold', 0.02);
info3 = stepinfo(y_antes3, t_antes3, yss3, ...
    'RiseTimeLimits', [0.1 0.9], ...
    'SettlingTimeThreshold', 0.02);
tr2 = info2.RiseTime;
ts2 = info2.SettlingTime;
mp2_pct = info2.Overshoot;
tr3 = info3.RiseTime;
ts3 = info3.SettlingTime;
mp3_pct = info3.Overshoot;

%% Cálculo manual do pico e sobresinal absoluto
y_max2 = max(y_antes2);
mp2_abs = max(0, y_max2 - yss2); % Amplitude acima do valor de regime

y_max3 = max(y_antes3);
mp3_abs = max(0, y_max3 - yss3);

%% Mostrar resultados

fprintf('Valor de regime permanente yss = %.4f V\n', yss2);
fprintf('Tempo de subida tr = %.4f s\n', tr2);
fprintf('Tempo de acomodacao ts (2%%) = %.4f s\n', ts2);
fprintf('Valor de pico (y_max2):           %.4f V\n', y_max2);
fprintf('Sobresinal absoluto:             %.4f V\n', mp2_abs);
fprintf('Sobresinal percentual (Mp%%):     %.2f %%\n', mp2_pct);
fprintf('Valor de regime permanente yss = %.4f V\n', yss3);
fprintf('Tempo de subida tr = %.4f s\n', tr3);
fprintf('Tempo de acomodacao ts (2%%) = %.4f s\n', ts3);
fprintf('Valor de pico (y_max3):           %.4f V\n', y_max3);
fprintf('Sobresinal absoluto:             %.4f V\n', mp3_abs);
fprintf('Sobresinal percentual (Mp%%):     %.2f %%\n', mp3_pct);