close all

% ------------------------
% Exercicio 1
% ------------------------

% Parametros
K = 1;
wn = 0.77;
zeta = 1.013; % Sobreamortecido (zeta > 1)
R = 1.17;

% Funcao de transferencia
G = K * tf(wn^2, [1 2*zeta*wn wn^2]);

% Representação em estados contínuos
[num, den] = tfdata(G,'v');
[Ac, Bc, Cc, Dc] = tf2ss(num,den);
disp("Representação em estados contínuos")

disp("Ac: ")
disp(Ac)

disp("Bc: ")
disp(Bc)

disp("Cc: ")
disp(Cc)

disp("Dc: ")
disp(Dc)

% ------------------------
% Exercicio 2
% ------------------------

% Calculo do periodo de amostragem para K = 5.8966
T0 = 0.0897;

% Espaço de espaços discreto
ss_c = ss(Ac, Bc, Cc, Dc);
ss_d = c2d(ss_c, T0);
F = ss_d.A;
H = ss_d.B;
Cd = ss_d.C;
Dd = ss_d.D;

disp("Espaço de estados discreto:")

disp("F:")
disp(F)

disp("H:")
disp(H)

disp("Cd:")
disp(Cd)

disp("Dd:")
disp(Dd)

% ------------------------
% Exercicio 3
% ------------------------

