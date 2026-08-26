close all

% ------------------------
% Exercicio 2
% -----------------------

% Parametros
K = 1;
wn = 0.77;
zeta = 1.013; % Sobreamortecido (zeta > 1)
R = 1.17;

% Funcao de transferencia
G = K * tf(wn^2, [1 2*zeta*wn wn^2]);

Gmf = feedback(K*G, 1);

% Largura de banda
wb = bandwidth(G);
fb = wb/(2*pi);

% Frequencia de amostragem
fs = 10 * fb;
T0 = 1/fs;

% Funcao de transferencia discreta (zero holder)
Gz = c2d(G, T0, 'zoh');

Gmfd = feedback(K*Gz, 1);

%----------------------------
% exercicio 3
% ---------------------------
figure
bode(G)
title("Diagrama de Bode - Malha aberta")
grid
%hold on
%bode(Gz)
%legend('contínuo', 'discreto')

figure
bode(Gmf)
title("Diagrama de Bode - Malha fechada")
grid
%hold on
%bode(Gmfd)
%legend('contínuo', 'discreto')

% ------------------------
% exercicio 4
% ----------------------------
wa = bandwidth(G);
wf = bandwidth(Gmf);
disp(wa);
disp(wf);

%----------------------------
% exercicio5
% -----------------------------
fa = wa/(2*pi);
fsa = 10 * fa;
T0a = 1/fsa;
disp('periodo malha aberta')
disp(T0a);

ff = wf/(2*pi);
fsf = 10 * ff;
T0f = 1/fsf;
disp('periodo malha fechada')
disp(T0f);

wsa = 10*wa;
wsf = 10*wf;
disp('frequencia rad/s malha aberta')
disp(wsa)
disp('frequencia rad/s malha fechada')
disp(wsf)
disp('frequencia Hz malha aberta')
disp(fsa);
disp('frequencia Hz malha fechada')
disp(fsf);

% ----------------------------------------
% exercicio 9
%------------------------------------------
figure
plot(out.y_c.Time, out.y_c.Data, 'b')
title("Resposta do sistema ao degrau (simulado no Simulink)")
grid

hold on;
stairs(out.y_d.Time, out.y_d.Data, 'r');
legend('Contínuo', 'Discreto')

figure
plot(out.e_c.Time, out.e_c.Data, 'b')
title("Erro do sistema ao degrau (simulado no Simulink)")
grid

hold on;
stairs(out.e_d.Time, out.e_d.Data, 'r');
legend('Contínuo', 'Discreto')

figure
plot(out.u_c.Time, out.u_c.Data, 'b')
title("Controle do sistema ao degrau (simulado no Simulink)")
grid

hold on;
stairs(out.u_d.Time, out.u_d.Data, 'r');
legend('Contínuo', 'Discreto')