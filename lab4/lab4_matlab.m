close all

% ------------------------
% Exercicio 2
% -----------------------

% Parametros
K = 5.8966;
wn = 0.77;
zeta = 1.013; % Sobreamortecido (zeta > 1)
R = 1.17;

% Funcao de transferencia
G = K * tf(wn^2, [1 2*zeta*wn wn^2]);

Gmf = feedback(K*G, 1);

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
disp("Largura de banda malha aberta: ")
disp(wa);
disp("Largura de banda malha fechada: ")
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
% exercicio 9 e 10
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

% ------------------------
% exercicio 11
% ------------------------

% Instante em que o disturbio eh aplicado (Tabela 1)
t1 = 12;

% Erro em regime permanente ANTES do disturbio (continuo)
% Pega o ultimo instante de e_c antes de t1
idx_antes_c = find(out.e_c.Time < t1, 1, 'last');
ess_antes_c = out.e_c.Data(idx_antes_c);

% Erro em regime permanente ANTES do disturbio (discreto)
idx_antes_d = find(out.e_d.Time < t1, 1, 'last');
ess_antes_d = out.e_d.Data(idx_antes_d);

% Erro em regime permanente APOS o disturbio (continuo)
% Pega o ultimo instante da simulacao (fim, t = 24s)
ess_depois_c = out.e_c.Data(end);

% Erro em regime permanente APOS o disturbio (discreto)
ess_depois_d = out.e_d.Data(end);

disp('Erro absoluto em regime permanente ANTES do disturbio (continuo):')
disp(ess_antes_c)
disp('Erro absoluto em regime permanente ANTES do disturbio (discreto):')
disp(ess_antes_d)
disp('Erro absoluto em regime permanente APOS o disturbio (continuo):')
disp(ess_depois_c)
disp('Erro absoluto em regime permanente APOS o disturbio (discreto):')
disp(ess_depois_d)

% Erros em porcentagem em relacao ao degrau de referencia r
disp('Erro percentual ANTES do disturbio (continuo):')
disp(100*ess_antes_c/R)
disp('Erro percentual ANTES do disturbio (discreto):')
disp(100*ess_antes_d/R)
disp('Erro percentual APOS o disturbio (continuo):')
disp(100*ess_depois_c/R)
disp('Erro percentual APOS o disturbio (discreto):')
disp(100*ess_depois_d/R)

% ---------------------------------------
% exercicio 12
% ------------------------------------------------

figure
rlocus(G)
grid on
title('Lugar das raízes do sistema contínuo de malha fechada')

% ------------------------------------------
% exercicio 14
% ------------------------------------------

figure
bode(G)
margin(G)
grid on
title('Diagrama de Bode com margens de ganho e fase')

%------------------------------------------------------
% exercicio 16
% -------------------------------------------------------

T0 = T0f;

Gz = c2d(G, T0, 'zoh');
Gmfz = feedback(K*Gz, 1);

disp('Malha aberta discreta Gz')
disp(Gz)

disp('Malha fechada discreta Gmfz')
disp(Gmfz)

% ----------------------------------------
% EXERCICIO 17
% ----------------------------------------

polos_mf_cont = pole(Gmf);
zeros_mf_cont = zero(Gmf);

polos_mf_disc = pole(Gmfz);
zeros_mf_disc = zero(Gmfz);

disp('Polos da malha fechada continua:')
disp(polos_mf_cont)

disp('Zeros da malha fechada continua:')
disp(zeros_mf_cont)

disp('Polos da malha fechada discreta:')
disp(polos_mf_disc)

disp('Zeros da malha fechada discreta:')
disp(zeros_mf_disc)

% ----------------------------------------
% EXERCICIO 18
% ----------------------------------------

figure

step(R*Gmf, 24)
hold on
step(R*Gmfz, 24)

grid on
title('Resposta ao degrau da malha fechada')
xlabel('Tempo (s)')
ylabel('Saída y')
legend('Contínuo', 'Discreto', 'Location', 'best')

% ----------------------------------------
% EXERCICIO 20
% ----------------------------------------

figure

step(R*Gmf, 24)
hold on
step(R*Gmfz, 24)

grid on
title('Resposta ao degrau da malha fechada para K=8')
xlabel('Tempo (s)')
ylabel('Saída y')
legend('Contínuo', 'Discreto', 'Location', 'best')

% ----------------------------------------
% EXERCICIO 20
% ----------------------------------------

figure

step(R*Gmf, 24)
hold on
step(R*Gmfz, 24)

grid on
title('Resposta ao degrau da malha fechada para K=8')
xlabel('Tempo (s)')
ylabel('Saída y')
legend('Contínuo', 'Discreto', 'Location', 'best')

% ----------------------------------------
% EXERCICIO 23
% ----------------------------------------

Kp_vals = [1 5 8];
d = -0.15;  
r = R;       

ess_antes = r ./ (1+Kp_vals);
ess_depois = (r-d) ./ (1+Kp_vals);

ess_antes_pct = 100*ess_antes/r;
ess_depois_pct = 100*ess_depois/r;

table(Kp_vals', ess_antes', ess_depois', ess_antes_pct', ess_depois_pct', ...
    'VariableNames', {'Kp','ess_antes','ess_depois','ess_antes_pct','ess_depois_pct'})

% ----------------------------------------
% EXERCICIO 27
% ----------------------------------------

ess_pct = 14.5; 
Kp_27 = 100/ess_pct - 1;
disp('Kp necessario para ess% especificado:')
disp(Kp_27)

% ----------------------------------------
% EXERCICIO 28
% ----------------------------------------

figure

step(R*Gmf, 24)
hold on
step(R*Gmfz, 24)

grid on
title('Resposta ao degrau da malha fechada para K=5.8966')
xlabel('Tempo (s)')
ylabel('Saída y')
legend('Contínuo', 'Discreto', 'Location', 'best')
