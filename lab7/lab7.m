% ----------------------------------------
% Refazendo coisas do lab 4
% ----------------------------------------

% ----------------------------------------
% EXERCICIO 27
% ----------------------------------------

ess_pct = 14.5; 
Kp = 100/ess_pct - 1;
disp('Kp necessario para ess% especificado:')
disp(Kp)

% ------------------------------------------
% Função de transferência
% ------------------------------------------

wn = 0.77;
zeta = 1.013;
R = 1.17;

Gp = tf(wn^2, [1 2*zeta*wn wn^2]);

% -------------------------------------------
% Tkp
% -----------------------------------------
Gmfc = feedback(Kp*Gp, 1);
wb = bandwidth(Gmfc);
fb = wb/(2*pi);
fs = 10*fb;
Tkp = 1/fs;
disp("Tkp:")
Tkp

%------------------------------------------
% planta discretizada com zero holder
% ---------------------------------------
Gz = c2d(Gp, Tkp, 'zoh');
disp("planta discretizada com zero holder")
Gz

%% =========================================
% TEMPO DE SUBIDA E TEMPO DE ACOMODAÇÃO
% a partir da saída do Simulink out.y
% ==========================================

t = out.y.Time;
y = out.y.Data;

% Instante em que o distúrbio entra
t_dist = 12;

% Selecionar apenas a resposta ANTES do distúrbio
idx = t < t_dist;

t_antes = t(idx);
y_antes = y(idx);

%% Estimar valor de regime permanente antes do distúrbio
% média dos últimos 10 pontos antes de t = 12 s
N = min(10, length(y_antes));
yss = mean(y_antes(end-N+1:end));

%% Calcular características da resposta
info = stepinfo(y_antes, t_antes, yss, ...
    'RiseTimeLimits', [0.1 0.9], ...
    'SettlingTimeThreshold', 0.02);

tr = info.RiseTime;
ts = info.SettlingTime;

%% Mostrar resultados

fprintf('Valor de regime permanente yss = %.4f V\n', yss);
fprintf('Tempo de subida tr = %.4f s\n', tr);
fprintf('Tempo de acomodacao ts (2%%) = %.4f s\n', ts);

figure
plot(t_antes, y_antes, 'LineWidth', 1.2)
grid on
hold on

% valor final
yline(yss, '--')

% faixa de acomodação de 2%
yline(1.02*yss, ':')
yline(0.98*yss, ':')

% marcar tr e ts
xline(tr, '--')
xline(ts, '--')

xlabel('Tempo (s)')
ylabel('Saída y')
title('Resposta antes do distúrbio')

legend('y(t)', ...
       'y_{ss}', ...
       '+2%', ...
       '-2%', ...
       't_r', ...
       't_s')

% --------------------------------
% exercicio 4
% ---------------------------------
%% Dados do sistema

Tkp = 0.2241;

% Planta discretizada
Gz = tf([0.01326 0.0118], ...
        [1 -1.68 0.705], ...
        Tkp);

% Controlador PID projetado
Cpid = 1.4279 * tf([1 -1.548 0.601], ...
                   [1 -1 0], ...
                   Tkp);

disp('Controlador PID:')
Cpid

%% Questão 4 - Função de transferência de malha fechada

Gmf_pid = feedback(Cpid*Gz, 1);

disp('Função de transferência discreta de malha fechada:')
Gmf_pid

% ----------------------
% exercicio 5
% -------------------
%% Questão 5 - Polos e zeros da malha fechada

polos = pole(Gmf_pid);
zeros = zero(Gmf_pid);

disp('Polos da malha fechada:')
disp(polos)

disp('Zeros da malha fechada:')
disp(zeros)

% ---------------------------------------------------
% exercicio 8
% --------------------------------------------------

%% =========================================================
% DADOS DO SIMULINK
% ==========================================================

% Controlador proporcional
te = out.e.Time;
e  = squeeze(out.e.Data);

tu = out.u.Time;
u  = squeeze(out.u.Data);

ty = out.y.Time;
y  = squeeze(out.y.Data);

% Controlador PID
tepid = out.epid.Time;
epid  = squeeze(out.epid.Data);

tupid = out.upid.Time;
upid  = squeeze(out.upid.Data);

typid = out.ypid.Time;
ypid  = squeeze(out.ypid.Data);

% Parâmetros
td = 12;       % instante do distúrbio
R  = 1.17;     % referência

figure

stairs(te, e, 'LineWidth', 1.2)
hold on
stairs(tepid, epid, 'LineWidth', 1.2)

grid on
xlabel('Tempo (s)')
ylabel('Erro e(k)')
title('Sinal de erro')
legend('Proporcional', 'PID', 'Location', 'best')

figure

stairs(tu, u, 'LineWidth', 1.2)
hold on
stairs(tupid, upid, 'LineWidth', 1.2)

% Limites da planta
yline(10, '--')
yline(-10, '--')

grid on
xlabel('Tempo (s)')
ylabel('Sinal de controle u(k)')
title('Sinal de controle')
legend('Proporcional', 'PID', '+10 V', '-10 V', ...
       'Location', 'best')

figure

stairs(ty, y, 'LineWidth', 1.2)
hold on
stairs(typid, ypid, 'LineWidth', 1.2)

yline(R, '--', 'Referência')

grid on
xlabel('Tempo (s)')
ylabel('Saída y(k)')
title('Saída do sistema')
legend('Proporcional', 'PID', 'Referência', ...
       'Location', 'best')

%% =========================================================
% QUESTÃO 9
% ==========================================================

% PID - antes do distúrbio
idx_pid_antes = (tepid >= 10) & (tepid < 12);
ess_pid_antes = mean(epid(idx_pid_antes));

% PID - após o distúrbio
idx_pid_depois = (tepid >= 22) & (tepid <= 24);
ess_pid_depois = mean(epid(idx_pid_depois));

% Proporcional - antes
idx_p_antes = (te >= 10) & (te < 12);
ess_p_antes = mean(e(idx_p_antes));

% Proporcional - depois
idx_p_depois = (te >= 22) & (te <= 24);
ess_p_depois = mean(e(idx_p_depois));

fprintf('\n--- ERROS DE REGIME ---\n')

fprintf('Proporcional antes = %.6f V\n', ess_p_antes);
fprintf('Proporcional depois = %.6f V\n', ess_p_depois);

fprintf('PID antes = %.6f V\n', ess_pid_antes);
fprintf('PID depois = %.6f V\n', ess_pid_depois);

%% =========================================================
% QUESTÃO 10 - DESEMPENHO
% ==========================================================

% Resposta antes do distúrbio

idx_P = ty < td;
tP = ty(idx_P);
yP = y(idx_P);

idx_PID = typid < td;
tPID = typid(idx_PID);
yPID = ypid(idx_PID);

% Valores finais

yss_P = mean(y((ty >= 10) & (ty < 12)));
yss_PID = mean(ypid((typid >= 10) & (typid < 12)));

% stepinfo

info_P = stepinfo(yP,tP,yss_P, ...
    'RiseTimeLimits',[0.1 0.9], ...
    'SettlingTimeThreshold',0.02);

info_PID = stepinfo(yPID,tPID,yss_PID, ...
    'RiseTimeLimits',[0.1 0.9], ...
    'SettlingTimeThreshold',0.02);

% Tabela

Resultados = table( ...
    [info_P.RiseTime; info_PID.RiseTime], ...
    [info_P.SettlingTime; info_PID.SettlingTime], ...
    [info_P.PeakTime; info_PID.PeakTime], ...
    [info_P.Overshoot; info_PID.Overshoot], ...
    'RowNames',{'Proporcional','PID'}, ...
    'VariableNames',{'tr_s','ts_s','tp_s','Mp_pct'});

disp(Resultados)